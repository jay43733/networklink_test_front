import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:networklist_test/config.dart';
import 'package:networklist_test/models/orders.dart';
import 'package:networklist_test/pages/historyDetail.dart';
import 'package:networklist_test/widget/widget_support.dart';
import 'package:http/http.dart' as http;

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final storage = FlutterSecureStorage();
  bool isLoading = false;
  List<Orders> orders = [];

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
      final orderResp = await http.get(
        Uri.parse('${Config.baseUrl}/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (orderResp.statusCode == 200) {
        final orderData = jsonDecode(orderResp.body) as List;
        setState(() {
          orders = orderData.map((json) => Orders.fromJson(json)).toList();
          isLoading = false;
        });
        print("Orders fetch: ${orders.length}");
      } else {
        print("Failed to fetch ${orderResp.statusCode}");
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

  void hdlGetMoreDetail(int orderId) {
    print("Order: $orderId");
    Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => historyDetail(orderId: orderId)));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFECF1F6),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(
                height: 20,
              ),
              _buildListOrder()
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

  Widget _buildListOrder() {
    if (orders.isEmpty) {
      return Center(child: Text('No Order'));
    }

    return ListView.builder(
      shrinkWrap:
          true, //ให้ ListView มีขนาดตามเนื้อหาที่แสดงผล ไม่ใช้พื้นที่แบบไม่จำกัด.
      physics:
          NeverScrollableScrollPhysics(), //ปิดการ scroll ของ ListView เอง เพราะเราจะ scroll ทั้งหน้าจอผ่าน SingleChildScrollView.
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            hdlGetMoreDetail(orders[index].id);
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/images/chocolate-drink.png",
                          height: 50,
                        ),
                      ),
                      SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              Text("Order :",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold)),
                              Text(
                                orders[index].id.toString(),
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF9D9999)),
                              )
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            spacing: 6,
                            children: [
                              Text("Total Price:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.bold)),
                              Text(orders[index].totalPrice.toString(),
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF9D9999))),
                              Text("baht",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF9D9999))),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 24,
                      color: Color(0xFF7A5C61),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
