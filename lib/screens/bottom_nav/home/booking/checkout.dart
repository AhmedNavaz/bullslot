import 'dart:io';
import 'dart:async';

import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/controllers/authController.dart';
import 'package:bullslot/controllers/orderController.dart';
import 'package:bullslot/models/bankAccount.dart';
import 'package:bullslot/models/orderStatus.dart';
import 'package:bullslot/router/routerGenerator.dart';
import 'package:bullslot/services/storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/product.dart';
import '../../../../services/utils.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({
    super.key,
    this.product,
    this.bookedCount,
    this.deliveryCharges,
    this.deliveryType,
    this.name,
    this.phone,
    this.address,
  });

  Product? product;
  int? bookedCount;
  double? deliveryCharges;
  String? deliveryType;
  String? name;
  String? phone;
  String? address;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  OrderController orderController = Get.find<OrderController>();
  AuthController authController = Get.find<AuthController>();

  bool isLoading = true;
  bool isUploading = false;

  ImageHandler imageHandler = ImageHandler();
  StorageMethods storageMethods = StorageMethods();

  File? proofImage;

  // 30 minutes from now
  DateTime bookingTime = DateTime.now().add(const Duration(minutes: 30));

  Utils utils = Utils();
  late String clock;
  late Timer clockSec;

  @override
  void initState() {
    orderController.getBankAccounts().then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
    clock = DateTime.now().second.toString();
    // defines a timer
    clockSec = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        clock = DateTime.now().second.toString();
      });
    });
  }

  Future<String> uploadFile(String id) async {
    if (proofImage == null) return '';
    UploadTask? task =
        storageMethods.uploadImage('paymentProofs/$id', proofImage!);
    if (task == null) return '';
    final snapshot = await task.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Checkout',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : Obx(
              () => SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Booking will expire after: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.grey)),
                          const Spacer(),
                          Text(utils.getRemainingTime(bookingTime),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: primaryColor)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Account Details',
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black, fontSize: 26),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orderController.bankAccounts.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.grey.shade200,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Account # ${index + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text('Account Name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    const Spacer(),
                                    Text(
                                        orderController
                                            .bankAccounts[index].accountName!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Bank Name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    const Spacer(),
                                    Text(
                                        orderController
                                            .bankAccounts[index].bankName!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Bank Address',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    const Spacer(),
                                    Text(
                                        orderController
                                            .bankAccounts[index].bankAddress!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Account Number',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    const Spacer(),
                                    Text(
                                        orderController
                                            .bankAccounts[index].accountNumber!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Currency',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    const Spacer(),
                                    Text(
                                        orderController
                                            .bankAccounts[index].currency!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        leading: Text('Delivery Charges',
                            style: Theme.of(context).textTheme.bodyText1),
                        title: Text('(${widget.deliveryType})',
                            style: Theme.of(context).textTheme.bodyText2),
                        trailing: Text(
                          '\$${widget.deliveryCharges?.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        title: Text(
                            widget.product!.totalSlots == null
                                ? 'Subtotal'
                                : 'Subtotal (${widget.bookedCount.toString()}x slots)',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 18)),
                        trailing: Text(
                          widget.product!.totalSlots == null
                              ? '\$${(double.parse(widget.product!.totalPrice!)).toStringAsFixed(2)}'
                              : '\$${(double.parse(widget.product!.totalPrice!) / widget.product!.totalSlots! * widget.bookedCount!).toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        height: 0,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.grey.shade400,
                      ),
                      ListTile(
                        title: Text('Total',
                            style: Theme.of(context).textTheme.bodyText1),
                        trailing: Text(
                          widget.product!.totalSlots == null
                              ? '\$${(double.parse(widget.product!.totalPrice!) + widget.deliveryCharges!).toStringAsFixed(2)}'
                              : '\$${(double.parse(widget.product!.totalPrice!) / widget.product!.totalSlots! * widget.bookedCount! + widget.deliveryCharges!).toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Payment Proof',
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black, fontSize: 20),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            ImageHandler.uploadPicture()!.then((value) {
                              value.path == ''
                                  ? null
                                  : setState(() {
                                      proofImage = value;
                                    });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                          child: Text(
                            'Upload',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        alignment: Alignment.center,
                        child: proofImage == null
                            ? Text(
                                'No Image Added Yet',
                                style: Theme.of(context).textTheme.bodyText2,
                              )
                            : Image.file(
                                proofImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Pay the above amount in one of our bank accounts and upload the payment proof, then tap the below button.',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (bookingTime.isBefore(DateTime.now())) {
                              Get.snackbar(
                                'Booking Time Expired',
                                'Kindly book the product again.',
                              );
                              return;
                            }
                            if (proofImage != null) {
                              setState(() {
                                isUploading = true;
                              });
                              String id = const Uuid().v1();
                              uploadFile(id).then((value) {
                                orderController
                                    .sendOrder(
                                        authController.localUser.value.id!,
                                        OrderStatus(
                                          id: id,
                                          productId: widget.product!.id!,
                                          status: Status.PENDING,
                                          date: DateTime.now(),
                                          slots: widget.bookedCount,
                                          deliveryCharges: widget
                                              .deliveryCharges!
                                              .toStringAsFixed(2),
                                          imageProof: value,
                                          bill: widget.product!.totalSlots ==
                                                  null
                                              ? (double.parse(
                                                          widget.product!
                                                              .totalPrice!) +
                                                      widget.deliveryCharges!)
                                                  .toStringAsFixed(2)
                                              : (double.parse(
                                                              widget.product!
                                                                  .totalPrice!) /
                                                          widget.product!
                                                              .totalSlots! *
                                                          widget.bookedCount! +
                                                      widget.deliveryCharges!)
                                                  .toStringAsFixed(2),
                                          userId: authController
                                              .localUser.value.id!,
                                          name: widget.name,
                                          email: authController
                                              .localUser.value.email!,
                                          phone: widget.phone,
                                          address: widget.address,
                                          deliveryType: widget.deliveryType,
                                        ))
                                    .then((value) {
                                  if (widget.product!.totalSlots != null) {
                                    orderController.updateAvailableSlots(
                                        widget.product!.id!,
                                        widget.product!.availableSlots! -
                                            widget.bookedCount!);
                                  } else {
                                    orderController
                                        .markAsSold(widget.product!.id!);
                                  }

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      content: Text(
                                        'Your payment is pending awaiting verification.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            navigationController
                                                .getOffAll(home);
                                          },
                                          child: Text('Ok',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      color: primaryColor)),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please upload payment proof'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isUploading ? Colors.grey : accentColor,
                          ),
                          child: Text(
                            'I\'ve Paid',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
