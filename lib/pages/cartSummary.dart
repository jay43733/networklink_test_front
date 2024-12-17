import 'package:flutter/material.dart';
import 'package:networklist_test/models/carts.dart';
import 'package:networklist_test/pages/successPayment.dart';
import 'package:networklist_test/widget/widget_support.dart';

class CartSummary extends StatefulWidget {
  final List<Carts> carts;
  const CartSummary({super.key, required this.carts});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  String _getSweetnessText(Sweetness sweetness) {
    switch (sweetness) {
      case Sweetness.hundredPercent:
        return "100 %";
      case Sweetness.fiftyPercent:
        return "50 %";
      case Sweetness.zeroPercent:
        return "0 %";
      default:
        return "";
    }
  }

  void removeCartItemById(int id) {
    setState(() {
      cartItems.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECF1F6),
      body: SafeArea(
        child: SingleChildScrollView(
          //รอบ Column หลัก เพื่อให้เนื้อหาที่เกินสามารถ scroll ได้.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildListView(), // Use Expanded to fill space
              SizedBox(height: 20),
              _buildSummaryPrice(),
              _buildTotalPrice() // Use Expanded to fill space
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Color(0xFF7A5C61)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          SuccessPayment(cartItems: widget.carts)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Icon(
                  Icons.payment_outlined,
                  size: 24,
                ),
                Text(
                  "Place Order",
                  style: TextStyle(fontSize: 20),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context, cartItems);
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
            Icon(Icons.account_circle_outlined,
                color: Color(0xFF7A5C61), size: 34),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    if (widget.carts.isEmpty) {
      return Center(child: Text('No items in cart'));
    }

    return ListView.builder(
      shrinkWrap:
          true, //ให้ ListView มีขนาดตามเนื้อหาที่แสดงผล ไม่ใช้พื้นที่แบบไม่จำกัด.
      physics:
          NeverScrollableScrollPhysics(), //ปิดการ scroll ของ ListView เอง เพราะเราจะ scroll ทั้งหน้าจอผ่าน SingleChildScrollView.
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: widget.carts.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF7A5C61)),
                  child: Text(
                    "${cartItems[index].amount}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Image.asset(
                  cartItems[index].productImage,
                  width: 60,
                  height: 60,
                ),
                SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cartItems[index].productName,
                          style: AppWidget.HeadLine4BoldTextFieldStyle()),
                      SizedBox(height: 4),
                      Text(
                          "${cartItems[index].price * cartItems[index].amount} baht",
                          style: AppWidget.SubHead2NormalTextFieldStyle()),
                      Text(_getSweetnessText(cartItems[index].sweetness),
                          style: AppWidget.SubHead2NormalTextFieldStyle()),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Color(0xFFEC0357)),
                  onPressed: () {
                    removeCartItemById(cartItems[index].id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryPrice() {
    final orderedCartItems =
        cartItems.sort((a, b) => a.productName.compareTo(b.productName));

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(right: 20, left: 0, top: 0, bottom: 20),
            child: Text(
              "Summary",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 14),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            "${cartItems[index].productName}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF333333)),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Amount : ${cartItems[index].amount}",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Sweetness : ${_getSweetnessText(cartItems[index].sweetness)}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        "${cartItems[index].price * cartItems[index].amount} baht",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF333333)),
                      )
                    ]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPrice() {
    final totalPrice =
        widget.carts.fold(0, (prev, item) => prev + (item.amount * item.price));
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Price",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333)),
          ),
          Text(
            "$totalPrice baht",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333)),
          )
        ],
      ),
    );
  }
}
