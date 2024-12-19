import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:networklist_test/config.dart';
import 'package:networklist_test/models/orderItems.dart';
import 'package:networklist_test/widget/widget_support.dart';
import 'package:http/http.dart' as http;

class historyDetail extends StatefulWidget {
  final int orderId;
  const historyDetail({super.key, required int this.orderId});

  @override
  State<historyDetail> createState() => _historyDetailState();
}

class _historyDetailState extends State<historyDetail> {
  final storage = FlutterSecureStorage();
  bool isLoading = false;
  List<OrderItems> orderItems = [];

  @override
  void initState() {
    super.initState();
    fetchOrder();
  }

  Future<void> fetchOrder() async {
    String? token = await storage.read(key: 'accessToken');
    setState(() {
      isLoading = true; // Start loading
    });
    try {
      final orderItemsResp = await http.get(
        Uri.parse('${Config.baseUrl}/orders/${widget.orderId}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (orderItemsResp.statusCode == 200) {
        final orderData = jsonDecode(orderItemsResp.body) as List;
        setState(() {
          orderItems =
              orderData.map((json) => OrderItems.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        print("Failed to fetch ${orderItemsResp.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Network error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECF1F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                SizedBox(height: 20),
                _buildOrderItem(),
                _buildSummaryPrice(),
                _buildTotalPrice()
              ],
            ),
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

  Widget _buildOrderItem() {
    return ListView.builder(
      shrinkWrap:
          true, //ให้ ListView มีขนาดตามเนื้อหาที่แสดงผล ไม่ใช้พื้นที่แบบไม่จำกัด.
      physics:
          NeverScrollableScrollPhysics(), //ปิดการ scroll ของ ListView เอง เพราะเราจะ scroll ทั้งหน้าจอผ่าน SingleChildScrollView.
      itemCount: orderItems.length,
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
                    "${orderItems[index].amount}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Image.network(
                  orderItems[index].productData.productImage,
                  width: 60,
                  height: 60,
                ),
                SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orderItems[index].productData.productName,
                          style: AppWidget.HeadLine4BoldTextFieldStyle()),
                      SizedBox(height: 4),
                      Text(
                          "${orderItems[index].productData.price * orderItems[index].amount} baht",
                          style: AppWidget.SubHead2NormalTextFieldStyle()),
                      Text(_getSweetnessText(orderItems[index].sweetness),
                          style: AppWidget.SubHead2NormalTextFieldStyle()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryPrice() {
    final sortedOrderedItems = orderItems.sort((a, b) =>
        a.productData.productName.compareTo(b.productData.productName));

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Summary",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orderItems.length,
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
                            "${orderItems[index].productData.productName}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF333333)),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Amount : ${orderItems[index].amount}",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Sweetness : ${_getSweetnessText(orderItems[index].sweetness)}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        "${orderItems[index].productData.price * orderItems[index].amount} baht",
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
    final totalPrice = orderItems.fold(
        0, (prev, item) => prev + (item.amount * item.productData.price));
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
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
