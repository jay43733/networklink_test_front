import 'package:flutter/material.dart';
import 'package:networklist_test/models/carts.dart';
import 'package:networklist_test/pages/cartSummary.dart';
import 'package:networklist_test/pages/login.dart';
import 'package:networklist_test/pages/productDetail.dart';
import 'package:networklist_test/widget/widget_support.dart';
import 'package:networklist_test/models/product.dart';

class Home extends StatefulWidget {
  final List<Carts> cartItems;

  const Home({super.key, required this.cartItems});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool IsOrderedProduct(int productId) {
    return cartItems.any((item) => item.productId == productId);
  }

  void hdlCheckOut() async {
    // Navigate to CartSummary and wait for the result
    final updatedCartItems = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => CartSummary(carts: cartItems),
      ),
    );

    // If updatedCartItems is not null, update the local cartItems and rebuild the UI
    if (updatedCartItems != null) {
      setState(() {
        cartItems = updatedCartItems;
      });
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
              backgroundColor: widget.cartItems.isEmpty
                  ? Color(0xFFC2B4B6)
                  : Color(0xFF18B473),
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: widget.cartItems.isEmpty ? null : hdlCheckOut,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 24,
                  ),
                  Text("Check out (${widget.cartItems.length})"),
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
        Icon(Icons.account_circle_outlined, color: Color(0xFF7A5C61), size: 34),
      ],
    );
  }

  Widget _buildRecommendedSection(double screenWidth) {
    final recommendedProducts =
        data.where((item) => item.isRecommended).toList();

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
        data.where((item) => item.category == Category.coffee).toList();

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
        data.where((item) => item.category == Category.nonCoffee).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Non-Coffee", style: AppWidget.HeadLine2BoldTextFieldStyle()),
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
          Image.asset(product.imagePath, height: 80),
          SizedBox(height: 14),
          Text(product.title, style: AppWidget.HeadLine4BoldTextFieldStyle()),
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
                        builder: (ctx) => ProductDetail(product: product),
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

  Widget _buildLoginButton() {
    return Center(
      child: FilledButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => const LoginPage()));
        },
        child: Text("Go to Login"),
      ),
    );
  }
}
