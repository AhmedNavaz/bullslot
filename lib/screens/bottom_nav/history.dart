import 'package:bullslot/models/product.dart';
import 'package:bullslot/models/productStatus.dart';
import 'package:flutter/material.dart';

import '../../models/city.dart';
import '../../widgets/productStatus.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final List<ProductStatus> _productStatusList = [
    ProductStatus(
        product: Product(
          id: '1',
          title: 'Australian Cow',
          images: [
            'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80'
          ],
          date: DateTime(2022, 9, 19),
          totalPrice: 210000,
          location: 'Texas',
          freeDelivery: true,
          deliveryRates: null,
          officePickup: false,
          totalSlots: 10,
          availableSlots: 5,
        ),
        status: Status.DELIVERED),
    ProductStatus(
        product: Product(
            id: '2',
            title: 'African Cow',
            images: [
              'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80'
            ],
            date: DateTime(2022, 9, 16),
            totalPrice: 120000,
            totalSlots: 6,
            availableSlots: 6,
            location: 'New York'),
        status: Status.PAID),
    ProductStatus(
        product: Product(
            id: '3',
            title: 'Mexican Cow',
            images: [
              'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80'
            ],
            date: DateTime(2022, 9, 16),
            totalPrice: 120000,
            totalSlots: 6,
            availableSlots: 2,
            location: 'New York'),
        status: Status.PENDING),
    ProductStatus(
        product: Product(
            id: '4',
            title: 'Mexican Cow',
            images: [
              'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80'
            ],
            date: DateTime(2022, 9, 16),
            totalPrice: 120000,
            totalSlots: 6,
            availableSlots: 2,
            location: 'New York'),
        status: Status.REJECTED),
    ProductStatus(
        product: Product(
            id: '5',
            title: 'Mexican Cow',
            images: [
              'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80'
            ],
            date: DateTime(2022, 9, 16),
            totalPrice: 120000,
            totalSlots: 6,
            availableSlots: 2,
            location: 'Washington'),
        status: Status.REFUNDED)
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: _productStatusList.length,
          itemBuilder: (context, index) {
            return ProductStatusWidget(
                productStatus: _productStatusList[index]);
          }),
    );
  }
}
