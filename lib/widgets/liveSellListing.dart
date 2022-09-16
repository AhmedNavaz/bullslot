import 'dart:async';

import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/models/liveProduct.dart';
import 'package:bullslot/models/product.dart';
import 'package:bullslot/router/routerGenerator.dart';
import 'package:bullslot/services/utils.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class LiveSellListingWidget extends StatefulWidget {
  LiveSellListingWidget({
    Key? key,
    this.product,
  }) : super(key: key);

  LiveProduct? product;

  @override
  State<LiveSellListingWidget> createState() => _LiveSellListingWidgetState();
}

class _LiveSellListingWidgetState extends State<LiveSellListingWidget> {
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
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              child: Image.network(widget.product!.image!),
            ),
            Container(
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                'Time: ${utils.getRemainingTime(widget.product!.date!)}',
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
                  '${widget.product!.title}',
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
          child: Row(
            children: [
              Text(
                'Price: ',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white),
              ),
              const Spacer(),
              Text(
                '#${widget.product!.totalPrice}'.split('.')[0],
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.75),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  navigationController
                      .navigateWithArg(booking, {'product': widget.product});
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 30),
                    backgroundColor: accentColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20)))),
                child: Text(
                  'Buy Now',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  navigationController.navigateWithArg(
                      productDetails, {'product': widget.product});
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
          ),
        )
      ],
    );
  }
}
