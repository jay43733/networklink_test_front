import 'package:flutter/material.dart';
import 'package:networklist_test/models/carts.dart';
import 'package:networklist_test/pages/home.dart';
import 'package:networklist_test/pages/register.dart';
import 'package:networklist_test/widget/widget_support.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _isPasswordHidden = false;

  @override
  Widget build(BuildContext context) {
    void hdlLogin() {
      if (_formKey.currentState?.validate() ?? false) {
        _formKey.currentState?.save();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (ctx) => Home(
                    cartItems: cartItems,
                  )),
        );
      } else {
        print("Form is not valid");
      }
    }

    void hdlGoToRegister() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Register()),
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
            _buildLoginButton(hdlLogin),
            _buildRegisterButton(hdlGoToRegister),
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
          "Welcome to",
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
                // Regular expression for validating an email
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
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(VoidCallback hdlLogin) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Color(0xFF7A5C61),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: hdlLogin,
          child: Text(
            "Log in",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(VoidCallback hdlGoToRegister) {
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
          onPressed: hdlGoToRegister,
          child: Text(
            "No account yet? Register",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
