import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Define the User class to hold user information
class User {
  final String email;
  final String fullname;
  String image;
  final String gender;
  final String year;
  final String phone;
  final String location;
  final String about;

  User({
    required this.email,
    required this.fullname,
    required this.image,
    required this.gender,
    required this.year,
    required this.phone,
    required this.location,
    required this.about,
  });
}

// Create a provider class for managing user profiles
class UserProfileProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _user;

  User? get user => _user;

  // Fetch the user's profile from Firebase
  Future<void> fetchUserProfile() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userData = await _firestore
          .collection('HomeLessMembers')
          .doc(currentUser.uid)
          .get();
      _user = User(
        email: currentUser.email ?? '',
        fullname: userData['fullName'] ?? '',
        image: userData['profileImageUrl'] ?? '',
        gender: userData['gender'] ?? '',
        year: userData['dob'] ?? '',
        phone: userData['phone'] ?? '',
        location: userData['address'] ?? '',
        about: userData['about'] ?? '',
      );
      notifyListeners();
    }
  }

  // Update the user's profile in Firebase
  Future<void> updateProfile(User updatedUser) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore
          .collection('HomeLessMembers')
          .doc(currentUser.uid)
          .update({
        'fullName': updatedUser.fullname,
        'profileImageUrl': updatedUser.image,
        'gender': updatedUser.gender,
        'dob': updatedUser.year,
        'phone': updatedUser.phone,
        'address': updatedUser.location
      });
      _user = updatedUser;
      notifyListeners();
    }
  }

  // Upload an image to Firebase Storage
  Future<String?> uploadImageToStorage(String filePath) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final storageRef = _storage
          .ref()
          .child('profile_images')
          .child(currentUser.uid + '.jpg');
      final uploadTask = storageRef.putFile(File(filePath));
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    }
    return null;
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  DateTime? date;

  @override
  void initState() {
    super.initState();
    context.read<UserProfileProvider>().fetchUserProfile();
  }

  TextEditingController _textEditingController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date ?? now,
        firstDate: now,
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      print('hello $picked');
      setState(() {
        date = picked;
      });
    }
  }

  Widget buildDateField(String dobdate) {
    /* DateTime data = DateTime.parse(dobdate);
    dobdate = data.year.toString() + "/" + data.month.toString() + "/" + data.day.toString();

    _textEditingController.text = dobdate;*/
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: ShapeDecoration(
          color: const Color(0xFFEDF9F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Image.asset("assets/year.png"),
      ),
      title: TextFormField(
        controller: _textEditingController,
        onTap: () async {
          // Below line stops keyboard from appearing
          //  FocusScope.of(context).requestFocus(new FocusNode());
          // Show Date Picker Here
          await _selectDate(context);
          setState(() {
            _textEditingController.text =
                DateFormat('yyyy/MM/dd').format(date!);
          });

          //setState(() {});
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Date of Birth',
        ),
      ),
      trailing: Container(
          width: 40,
          height: 40,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Image.asset("assets/arrow.png")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfileProvider>().user;
    if (_textEditingController.text == null ||
        _textEditingController.text.isEmpty) {
      setState(() {
        DateTime data = DateTime.parse(userProfile!.year);
        var dobdate = data.year.toString() +
            "/" +
            data.month.toString() +
            "/" +
            data.day.toString();

        _textEditingController.text = dobdate;
        //  _textEditingController.text = userProfile!.year;
      });
    }
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Homeless',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: ShapeDecoration(
                            image: userProfile!.image == "null"
                                ? DecorationImage(
                                    image: AssetImage("assets/noImage.png"),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(userProfile!.image),
                                    fit: BoxFit.fill),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: Color(0xFF43BA82),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final updatedUser = User(
                              email: userProfile.email,
                              fullname: _fullnameController.text,
                              image: userProfile
                                  .image, // Keep the current image URL
                              gender: _genderController.text,
                              location: _locationController.text,
                              year: _textEditingController.text,
                              phone: _phoneController.text,
                              about: aboutController.text
                            );

                            final imageFilePath = await ImagePicker().pickImage(
                                source: ImageSource
                                    .gallery); // Implement this function

                            if (imageFilePath != null) {
                              final newImageURL = await context
                                  .read<UserProfileProvider>()
                                  .uploadImageToStorage(imageFilePath.path);

                              if (newImageURL != null) {
                                updatedUser.image = newImageURL;
                              }
                            }

                            // Update user data in Firestore with the new image URL.
                            await context
                                .read<UserProfileProvider>()
                                .updateProfile(updatedUser);
                          },
                          child: Container(
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.only(left: 40, top: 90),
                            decoration: const ShapeDecoration(
                              //color: Color(0xFF43BA82),
                              shape: OvalBorder(
                                side: BorderSide(width: 1, color: Colors.white),
                              ),
                            ),
                            child: Image.asset("assets/edit_image.png"),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.white,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF43BA82),
                              ),
                            ),
                            title: TextFormField(
                              // initialValue: snapshot.data!.fullName,
                              controller: _fullnameController
                                ..text = userProfile.fullname,
                              decoration: InputDecoration(
                                hintText: "Enter FullName",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {},
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(
                                height: 2,
                                thickness: 2,
                              )),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Icon(
                                Icons.phone,
                                color: Color(0xFF43BA82),
                              ),
                            ),
                            title: TextFormField(
                              controller: _phoneController
                                ..text = userProfile.phone,
                              decoration: InputDecoration(
                                hintText: "1234567890",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Image.asset("assets/arrow.png"),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(
                                height: 2,
                                thickness: 2,
                              )),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Icon(
                                Icons.mail,
                                color: Color(0xFF43BA82),
                              ),
                            ),
                            title: TextFormField(
                              controller: _emailController
                                ..text = userProfile.email,
                              decoration: InputDecoration(
                                hintText: "Enter Email",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing: InkWell(
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(
                                height: 2,
                                thickness: 2,
                              )),
                          buildDateField(userProfile.year),

                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(
                                height: 2,
                                thickness: 2,
                              )),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image.asset("assets/location.png"),
                            ),
                            title: TextFormField(
                              controller: _locationController
                                ..text = userProfile.location,
                              decoration: InputDecoration(
                                hintText: "Enter Location",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {},
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(
                                height: 2,
                                thickness: 2,
                              )),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image.asset(
                                "assets/gender.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            title: TextFormField(
                              controller: _genderController
                                ..text = userProfile.gender,
                              decoration: InputDecoration(
                                hintText: "Enter Gender",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {},
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: const Divider(
                                height: 2,
                                thickness: 2,
                              )),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(8),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEDF9F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Icon(Icons.info_outline, color: Color(0xFF43BA82))
                            ),
                            title: TextFormField(
                              controller: aboutController
                                ..text = userProfile.about,
                              decoration: InputDecoration(
                                hintText: "About",
                                border: InputBorder.none,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {},
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Image.asset("assets/arrow.png")),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //buildDateField()
            ],
          ),
        ),
      ),
    );
  }

  int calculateAge(DateTime dob) {
    DateTime now = DateTime.now();
    int age = now.year - dob.year;

    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }

    return age;
  }
}
