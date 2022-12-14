// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/controllers/authController.dart';
import 'package:bullslot/controllers/orderController.dart';
import 'package:bullslot/router/routerGenerator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
  var officePickupSelected = false;
  bool showDetails = false;
  var value;

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  List<bool> bookedByYou = [];
  int bookedCount = 0;

  OrderController orderController = Get.put(OrderController());
  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    nameController.text = authController.localUser.value.name!;
    phoneController.text = authController.localUser.value.phone!;
    addressController.text = authController.localUser.value.address!;
    if (widget.product!.totalSlots != null) {
      for (int i = 0; i < widget.product!.totalSlots!; i++) {
        if (i <
            widget.product!.totalSlots! -
                widget.product!.availableSlots!.toInt()) {
          bookedByYou.add(true);
        } else {
          bookedByYou.add(false);
        }
      }
    }
    if (widget.product!.officePickup!) {
      orderController.getOfficeAddress();
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
              widget.product!.totalSlots != null
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Book Slots',
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: Colors.black, fontSize: 22),
                      ),
                    )
                  : Container(),
              SizedBox(height: widget.product!.totalSlots != null ? 15 : 0),
              widget.product!.totalSlots != null
                  ? Wrap(
                      children: [
                        for (int i = 0;
                            i < widget.product!.totalSlots!.toInt();
                            i++)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (i >=
                                    widget.product!.totalSlots! -
                                        widget.product!.availableSlots!
                                            .toInt()) {
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
                                    ? i <
                                            widget.product!.totalSlots! -
                                                widget.product!.availableSlots!
                                                    .toInt()
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
                    )
                  : Container(),
              SizedBox(height: widget.product!.totalSlots != null ? 10 : 0),
              widget.product!.totalSlots != null
                  ? Padding(
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
                    )
                  : Container(),
              SizedBox(height: widget.product!.totalSlots != null ? 15 : 0),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Delivery',
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Colors.black, fontSize: 22),
                    ),
                    Text(
                      ' (Must select any 1 delivery type)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.grey),
                    ),
                  ],
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
              widget.product!.officePickup!
                  ? ListTile(
                      title: Text(
                        'Office Pickup',
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
                              officePickupSelected = true;
                              showDetails = false;
                            });
                          }),
                    )
                  : Container(),
              officePickupSelected
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Office Address',
                              style: Theme.of(context).textTheme.bodyText2),
                          Text(orderController.officeAddress.value,
                              style: Theme.of(context).textTheme.bodyText1),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                  : Container(),
              widget.product!.deliveryRates != null &&
                      widget.product!.deliveryRates!.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Area Delivery',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        for (int i = 0;
                            i < widget.product!.deliveryRates!.length;
                            i++)
                          ListTile(
                            leading: Text(
                              '#${widget.product!.deliveryRates![i].rate}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: Colors.black, fontSize: 20),
                            ),
                            title: Text(
                              '(${widget.product!.deliveryRates![i].location})',
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
                                    officePickupSelected = false;
                                    showDetails = true;
                                  });
                                }),
                          )
                      ],
                    )
                  : Container(),
              showDetails
                  ? Form(
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
                            title: 'Name',
                            controller: nameController,
                            hintText: 'Enter your name',
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
                          Text(
                              'To save/edit your details permanently, go to "Edit Profile".',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    )
                  : Container(),
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
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    'You understand that by using Services, you are agreeing to be bound by these Terms, including any and all of your warranties and representations contained herein. If you do not accept these Terms in their entirety, you may not access or use the Services. If you agree to these Terms on behalf of an entity, you represent and warrant that you have the authority to bind that entity to these Terms. In that event, "you" and "your" will refer and apply to that entity. ',
                                style: Theme.of(context).textTheme.bodyText2),
                            TextSpan(
                              text: 'Learn More',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: Colors.blue,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(Uri.parse(
                                      "https://bullslot.ng/#/terms-and-conditions"));
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if ((widget.product!.totalSlots != null &&
                            bookedCount > 0) ||
                        widget.product!.totalSlots == null) {
                      navigationController.navigateWithArg(checkout, {
                        'product': widget.product,
                        'bookedCount': bookedCount,
                        'deliveryCharges': widget.product!.freeDelivery! ||
                                widget.product!.officePickup! &&
                                    officePickupSelected
                            ? 0.0
                            : double.parse(widget
                                .product!.deliveryRates![value - 1].rate!),
                        'deliveryType': widget.product!.freeDelivery!
                            ? 'Free Delivery'
                            : officePickupSelected
                                ? 'Office Pickup'
                                : '${widget.product!.deliveryRates![value - 1].location}',
                        'name': nameController.text,
                        'phone': phoneController.text,
                        'address': addressController.text,
                      });
                    } else {
                      // show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select slot'),
                        ),
                      );
                    }
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
