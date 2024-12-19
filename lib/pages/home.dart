import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:networklist_test/models/carts.dart';
import 'package:networklist_test/pages/cartSummary.dart';
import 'package:networklist_test/pages/login.dart';
import 'package:networklist_test/pages/productDetail.dart';
import 'package:networklist_test/pages/profile.dart';
import 'package:networklist_test/widget/widget_support.dart';
import 'package:networklist_test/models/product.dart';

class Home extends StatefulWidget {
  // final List<Carts> cartItems;

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = FlutterSecureStorage();
  int userId = 0;
  String userEmail = "";
  List<Product> products = [];
  List<Carts> carts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchProducts();
    fetchCarts();
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
            userId = userData['id'];
          });
          print("User Email: $userEmail, User ID: $userId");
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

  Future<void> fetchProducts() async {
    try {
      String? token = await storage.read(key: 'accessToken');
      if (token != null) {
        final productResp = await http.get(
          Uri.parse('http://10.0.2.2:8008/products'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (productResp.statusCode == 200) {
          final productData = jsonDecode(productResp.body) as List;
          setState(() {
            products =
                productData.map((json) => Product.fromJson(json)).toList();
          });
          print("Products fetched: ${products.length}");
        } else {
          print('Failed to load products: ${productResp.statusCode}');
        }
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  Future<void> fetchCarts() async {
    String? token = await storage.read(key: 'accessToken');
    setState(() {
      isLoading = true; // Start loading
    });

    final cartResp = await http.get(
      Uri.parse('http://10.0.2.2:8008/carts'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (cartResp.statusCode == 200) {
      final cartData = jsonDecode(cartResp.body) as List;
      setState(() {
        carts = cartData.map((json) => Carts.fromJson(json)).toList();
        isLoading = false; // Stop loading
      });
    } else {
      print('Failed to load carts: ${cartResp.statusCode}');
      setState(() {
        isLoading = false; // Stop loading even on failure
      });
    }
  }

  bool IsOrderedProduct(int productId) {
    return carts.any((item) => item.productId == productId);
  }

  void hdlCheckOut() async {
    // Navigate to CartSummary and wait for the result
    final updatedCartItems = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CartSummary(carts: carts, userId: userId),
      ),
    );

    // If updatedCartItems is not null, update the local cartItems and rebuild the UI
    if (updatedCartItems != null) {
      setState(() {
        carts = updatedCartItems;
      });
    }
  }

  String getTruncatedTitle(String title) {
    if (title.length > 10) {
      return '${title.substring(0, 10)}...';
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    print("CCCCCCCCCC: $carts");
    print("PPPPPPPPPP: $products");
    print("uuuuuuuuuu: $userId");
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFECF1F6),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 40),
              _buildRecommendedSection(screenWidth),
              SizedBox(height: 20),
              _buildCoffeeSection(screenWidth),
              SizedBox(height: 20),
              _buildNonCoffeeSection(screenWidth),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor // Empty cart
                  : isLoading // Handle loading state
                      ? Colors.grey // Show grey while loading
                      : (carts.isEmpty
                          ? Color(0xFFC2B4B6) // If carts is empty
                          : Color(
                              0xFF18B473)), // If carts has items // Non-empty cart
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: hdlCheckOut,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 24,
                  ),
                  Text("Check out (${carts.length})"),
                ])),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.menu_rounded, color: Color(0xFF7A5C61), size: 34),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Coffee Cafe", style: AppWidget.normalTextFieldStyle()),
            SizedBox(width: 10),
            Image.asset('assets/images/logo.png', height: 30),
          ],
        ),
        userId > 0
            ? GestureDetector(
                child: Image.asset('assets/images/panda.png', height: 34),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                })
            : Icon(Icons.account_circle_outlined,
                color: Color(0xFF7A5C61), size: 34),
      ],
    );
  }

  Widget _buildRecommendedSection(double screenWidth) {
    final recommendedProducts =
        products.where((item) => item.isRecommended).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Recommended",
              style: AppWidget.HeadLine2BoldTextFieldStyle()),
        ),
        SizedBox(height: 10),
        Center(
          child: Container(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendedProducts.length,
              itemBuilder: (context, index) {
                final product = recommendedProducts[index];

                // final amount = orderNumber(product.id);
                return _buildProductCard(product, screenWidth);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoffeeSection(double screenWidth) {
    final coffeeProducts =
        products.where((item) => item.category == Category.coffee).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Coffee", style: AppWidget.HeadLine2BoldTextFieldStyle()),
        ),
        SizedBox(height: 10),
        Center(
          child: Container(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: coffeeProducts.length,
              itemBuilder: (context, index) {
                final product = coffeeProducts[index];

                // final amount = orderNumber(product.id);
                return _buildProductCard(product, screenWidth);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNonCoffeeSection(double screenWidth) {
    final nonCoffeeProducts =
        products.where((item) => item.category == Category.nonCoffee).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Non-Coffee",
              style: AppWidget.HeadLine2BoldTextFieldStyle()),
        ),
        SizedBox(height: 10),
        Center(
          child: Container(
            height: 260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: nonCoffeeProducts.length,
              itemBuilder: (context, index) {
                final product = nonCoffeeProducts[index];

                // final amount = orderNumber(product.id);
                return _buildProductCard(product, screenWidth);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product, double screenWidth) {
    return Container(
      width: screenWidth * 0.4,
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(product.imagePath, height: 80),
          SizedBox(height: 14),
          Text(getTruncatedTitle(product.title),
              style: AppWidget.HeadLine4BoldTextFieldStyle()),
          SizedBox(height: 6),
          Text("${product.price} baht",
              style: AppWidget.SubHead2NormalTextFieldStyle()),
          SizedBox(height: 12),
          Container(
            width: 100,
            child: FilledButton(
                style:
                    FilledButton.styleFrom(backgroundColor: Color(0xFF7A5C61)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => ProductDetail(
                          product: product,
                          userId: userId,
                        ),
                      ));
                },
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    Text("Add"),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
