import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homelessapp/NotificationService.dart';
import 'package:homelessapp/screen/homepage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_screen extends StatefulWidget {
  const Login_screen({Key? key}) : super(key: key);

  @override
  State<Login_screen> createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {
  String error = "";
  bool pass = true;
  bool isloading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final form_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: form_key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .9,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          ),
                          const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                 // color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Center(
                            child: Text(
                              "Welcome to SecondChance",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Please enter email";
                                }else if (!RegExp(
                                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              controller: email,

                              decoration: InputDecoration(
                                  hintText: "Email address",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)
                                      //borderSide: BorderSide.none
                                      )),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Please enter password";
                                }
                                return null;
                              },
                              controller: password,
                              obscureText: pass,
                              decoration: InputDecoration(
                                  suffixIcon: pass
                                      ? IconButton(
                                          icon: const Icon(Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              pass = false;
                                            });
                                          },
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              pass = true;
                                            });
                                          },
                                        ),
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)
                                      //borderSide: BorderSide.none
                                      )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              showAlertDialog(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width * .15),
                              alignment: Alignment.topRight,
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if(form_key.currentState!.validate()){
                                setState(() {
                                  isloading = true;
                                });
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text);
                                  final user = FirebaseAuth.instance.currentUser;
                                  if(user!.displayName == "HomelessMember"){
                                      final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('HomeLessMembers').doc(user.uid).get();
                                      final isApprove = snapshot.get('isApprove');
                                      var token = await NotificationService().getDeviceToken();
                                      print(token);
                                      FirebaseFirestore.instance.collection("HomeLessMembers").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        "token":token
                                      }).catchError((e)=>print(e));
                                      var OID = await getOrganizationId();
                                      print(OID);
                                      SharedPreferences prefs = await SharedPreferences.getInstance() ;
                                      prefs.setString("old",OID);
                                      setState(() {
                                        error = "";
                                        isloading = false;
                                      });
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(oid: OID,)));
                                      /*if(isApprove == true){
                                        var token = await NotificationService().getDeviceToken();
                                        print(token);
                                        FirebaseFirestore.instance.collection("HomeLessMembers").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                          "token":token
                                        }).catchError((e)=>print(e));
                                        var OID = await getOrganizationId();
                                        print(OID);
                                        SharedPreferences prefs = await SharedPreferences.getInstance() ;
                                        prefs.setString("old",OID);
                                        setState(() {
                                          error = "";
                                          isloading = false;
                                        });
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(oid: OID,)));
                                      }
                                      else{
                                        showalert("Your Organization Profile is under verifing", AlertType.warning, context);
                                      }*/
                                  }
                                  else{
                                    showalert("Email is not register in HomelessMember", AlertType.error, context);
                                  }



                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    showalert("Email and Password are not match", AlertType.error, context);
                                    error = "";
                                  });
                                }

                                // Simulate a login request.
                                await Future.delayed(const Duration(seconds: 3));
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>Navbar_screen()));
                                setState(() {
                                  isloading = false;
                                });
                                if (error != "") {
                                  // Alert(context: context,type: AlertType.error,title: error.toString()).show();
                                } else {
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Navbar_screen()));
                                }
                              }

                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * .6,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: isloading == false
                                    ? const Text('Sign to your Account',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'SF Pro Text',
                                          fontWeight: FontWeight.w600,
                                          height: 2,
                                        ))
                                    : const Center(
                                        child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
    );
  }
  showalert(message,type,BuildContext context){
    return Alert(context: context,title: message,type: type,buttons: [
      DialogButton(
        child: Text(
          "Ok",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {Navigator.pop(context);
        setState(() {
          isloading = false;
        });
        } ,
        width: 120,
      )
    ],).show();
  }
  Future<String> getOrganizationId() async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
        .collection('HomeLessMembers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (documentSnapshot.exists) {
      final organizationId = documentSnapshot.data()?['organizationId'];
      print(organizationId);
      return organizationId;
    } else {
      return ""; // Handle the case where no document with the current UID is found
    }
  }

  showAlertDialog(BuildContext context) {
    TextEditingController _emailController = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final emailField = TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
              hintText: 'something@example.com',
              // labelText: 'Account Email to Reset',
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              hintStyle: const TextStyle(
                color: Colors.black,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
        );

        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 3,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Reset Password Link",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                emailField,
                MaterialButton(
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _emailController.text);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    padding: const EdgeInsets.all(15.0),
                    child: Material(
                        color: const Color(0xFF46BA80),
                        borderRadius: BorderRadius.circular(25.0),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'helvetica_neue_light',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
