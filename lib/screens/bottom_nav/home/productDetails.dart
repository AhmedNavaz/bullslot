import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../models/product.dart';
import '../../../services/utils.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({super.key, this.product});

  Product? product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int carouselIndex = 0;

  Utils utils = Utils();

  late String clock;
  late Timer clockSec;

  @override
  void initState() {
    super.initState();
    print(widget.product.runtimeType);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Details',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.3,
                  viewportFraction: 0.9,
                  enableInfiniteScroll: false,
                  autoPlay: true,
                  onPageChanged: (index, _) {
                    setState(() {
                      carouselIndex = index;
                    });
                  }),
              items: widget.product!.images!.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          i,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                'Time Remaining: ${utils.getRemainingTime(widget.product!.date!)}',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: 5),
            Text('Location: ${widget.product!.location!}',
                style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xffEAE9EE),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Colors.black, fontSize: 22),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.product!.description!,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.grey),
                            ),
                            Text(
                              '${widget.product!.title}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            widget.product!.totalSlots != null
                                ? Text(
                                    'Total Slots',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: Colors.grey),
                                  )
                                : Container(),
                            widget.product!.totalSlots != null
                                ? Text(
                                    '${widget.product!.totalSlots}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  )
                                : Container(),
                            const SizedBox(height: 15),
                            Text(
                              'Original Price',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.grey),
                            ),
                            Text(
                              '#${widget.product!.totalPrice!}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Charges',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.grey),
                            ),
                            Text(
                              widget.product!.freeDelivery!
                                  ? 'Free'
                                  : 'Applicable',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 15),
                            widget.product!.totalSlots != null
                                ? Text(
                                    'Remaining Slots',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: Colors.grey),
                                  )
                                : Container(height: 20),
                            widget.product!.totalSlots != null
                                ? Text(
                                    '${widget.product!.availableSlots}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  )
                                : Container(),
                            const SizedBox(height: 15),
                            widget.product!.totalSlots != null
                                ? Text(
                                    'Slot Price',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: Colors.grey),
                                  )
                                : Container(),
                            widget.product!.totalSlots != null
                                ? Text(
                                    '#${(double.parse(widget.product!.totalPrice!) / widget.product!.totalSlots!).toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  )
                                : Container()
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
