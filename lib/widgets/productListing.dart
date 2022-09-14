import 'dart:async';

import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/models/product.dart';
import 'package:bullslot/router/routerGenerator.dart';
import 'package:bullslot/services/utils.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ProductListingWidget extends StatefulWidget {
  ProductListingWidget({
    Key? key,
    this.product,
  }) : super(key: key);

  Product? product;

  @override
  State<ProductListingWidget> createState() => _ProductListingWidgetState();
}

class _ProductListingWidgetState extends State<ProductListingWidget> {
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
                child: Image.network(widget.product!.image!),
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
                  'Time: ${utils.getRemainingTime(widget.product!.date!)}',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 18),
                ),
              ),
              // Positioned(
              //   right: 0,
              //   top: 0,
              //   child: Container(
              //     decoration: const BoxDecoration(
              //       color: primaryColor,
              //       borderRadius: BorderRadius.only(
              //           bottomLeft: Radius.circular(20),
              //           topRight: Radius.circular(20)),
              //     ),
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //     child: Text(
              //       'Slot ${widget.product!.totalSlots! - widget.product!.bookedSlots!}',
              //       style: Theme.of(context)
              //           .textTheme
              //           .headline2!
              //           .copyWith(fontSize: 18),
              //     ),
              //   ),
              // ),
            ],
          ),
          Container(
            color: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Slots:   ${widget.product!.totalSlots}'.split('.')[0],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  'Remaining Slots:   ${widget.product!.totalSlots! - widget.product!.bookedSlots!}'
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
                  'Original Price: #${widget.product!.totalPrice}'
                      .split('.')[0],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  'Slot Price: #${widget.product!.totalPrice! / widget.product!.totalSlots!.toDouble()}'
                      .split('.')[0],
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 30),
                    backgroundColor: accentColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20)))),
                child: Text(
                  'Book Now',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  navigationController.navigateTo(productDetails);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: const Size(150, 30),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20)))),
                child: Text(
                  'View Details',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 20),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}