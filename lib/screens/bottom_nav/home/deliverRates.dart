import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/controllers/deliveryRatesController.dart';
import 'package:bullslot/models/city.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/deliveryRate.dart';

class DeliverRates extends StatefulWidget {
  DeliverRates({super.key});

  @override
  State<DeliverRates> createState() => _DeliverRatesState();
}

class _DeliverRatesState extends State<DeliverRates> {
  DeliveryRatesController deliveryRatesController =
      Get.put(DeliveryRatesController());
  bool isLoading = true;

  @override
  void initState() {
    deliveryRatesController.getDeliveryRates().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Delivery Rates',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Text('Rates by City',
                      style: Theme.of(context).textTheme.bodyText1),
                  const SizedBox(height: 15),
                  Table(
                    border: TableBorder.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2),
                    children: [
                      TableRow(children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: const Text(
                            'City',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: const Text(
                            'Delivery Type',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: const Text(
                            'Rate',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ]),
                      for (int i = 0;
                          i < deliveryRatesController.deliveryRatesList.length;
                          i++)
                        TableRow(children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              deliveryRatesController
                                  .deliveryRatesList[i].location!,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              '${deliveryRatesController.deliveryRatesList[i].type}'
                                  .split('.')[1],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              '${deliveryRatesController.deliveryRatesList[i].rate}',
                            ),
                          )
                        ]),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
