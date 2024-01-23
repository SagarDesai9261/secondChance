import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Second Chance Organization',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
            );
          },
          child: Text('View Privacy Policy'),
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for Second Chance',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Effective Date: 18-12-2023',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Thank you for choosing to be part of the Second Chance Organization. We are committed to protecting your privacy and ensuring the confidentiality of the personal information you provide to us. This Privacy Policy outlines our practices concerning the collection, use, and disclosure of personal information in the context of our organization\'s mission to assist individuals facing financial hardship or homelessness.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'By accessing our services or participating in our programs, you agree to the terms outlined in this Privacy Policy.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Information We Collect:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We collect personal information to understand and address the needs of individuals seeking assistance. The types of information we may collect include:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              '- Personal Identifiers: Name, contact information, date of birth, and other information that identifies you.',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '- Financial Information: Details about your financial situation, including income, expenses, and debts.',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '- Housing Information: Details about your current living situation and any housing-related challenges.',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '- Supporting Documentation: Documents that support your request for assistance, such as pay stubs, bills, or other relevant records.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '2. How We Use Your Information:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We use the information collected to:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              '- Assess eligibility for our programs and services.',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '- Provide financial assistance and support to those in need.',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '- Communicate with you regarding your application or participation in our programs.',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              '- Improve and tailor our services based on feedback and evolving needs.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '3. Information Sharing:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as required by law or as necessary to provide you with the requested services.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Data Security:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We implement security measures to protect the confidentiality and integrity of your personal information. However, no data transmission over the internet or electronic storage is completely secure, and we cannot guarantee absolute security.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '5. Your Choices:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'You have the right to review, edit, or delete your personal information. If you wish to do so or have any concerns about your privacy, please contact us using the information provided at the end of this policy.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Updates to the Privacy Policy:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may update this Privacy Policy from time to time. Any changes will be posted on our website with the updated effective date.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '7. Contact Information:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),


            SizedBox(height: 16.0),
            Text(
              'Thank you for trusting the Second Chance Organization with your personal information. We are dedicated to providing a second chance and ensuring your privacy is respected throughout the process.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
