import 'package:flutter/material.dart';

class Notification_Page extends StatefulWidget {
  const Notification_Page({Key? key}) : super(key: key);

  @override
  State<Notification_Page> createState() => _Notification_PageState();
}

class _Notification_PageState extends State<Notification_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color.fromRGBO(237, 237, 237, 1),
      body: Center(
        child: Text("No Notifications Found"),
      ),
    );
  }
}
