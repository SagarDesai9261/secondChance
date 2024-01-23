import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneratePinPage extends StatefulWidget {
  @override
  State<GeneratePinPage> createState() => _GeneratePinPageState();
}

class _GeneratePinPageState extends State<GeneratePinPage> {
  String pinNumber = "";
  int wallet = 0;

  @override
  void initState() {
    super.initState();
    fetchPinNumber();
  }

  void fetchPinNumber() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("HomeLessMembers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey("pinNumber")) {
          setState(() {
            pinNumber = data["pinNumber"];
            wallet = data["walletBalance"] == "" ? 0 : int.parse(data["walletBalance"].toString());
          });
        } else {
          // The "pinNumber" field does not exist in the document.
        }
      } else {
        // The document does not exist.
      }
    } catch (e) {
      // Handle any potential errors here.
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: const Text(
          'Pay',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.grey,
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'Share your unique pin with merchant\n \t\t\t\t\t\t\t\t\t\t\tto complete transaction',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(40),
              child: DottedBorder(
                color: Colors.black,
                strokeWidth: 3,
                dashPattern: [10, 6],
                child: Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "$pinNumber",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'You are paying USD 20 to 7-Eleven',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Available Wallet Balance is USD $wallet',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
