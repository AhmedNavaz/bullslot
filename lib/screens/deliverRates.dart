import 'package:bullslot/models/city.dart';
import 'package:flutter/material.dart';

import '../models/deliveryRate.dart';

class DeliverRates extends StatelessWidget {
  DeliverRates({super.key});

  final List<DeliveryRate> _deliveryRates = [
    DeliveryRate(
        id: '1',
        city: City(id: '1', name: 'New York'),
        type: DeliveryType.CAR,
        rate: 20),
    DeliveryRate(
        id: '2',
        city: City(id: '2', name: 'LA'),
        type: DeliveryType.CAR,
        rate: 12),
    DeliveryRate(
        id: '3',
        city: City(id: '3', name: 'Washington'),
        type: DeliveryType.CAR,
        rate: 10)
  ];

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Text('Rates by City', style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 15),
            Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 2),
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
                for (int i = 0; i < _deliveryRates.length; i++)
                  TableRow(children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _deliveryRates[i].city!.name!,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '${_deliveryRates[i].type}'.split('.')[1],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        '${_deliveryRates[i].rate}',
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
