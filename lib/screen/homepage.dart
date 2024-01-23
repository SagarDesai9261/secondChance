import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homelessapp/screen/drawer.dart';
import 'package:homelessapp/screen/walletscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  String oid;
  HomePage({super.key, required this.oid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white54,
        title: Text('Second Chance App'),
      ),
      body: HomeScreen(
        oid: widget.oid,
      ),
      endDrawer: DrawerScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  String oid;
  HomeScreen({required this.oid});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //setOID();
  }

  setOID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      OID = prefs.getString("oid") ?? "";
    });
  }

  String OID = "";
  @override
  Widget build(BuildContext context) {
    print(widget.oid == "");
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child:
            // Image.asset("assets/year.png"),
            SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Organization Details
              Text(
                'Organization Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.oid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(); // You can replace this with a loading indicator
                  }

                  if (!snapshot.data!.exists) {
                    return Text(
                        'Organization not found.'); // Handle the case where the organization doesn't exist
                  }

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  String name = data['organizationName'];
                  String address = data['address'];
                  String phone = data['phone'];

                  return ListTile(
                    leading: Image.asset("assets/year.png"),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text('Name: $name'),
                        Text('Address: $address'),
                        Text('Phone: $phone'),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              // Payment Details
              Text(
                'Payment Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Payment Method: Visa **** **** **** 1234'),
              Text('Expiration Date: 12/24'),
              SizedBox(height: 20),

              // Current Wallet
              Text(
                'Current Wallet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Balance: \$250.00'),
              SizedBox(height: 20),

              // Payment History
              Text(
                'Payment History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Payment from Vendor A'),
                subtitle: Text('Amount: \$150.00 - Date: 2023-10-13'),
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Payment to Vendor B'),
                subtitle: Text('Amount: \$100.00 - Date: 2023-10-14'),
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Payment from Vendor C'),
                subtitle: Text('Amount: \$150.00 - Date: 2023-10-14'),
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Payment to Vendor D'),
                subtitle: Text('Amount: \$150.00 - Date: 2023-10-15'),
              ),ListTile(
                leading: Icon(Icons.payment),
                title: Text('Payment to Vendor E'),
                subtitle: Text('Amount: \$100.00 - Date: 2023-10-15'),
              ),


              // Add more payment history items as needed
            ],
          ),
        ),
      ),
    );
  }
}
