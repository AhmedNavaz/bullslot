import 'dart:core';

import 'city.dart';
import 'deliveryRate.dart';

class Product {
  String? id;
  String? title;
  String? image;
  DateTime? date;
  double? totalPrice;
  City? location;
  bool? freeDelivery;
  List<DeliveryRate>? deliveryRates;
  double? officePickupRate;
  int? totalSlots;
  int? availableSlots;

  Product({
    this.id,
    this.title,
    this.image,
    this.date,
    this.totalPrice,
    this.location,
    this.freeDelivery,
    this.deliveryRates,
    this.officePickupRate,
    this.totalSlots,
    this.availableSlots,
  });
}
