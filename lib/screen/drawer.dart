import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homelessapp/screen/Messages/messages.dart';
import 'package:homelessapp/screen/notification.dart';
import 'package:homelessapp/screen/pay.dart';
import 'package:homelessapp/screen/privacy_policy.dart';

import 'package:homelessapp/screen/walletscreen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'Messages/chat_person.dart';
import 'jobs.dart';
import 'loginscreen.dart';
import 'myprofile.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .02),
              height: 130,
              child: StreamBuilder(
                stream: _getUserInfoStream(),
                builder: (context, AsyncSnapshot<UserInfo?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Text('No user data available.');
                  } else {
                    UserInfo userInfo = snapshot.data!;
                    return Column(
                      children: [
                        ListTile(
                          title: Text(userInfo.fullName),
                          subtitle: Text(userInfo.email),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              userInfo.imageUrl
                              ,),
                            maxRadius: 30,
                          ),

                        )
                      ],
                    );
                  }
                },
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wallet_page()));
              },
              title: Text(
                'My Wallet',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GeneratePinPage()));
              },
              title: Text(
                'Pay',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Jobs()));
              },
              title: Text(
                'Jobs',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              title: Text(
                'My Profile',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            StreamBuilder<int>(
              stream: getTotalUnreadMessagesCount(), // Use your stream here
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final unreadMessagesCount = snapshot.data!;
                  return ListTile(
                    title: Text('Messages',style: TextStyle(
                        color: Colors.black54
                    ),),
                    trailing: unreadMessagesCount !=0 ? CircleAvatar(
                        backgroundColor: Color(0xFF46BA80),
                        maxRadius: 15,
                        child: Text(unreadMessagesCount.toString(),style: TextStyle(
                            color: Colors.white
                        ),)):Text("0",style: TextStyle(color: Colors.white),),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserListScreen()),
                      );
                      // Handle Messages screen navigation
                      // Navigator.pop(context); // Close the drawer
                    },
                  );
                } else {
                  // Handle loading state or errors
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserListScreen()));
                    },
                    child: ListTile(
                      title: Text('Messages',style: TextStyle(
                          color: Colors.black54
                      ),),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Notification_Page()));
              },
              title: Text(
                'Notifications',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
              },
              title: Text(
                'Privacy Policy',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 1,
              ),
            ),
            ListTile(
              onTap: () {
                QuickAlert.show(
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                  onConfirmBtnTap: (){
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login_screen()));
                  },
                  context: context,
                  type: QuickAlertType.confirm,
                  text: 'Do you want to logout',
                  titleAlignment: TextAlign.center,
                  textAlignment: TextAlign.center,
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: Colors.green,
                  backgroundColor: Colors.white,
                  headerBackgroundColor: Colors.grey,
                  confirmBtnTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  cancelBtnTextStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  barrierColor: Colors.white,
                  titleColor: Colors.black,
                  textColor: Colors.black,
                );


              },
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                thickness: 1,
              ),
            ),
          ],
        ));
  }
  Stream<int> getTotalUnreadMessagesCount() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Get a list of chat IDs for the user
    return FirebaseFirestore.instance
        .collection('HomeLessMembers')
        .doc(userId)
        .snapshots()
        .asyncMap((snapshot) async {
      if (!snapshot.exists) {
        return 0;
      }

      final userChats = snapshot.get('usersChats') as List<dynamic>;

      // Create a list of individual chat streams with unread message counts
      final chatStreams = userChats.map((chatId) {
        return FirebaseFirestore.instance
            .collection('chats/${chatId + '_' + userId}/messages')
            .where('isRead', isEqualTo: false)
            .get()
            .then<int>((querySnapshot) => querySnapshot.size);
      });

      // Calculate the total count of unread messages
      final List<int> unreadCounts = await Future.wait(chatStreams);
      final totalUnreadMessagesCount = unreadCounts.reduce((a, b) => a + b);

      return totalUnreadMessagesCount;
    });
  }
  Stream<UserInfo?> _getUserInfoStream() {
    var user = _auth.currentUser!.uid;
    if (user != null) {
      return _firestore
          .collection('HomeLessMembers') // Change this to your users collection
          .doc(user)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return UserInfo(
            fullName: snapshot.get('fullName'),
            email: snapshot.get('email'),
            imageUrl: snapshot.get('profileImageUrl'),
          );
        } else {
          return null;
        }
      });
    } else {
      return Stream.empty();
    }
  }
}
class UserInfo {
  final String fullName;
  final String email;
  final String imageUrl;

  UserInfo({
    required this.fullName,
    required this.email,
    required this.imageUrl,
  });
}