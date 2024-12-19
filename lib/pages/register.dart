import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:networklist_test/models/carts.dart';
import 'package:networklist_test/pages/home.dart';
import 'package:networklist_test/pages/login.dart';
import 'package:networklist_test/pages/register.dart';
import 'package:networklist_test/widget/widget_support.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  bool _isPasswordHidden = false;

  @override
  Widget build(BuildContext context) {
    void showErrorWithSnackBar(BuildContext context, String message) {
      final snackBar =
          SnackBar(content: Text(message), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void hdlCreateAccount() async {
      print("Form is valid $_confirmPassword, $_password, $_email");
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();

        // API URL for register
        final url = Uri.parse('http://10.0.2.2:8008/register');
        final headers = {"Content-Type": 'application/json'};
        final body = jsonEncode({
          'email': _email,
          "password": _password,
          "confirmPassword": _confirmPassword
        });

        try {
          final response = await http.post(url, headers: headers, body: body);

          if (response.statusCode == 200) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => LoginPage()),
            );
          } else {
            final Map<String, dynamic> result = jsonDecode(response.body);
            final errorMessage = result["error"] ?? "Unknown error";
            showErrorWithSnackBar(context, errorMessage);
          }
        } catch (e) {
          showErrorWithSnackBar(context, "Network error: $e");
        }
      }
    }

    void hdlGoToLogin() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFECF1F6),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          children: [
            // _buildHeader(context),
            SizedBox(height: 10),
            _buildWelcomeText(),
            SizedBox(height: 20),
            _buildImage(),
            SizedBox(height: 20),
            _buildForm(),
            SizedBox(height: 20),
            _buildCreateAccountButton(hdlCreateAccount),
            _buildLoginButton(hdlGoToLogin),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.arrow_back_rounded, size: 30, color: Color(0xFF7A5C61)),
        Row(
          children: [
            Text("Coffee Cafe", style: AppWidget.normalTextFieldStyle()),
            SizedBox(width: 10),
            Image.asset('assets/images/logo.png', height: 30),
          ],
        ),
        Icon(Icons.account_circle_outlined, color: Color(0xFF7A5C61), size: 34),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          "Sign Up for",
          style: AppWidget.SubHead1BoldTextFieldStyle(),
        ),
        Text(
          "Coffee Cafe",
          style: AppWidget.HeadLine1BoldTextFieldStyle(),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Center(
      child: Image.asset(
        "assets/images/chocolate-drink.png",
        height: 150,
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                label: Text(
                  "Email",
                  style: AppWidget.SubTitleNormalTextFieldStyle(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Type your email";
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) {
                  return "Please enter a valid email";
                }
                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              maxLength: 10,
              obscureText: !_isPasswordHidden,
              decoration: InputDecoration(
                label: Text(
                  "Password",
                  style: AppWidget.SubTitleNormalTextFieldStyle(),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                  icon: Icon(_isPasswordHidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Type your password";
                }
                if (value.length < 6) {
                  return "Password must contain at least 6 characters.";
                }
                return null;
              },
              onChanged: (value) {
                _formKey.currentState?.validate();
                print("Password: $value");
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            TextFormField(
              maxLength: 10,
              obscureText: !_isPasswordHidden,
              decoration: InputDecoration(
                label: Text(
                  "Confirm Password",
                  style: AppWidget.SubTitleNormalTextFieldStyle(),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordHidden = !_isPasswordHidden;
                    });
                  },
                  icon: Icon(_isPasswordHidden
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Confirm your password";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _confirmPassword = value;
                });
                _formKey.currentState?.validate();
                print("Confirm: $_confirmPassword");
              },
              onSaved: (value) {
                _confirmPassword = value!;
                print("Confirmmmmmm: $_confirmPassword");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton(VoidCallback hdlCreateAccount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Color(0xFF7A5C61),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: hdlCreateAccount,
          child: Text(
            "Create Account",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(VoidCallback hdlGoToLogin) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Color(0xFF7A5C61)),
            foregroundColor: Color(0xFF7A5C61),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: hdlGoToLogin,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Icon(
                Icons.arrow_back_outlined,
                color: Color(0xFF7A5C61),
              ),
              Text(
                "Back to Login",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
