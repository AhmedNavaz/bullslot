import 'dart:io';

import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/router/routerGenerator.dart';
import 'package:flutter/material.dart';

import '../../../../models/product.dart';
import '../../../../widgets/formField.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({super.key, this.product});

  Product? product;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  bool? officePickup;

  var value;

  TextEditingController phoneController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  List<bool> bookedByYou = [];
  int bookedCount = 0;

  @override
  void initState() {
    for (int i = 0; i < widget.product!.totalSlots!; i++) {
      if (i < widget.product!.availableSlots!.toInt()) {
        bookedByYou.add(true);
      } else {
        bookedByYou.add(false);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Booking',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Book Slots',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Colors.black, fontSize: 22),
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                children: [
                  for (int i = 0; i < widget.product!.totalSlots!.toInt(); i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (i >= widget.product!.availableSlots!.toInt()) {
                            bookedByYou[i] = !bookedByYou[i];
                            if (bookedByYou[i]) {
                              bookedCount++;
                            } else {
                              bookedCount--;
                            }
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 2.5),
                        height: 50,
                        width: 100,
                        child: Card(
                          elevation: 5,
                          color: bookedByYou[i]
                              ? i < widget.product!.availableSlots!.toInt()
                                  ? Colors.red.shade600
                                  : Colors.blueAccent
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Slot ${i + 1}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: bookedByYou[i]
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Card(color: Colors.red.shade800),
                    ),
                    const Text('Booked Slots'),
                    const Spacer(),
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: Card(color: Colors.white),
                    ),
                    const Text('Available Slots'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Delivery',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Colors.black, fontSize: 22),
                ),
              ),
              const SizedBox(height: 10),
              widget.product!.freeDelivery!
                  ? Text(
                      'Free Deivery',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: accentColor, fontWeight: FontWeight.bold),
                    )
                  : Container(),
              widget.product!.officePickupRate != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Office Pickup',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        ListTile(
                          title: Text(
                            '\$${widget.product!.officePickupRate}',
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(color: Colors.black, fontSize: 20),
                          ),
                          trailing: IconButton(
                              icon: value == 0
                                  ? const Icon(
                                      Icons.radio_button_on_outlined,
                                      color: primaryColor,
                                    )
                                  : const Icon(Icons.radio_button_off_outlined),
                              onPressed: () {
                                setState(() {
                                  value = 0;
                                  officePickup = true;
                                });
                              }),
                        )
                      ],
                    )
                  : Container(),
              widget.product!.deliveryRates != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Area Delivery',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        for (int i = 0;
                            i < widget.product!.deliveryRates!.length;
                            i++)
                          ListTile(
                            leading: Text(
                              '\$${widget.product!.deliveryRates![i].rate}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: Colors.black, fontSize: 20),
                            ),
                            title: Text(
                              '(${widget.product!.deliveryRates![i].city!.name})',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: IconButton(
                                icon: value == i + 1
                                    ? const Icon(
                                        Icons.radio_button_on_outlined,
                                        color: primaryColor,
                                      )
                                    : const Icon(
                                        Icons.radio_button_off_outlined),
                                onPressed: () {
                                  setState(() {
                                    value = i + 1;
                                    officePickup = false;
                                  });
                                }),
                          )
                      ],
                    )
                  : Container(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text('Kindly fill the below details',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    formField(
                      title: 'Phone Number',
                      controller: phoneController,
                      hintText: 'Enter you phone/whatsapp number',
                      inputType: TextInputType.phone,
                    ),
                    formField(
                      title: 'Shipping Address',
                      controller: addressController,
                      hintText: 'Enter your shipping address',
                    ),
                  ],
                ),
              ),
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
                        'Terms & Conditions',
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: Colors.black, fontSize: 22),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'asldkfjasd sld;fkjs odflksdjf sad;fkljsadio fjsd;lfjksd;iofjasd;lfj as;ldfjasdofjasd;lkfjaweoifjsdlfjasdklfjas df;sdklfjsd;iofjoas;djfklasdjf;oisdjf;lsajga;lgjasiofj  sdf;iasdojfosjf a;l',
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.justify,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    navigationController.navigateWithArg(checkout, {
                      'product': widget.product,
                      'bookedCount': bookedCount,
                      'deliveryCharges': widget.product!.freeDelivery!
                          ? 0.0
                          : officePickup!
                              ? widget.product!.officePickupRate
                              : widget.product!.deliveryRates![value - 1].rate,
                      'deliveryType': widget.product!.freeDelivery!
                          ? 'Free Delivery'
                          : officePickup!
                              ? 'Office Pickup'
                              : '${widget.product!.deliveryRates![value - 1].city!.name}',
                    });
                  },
                  child: Text(
                    'Go to Checkout',
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
    );
  }
}
