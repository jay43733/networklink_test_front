import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:networklist_test/models/carts.dart';
import 'package:networklist_test/models/product.dart';
import 'package:networklist_test/pages/home.dart';
import 'package:networklist_test/widget/widget_support.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final int userId;
  const ProductDetail({super.key, required this.product, required this.userId});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final storage = FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();
  late int _productId;
  late String _productName;
  late String _productImage;
  late int _price;
  int _amount = 1;
  Sweetness _sweetness = Sweetness.hundredPercent;

  // int userId = 0;
  @override
  void initState() {
    super.initState();
    _productId = widget.product.id;
    _productName = widget.product.title;
    _productImage = widget.product.imagePath;
    _price = widget.product.price;
  }

  void incrementAmount() {
    setState(() {
      _amount += 1;
    });
  }

  void decreaseAmount() {
    setState(() {
      _amount = _amount <= 0 ? 0 : _amount - 1;
    });
  }

  void createCart() async {
    try {
      String? token = await storage.read(key: "accessToken");
      if (token != null) {
        final url = Uri.parse('http://10.0.2.2:8008/carts');
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        };
        final sweetnessString = _sweetness.toString().split(".").last;
        final body = jsonEncode({
          'amount': _amount,
          "sweetness": sweetnessString,
          "productId": _productId
        });

        print('Sending request to $url with body: $body');

        final response = await http.post(url, headers: headers, body: body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 200) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Color(0xFF18B473),
                content: Text('Cart updated successfully!')),
          );
          _formKey.currentState!.reset();
        } else {
          print("Error: ${response.body}");
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => Home()),
      );
    } catch (e) {
      print("Fetching data :$e");
    }
  }

  // Computed property to calculate total price
  int get totalPrice => _price * _amount;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFECF1F6),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          children: [
            _buildHeader(context),
            SizedBox(height: 40),
            _buildProductTitle(),
            SizedBox(height: 20),
            _buildProductImage(screenWidth),
            SizedBox(height: 20),
            _buildProductDescription(),
            SizedBox(height: 20),
            _buildForm(),
            SizedBox(height: 20),
            _buildCheckoutButton()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
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
          widget.userId > 0
              ? Image.asset('assets/images/panda.png', height: 34)
              : Icon(Icons.account_circle_outlined,
                  color: Color(0xFF7A5C61), size: 34),
        ],
      ),
    );
  }

  Widget _buildProductTitle() {
    return Text(
      widget.product.title,
      style: AppWidget.SubHeadBoldTextFieldStyle(),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProductImage(double screenWidth) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(28),
        width: screenWidth * 0.6,
        height: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Image.network(widget.product.imagePath, height: 150),
            SizedBox(height: 10),
            Text(
              "${widget.product.price} baht",
              style: AppWidget.SubTitleNormalTextFieldStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDescription() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.all(20),
      child: Text(
        widget.product.description ?? "No description",
        style: AppWidget.SubTitleNormalTextFieldStyle(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<Sweetness>(
            value: _sweetness,
            decoration: const InputDecoration(label: Text("Sweetness")),
            items: Sweetness.values.map((key) {
              return DropdownMenuItem<Sweetness>(
                value: key,
                child: Text(key.title),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _sweetness = value!;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: _amount > 1 ? decreaseAmount : null,
                style: FilledButton.styleFrom(
                    backgroundColor:
                        _amount > 1 ? Color(0xFF7A5C61) : Color(0xFFF2EFEF),
                    foregroundColor: Colors.white,
                    fixedSize: Size(1, 1),
                    textStyle: TextStyle(fontSize: 24)),
                child: const Text("-"),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '$_amount',
                  style: AppWidget.SubTitleNormalTextFieldStyle(),
                ),
              ),
              FilledButton(
                onPressed: incrementAmount,
                style: FilledButton.styleFrom(
                    backgroundColor: Color(0xFF7A5C61),
                    foregroundColor: Colors.white,
                    fixedSize: Size(1, 1),
                    textStyle: TextStyle(fontSize: 24)),
                child: const Text("+"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Color(0xFF7A5C61),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: createCart,
          child: Text(
            "Add ( $totalPrice baht )",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
