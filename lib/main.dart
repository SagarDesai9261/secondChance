import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homelessapp/screen/loginscreen.dart';
import 'package:homelessapp/screen/myprofile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'NotificationService.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A Background message just showed up: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Firebase local notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
      child: MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationService().requestNotificationPermission();
    var token = NotificationService().getDeviceToken();
    print(token.toString());
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> list;
      if (prefs.getStringList("notification_data") != null) {
        list = prefs.getStringList("notification_data")!;
      } else {
        list = [];
      }
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      String date = DateTime.now().toString();
      if (notification != null && android != null) {
        list.add(json.encode({
          'notification_hascode': notification.hashCode,
          'notification_title': notification.title,
          'notification_body': notification.body,
          'notification_time': date,
        }));
        prefs.setStringList("notification_data", list);
        print(list);
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('A new message open app event was published');
      List<String> list;
      if (prefs.getStringList("notification_data") != null) {
        list = prefs.getStringList("notification_data")!;
      } else {
        list = [];
      }
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        DateTime now = DateTime.now();
        String date = DateTime.now().toString();
        list.add(json.encode({
          'notification_hascode': notification.hashCode,
          'notification_title': notification.title,
          'notification_body': notification.body,
          'notification_time': date,
        }));
        prefs.setStringList("notification_data", list);
        print(list);
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title!),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body!)],
                ),
              ),
            );
          },
        );
      }
    });
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProfileProvider()),
          ],
          child: Login_screen()),
    );
  }
}
