import 'dart:async';

import 'package:bullslot/models/productStatus.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../services/utils.dart';

class ProductStatusWidget extends StatefulWidget {
  ProductStatusWidget({super.key, this.productStatus});

  ProductStatus? productStatus;

  @override
  State<ProductStatusWidget> createState() => _ProductStatusWidgetState();
}

class _ProductStatusWidgetState extends State<ProductStatusWidget> {
  Utils utils = Utils();
  late String clock;
  late Timer clockSec;

  @override
  void initState() {
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
                child: Image.network(widget.productStatus!.product!.image!),
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
                  'Time: ${utils.getRemainingTime(widget.productStatus!.product!.date!)}',
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
                  child: Text(
                    '${widget.productStatus!.product!.title}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Slots:   ${widget.productStatus!.product!.totalSlots}'
                      .split('.')[0],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  'Remaining Slots:   ${widget.productStatus!.product!.totalSlots! - widget.productStatus!.product!.bookedSlots!}'
                      .split('.')[0],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                )
              ],
            ),
          ),
          Container(
            color: secondaryColor,
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Original Price: #${widget.productStatus!.product!.totalPrice}'
                      .split('.')[0],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  'Slot Price: #${widget.productStatus!.product!.totalPrice! / widget.productStatus!.product!.totalSlots!.toDouble()}'
                      .split('.')[0],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                )
              ],
            ),
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: '${widget.productStatus!.status}'.split('.')[1] ==
                          'DELIVERED'
                      ? Colors.black
                      : '${widget.productStatus!.status}'.split('.')[1] ==
                              'PAID'
                          ? accentColor
                          : '${widget.productStatus!.status}'.split('.')[1] ==
                                  'REJECTED'
                              ? Colors.red
                              : '${widget.productStatus!.status}'
                                          .split('.')[1] ==
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
                  '${widget.productStatus!.status}'.split('.')[1],
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
