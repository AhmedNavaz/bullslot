import 'dart:async';

import 'package:bullslot/controllers/productController.dart';
import 'package:bullslot/models/orderStatus.dart';
import 'package:bullslot/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../services/utils.dart';

class OrderStatusWidget extends StatefulWidget {
  OrderStatusWidget({super.key, this.orderStatus});

  OrderStatus? orderStatus;

  @override
  State<OrderStatusWidget> createState() => _OrderStatusWidgetState();
}

class _OrderStatusWidgetState extends State<OrderStatusWidget> {
  Utils utils = Utils();
  late String clock;
  late Timer clockSec;

  ProductController productController = Get.find<ProductController>();

  Product? product;

  @override
  void initState() {
    for (var element in productController.products) {
      if (element.id == widget.orderStatus!.productId) {
        product = element;
      }
    }
    super.initState();

    clock = DateTime.now().second.toString();
    // defines a timer
    clockSec = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        clock = DateTime.now().second.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                child: Image.network(product!.images![0]),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  'Time: ${utils.getRemainingTime(product!.date!)}',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 18),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        '${product!.title}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.pin_drop_outlined,
                            color: Colors.white70,
                            size: 20,
                          ),
                          Text(
                            product!.location!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.white70),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
            width: double.infinity,
            child: product!.totalSlots != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Slots:   ${product!.totalSlots}'.split('.')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        'Remaining Slots:   ${product!.totalSlots! - product!.availableSlots!}'
                            .split('.')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        '\$${product!.totalPrice}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
          ),
          product!.totalSlots != null
              ? Container(
                  color: secondaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Original Price: \$${product!.totalPrice}'
                            .split('.')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        'Slot Price: \$${double.parse(product!.totalPrice!) / product!.totalSlots!.toDouble()}'
                            .split('.')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                )
              : Container(),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: '${widget.orderStatus!.status}'.split('.')[1] ==
                          'DELIVERED'
                      ? Colors.black
                      : '${widget.orderStatus!.status}'.split('.')[1] == 'PAID'
                          ? accentColor
                          : '${widget.orderStatus!.status}'.split('.')[1] ==
                                  'REJECTED'
                              ? Colors.red
                              : '${widget.orderStatus!.status}'.split('.')[1] ==
                                      'REFUNDED'
                                  ? Colors.blueAccent
                                  : Colors.grey,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              padding:
                  const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
              child: Center(
                child: Text(
                  '${widget.orderStatus!.status}'.split('.')[1],
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 20),
                ),
              )),
        ],
      ),
    );
  }
}
