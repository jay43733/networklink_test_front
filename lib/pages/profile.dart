import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:networklist_test/config.dart';
import 'package:networklist_test/pages/history.dart';
import 'package:networklist_test/pages/login.dart';
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
          Uri.parse('${Config.baseUrl}/me'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (userResp.statusCode == 200) {
          final userData = jsonDecode(userResp.body);
          setState(() {
            userEmail = userData['email'];
          });
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

  void hdlLogOut() async {
    try {
      String? token = await storage.read(key: 'accessToken');
      if (token != null) {
        await storage.delete(key: 'accessToken');
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => LoginPage()));
      }
    } catch (e) {
      print(e);
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
          Text(
            "Hello !",
            style: AppWidget.SubHead1BoldTextFieldStyle(),
          ),
          Text(
            "Account User",
            style: AppWidget.HeadLine1BoldTextFieldStyle(),
          ),
          SizedBox(height: 20),
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
              height: 48,
              child: FilledButton(
                style:
                    FilledButton.styleFrom(backgroundColor: Color(0xFF7A5C61)),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_outlined, size: 24, color: Colors.white),
                    Text(
                      "My Order",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => History()));
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Container(
              width: screenWidth * 0.6,
              height: 48,
              child: FilledButton(
                style:
                    FilledButton.styleFrom(backgroundColor: Color(0xFFEC0357)),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_outlined, color: Colors.white),
                    Text(
                      "Log out",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                onPressed: hdlLogOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
