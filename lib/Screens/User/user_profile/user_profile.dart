import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Services/secureStorage.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String name = "User";
  String address = "User Address";
  String age = "User age";
  String gender = "User Gender";
  String link = "User Report";
  String mobile = "User Mobile";

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100.0)),
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/user.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Age: $age",
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoRow(label: 'Address', value: address),
                  UserInfoRow(label: 'Mobile', value: mobile),
                  UserInfoRow(label: 'Gender', value: gender),
                  UserInfoRow(label: 'Doc Link', value: link),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getUserDetails() async {
    SecureStorage secureStorage = SecureStorage();
    name = await secureStorage.readSecureData("uname");
    age = await secureStorage.readSecureData("uage");
    address = await secureStorage.readSecureData("uaddress");
    mobile = await secureStorage.readSecureData("umobile");
    gender = await secureStorage.readSecureData("ugender");
    link = await secureStorage.readSecureData("ulink");
    setState(() {});
  }
}

class UserInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: label == 'Doc Link'
                ? InkWell(
                    onTap: () async {
                      if (await canLaunch(value)) {
                        await launch(value);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open link')),
                        );
                      }
                    },
                    child: Text(
                      value,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
