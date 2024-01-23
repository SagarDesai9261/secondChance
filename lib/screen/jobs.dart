import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import 'Messages/chat_person.dart';
import 'Messages/chats.dart';

class Job {
  final String title;
  final String location;
  final String description;
  final String postedDate;
  final String uid;
  Job({
    required this.title,
    required this.location,
    required this.description,
    required this.postedDate,
    required this.uid,
  });
}

class Jobs extends StatefulWidget {
  const Jobs({Key? key}) : super(key: key);
  @override
  State<Jobs> createState() => _JobsListState();
}


class _JobsListState extends State<Jobs> {
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    // Fetch data from Firebase when the widget initializes
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('DonorjobPosts').get();

      final newJobs = snapshot.docs.map((document) {
        final data = document.data() as Map<String, dynamic>;

        // Add null checks for fields
        final title = data['jobTitle'] as String? ?? 'No Title';
        final location = data['jobLocation'] as String? ?? 'No Location';
        final description =
            data['jobDescription'] as String? ?? 'No Description';
        final postedDate = data['date'] as String? ?? 'No Date';
        final uid = data['uid'] as String? ?? 'No Data';

        return Job(
          title: title,
          location: location,
          description: description,
          postedDate: postedDate,
          uid: uid
        );
      }).toList();

      setState(() {
        jobs = newJobs;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  Future<void> fetchUserData(String uid) async {
    final orgCollection = FirebaseFirestore.instance.collection('users');
    final merchantCollection = FirebaseFirestore.instance.collection('merchants');
    final donorCollection = FirebaseFirestore.instance.collection('donor');

// Query the "users" collection for the document with the specified UID
    DocumentSnapshot<Map<String, dynamic>> orgDocument = await orgCollection.doc(uid).get();

// Query the "merchants" collection for the document with the specified UID
    DocumentSnapshot<Map<String, dynamic>> merchantDocument = await merchantCollection.doc(uid).get();

// Query the "donors" collection for the document with the specified UID
    DocumentSnapshot<Map<String, dynamic>> donorDocument = await donorCollection.doc(uid).get();
    print(donorDocument.exists);
    // Access data from the "users" collection
    Map<String, dynamic>? orgData = orgDocument.data() as Map<String, dynamic>?;
    if (orgData != null) {
      // You can now access the fields from the "users" document
      String name = orgData['name'];
      String email = orgData['email'];
      // Access other fields as needed
    }

// Access data from the "merchants" collection
    Map<String, dynamic>? merchantData = merchantDocument.data() as Map<String, dynamic>?;
    if (merchantData != null) {
      // You can now access the fields from the "merchants" document
      String companyName = merchantData['BusinessName'];
      String address = merchantData['StreetAddress'];
      final chatRoomRef =
      FirebaseFirestore.instance.collection('HomeLessMembers').doc(FirebaseAuth.instance.currentUser!.uid);
      // Add the current user's UID to the "participate" list
      await chatRoomRef.update({
        'usersChats': FieldValue.arrayUnion([uid]),
      });
      //  print(snapshot.data!.docs[index].id);
      final chat1RoomRef = FirebaseFirestore.instance.collection('merchants').doc(uid);
      // Add the current user's UID to the "participate" list
      await chat1RoomRef.update({
        'usersChats': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
      ChatPerson chatPerson = ChatPerson(
          senderId :FirebaseAuth.instance.currentUser!.uid,
          receiverId:uid,
          name:merchantData["BusinessName"]
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen(chatPerson: chatPerson,)));
      //String donationType = donorData['donationType'];

      // Access other fields as needed
    }

// Access data from the "donors" collection
    Map<String, dynamic>? donorData = donorDocument.data() as Map<String, dynamic>?;
    if (donorData != null) {
      // You can now access the fields from the "donors" document
      String donorName = donorData['fullName'];
      print(donorName);
      final chatRoomRef =
      FirebaseFirestore.instance.collection('HomeLessMembers').doc(FirebaseAuth.instance.currentUser!.uid);
      // Add the current user's UID to the "participate" list
      await chatRoomRef.update({
        'usersChats': FieldValue.arrayUnion([uid]),
      });
      //  print(snapshot.data!.docs[index].id);
      final chat1RoomRef = FirebaseFirestore.instance.collection('donor').doc(uid);
      // Add the current user's UID to the "participate" list
      await chat1RoomRef.update({
        'usersChats': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
      ChatPerson chatPerson = ChatPerson(
          senderId :FirebaseAuth.instance.currentUser!.uid,
          receiverId:uid,
          name:donorData["fullName"]
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatScreen(chatPerson: chatPerson,)));
      //String donationType = donorData['donationType'];
      // Access other fields as needed
    }

  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference jobPostsCollection =
    FirebaseFirestore.instance.collection('DonorjobPosts');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Color.fromRGBO(237,237,237, 1),
        child:StreamBuilder<QuerySnapshot>(
          stream: jobPostsCollection.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if(snapshot.data!.docs.length == 0){
              return Center(child: Container(child: Text("No JobPost Found")));
            }
            List<Job> jobs = snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Job(
                title: data['jobTitle'],
                location: data['jobLocation'],
                description: data['jobDescription'],
                postedDate: data['date'],
                uid: data['uid'],
              );
            }).toList();

            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];

                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 9),
                          Text(
                            job.title.toString(),
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Location: ${job.location.toString()}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 15),
                          Text(
                            job.description.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  fetchUserData(job.uid.toString());
                                },
                                child: Text(
                                  'Contact Owner',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 11, 137, 126)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(thickness: 1, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'Posted on ${job.postedDate.toString()}',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
