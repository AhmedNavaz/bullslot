import 'package:bullslot/controllers/authController.dart';
import 'package:bullslot/controllers/orderController.dart';
import 'package:bullslot/models/orderStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/orderStatus.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  AuthController authController = Get.find<AuthController>();

  OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    orderController.getOfficeAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(authController.localUser.value.id)
            .collection('ordersHistory')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return snapshot.data!.docs.isEmpty
              ? const Center(child: Text('No orders yet'))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return OrderStatusWidget(
                            orderStatus: OrderStatus.fromJson(
                                snapshot.data!.docs[index].data()));
                      }),
                );
        });
  }
}
