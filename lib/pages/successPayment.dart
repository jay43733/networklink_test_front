import 'package:flutter/material.dart';
import 'package:networklist_test/models/carts.dart';
import 'package:networklist_test/pages/home.dart';
import 'package:networklist_test/widget/widget_support.dart';

class SuccessPayment extends StatefulWidget {
  final List<Carts> cartItems;
  const SuccessPayment({super.key, required this.cartItems});

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    print("cart: ${cartItems.length}");

    void hdlClearCart() {
      setState(() {
        widget.cartItems.clear();
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => Home(cartItems: widget.cartItems),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Color(0xFFECF1F6),
        body: SafeArea(
            child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 40),
            _buildSummary(screenHeight, hdlClearCart)
          ],
        )));
  }
}

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.arrow_back_rounded,
          size: 30,
          color: Color(0xFFECF1F6),
        ),
        Row(
          children: [
            Text("Coffee Cafe", style: AppWidget.normalTextFieldStyle()),
            SizedBox(width: 10),
            Image.asset('assets/images/logo.png', height: 30),
          ],
        ),
        Icon(Icons.account_circle_outlined, color: Color(0xFF7A5C61), size: 34),
      ],
    ),
  );
}

Widget _buildSummary(screenHeight, hdlClearCart) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    margin: EdgeInsets.symmetric(horizontal: 20),
    height: screenHeight * 0.4,
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(24)),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Your order will be served",
            style: AppWidget.HeadLine2BoldTextFieldStyle(),
          ),
          Image.asset(
            'assets/images/check.png',
            height: 100,
          ),
          FilledButton(
              onPressed: hdlClearCart,
              style: FilledButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  backgroundColor: Color(0xFF7A5C61)),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Okay",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ))
        ],
      ),
    ),
  );
}
