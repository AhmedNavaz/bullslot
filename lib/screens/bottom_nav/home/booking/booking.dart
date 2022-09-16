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

  TextEditingController phoneController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  List<bool> bookedByYou = [];
  int bookedCount = 0;

  @override
  void initState() {
    for (int i = 0; i < widget.product!.totalSlots!; i++) {
      if (i < widget.product!.bookedSlots!.toInt()) {
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
          child: Expanded(
            child: Column(
              children: [
                Text(
                  'Book your slots now!',
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Colors.black, fontSize: 22),
                ),
                const SizedBox(height: 20),
                Wrap(
                  children: [
                    for (int i = 0;
                        i < widget.product!.totalSlots!.toInt();
                        i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (i >= widget.product!.bookedSlots!.toInt()) {
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
                                ? i < widget.product!.bookedSlots!.toInt()
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
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(children: [
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
                      title: 'Address',
                      controller: addressController,
                      hintText: 'Enter your address',
                    ),
                  ]),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 6),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      navigationController.navigateWithArg(checkout, {
                        'product': widget.product,
                        'bookedCount': bookedCount,
                        'deliveryCharges': 50,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
