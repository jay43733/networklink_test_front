import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:networklist_test/widget/widget_support.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      String? token = await storage.read(key: 'accessToken');
      if (token != null) {
        final userResp = await http.get(
          Uri.parse('http://10.0.2.2:8008/me'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (userResp.statusCode == 200) {
          final userData = jsonDecode(userResp.body);
          setState(() {
            userEmail = userData['email'];
          });
          print("User Email: $userEmail");
        } else {
          print('Failed to load user: ${userResp.statusCode}');
        }
      } else {
        print('Token is null');
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFECF1F6),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 40),
              _buildInformation(screenWidth)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          child: Icon(Icons.arrow_back_rounded,
              color: Color(0xFF7A5C61), size: 34),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Coffee Cafe", style: AppWidget.normalTextFieldStyle()),
            SizedBox(width: 10),
            Image.asset('assets/images/logo.png', height: 30),
          ],
        ),
        Icon(Icons.account_circle_outlined, color: Color(0xFFECF1F6), size: 34),
      ],
    );
  }

  Widget _buildInformation(screenWidth) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/panda.png',
            height: 140,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              userEmail,
              style: AppWidget.HeadLine3BoldTextFieldStyle(),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Container(
              width: screenWidth * 0.6,
              child: FilledButton(
                style:
                    FilledButton.styleFrom(backgroundColor: Color(0xFF7A5C61)),
                child: Text(
                  "My Order",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
