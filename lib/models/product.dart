import 'dart:core';

import 'deliveryRate.dart';

class Product {
  String? id;
  String? title;
  List<String>? images;
  DateTime? date;
  String? totalPrice;
  String? description;
  String? location;
  String? category;
  bool? freeDelivery;
  List<DeliveryRate>? deliveryRates;
  bool? officePickup;
  int? totalSlots;
  int? availableSlots;
  bool? sold;

  Product({
    this.id,
    this.title,
    this.images,
    this.date,
    this.totalPrice,
    this.description,
    this.location,
    this.category,
    this.freeDelivery,
    this.deliveryRates,
    this.officePickup,
    this.totalSlots,
    this.availableSlots,
    this.sold,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    images = json['images'].cast<String>();
    date = DateTime.parse(json['date']);
    totalPrice = json['totalPrice'];
    description = json['description'];
    location = json['location'];
    category = json['category'];
    freeDelivery = json['freeDelivery'];
    if (json['deliveryRates'] != null) {
      deliveryRates = <DeliveryRate>[];
      json['deliveryRates'].forEach((v) {
        deliveryRates!.add(new DeliveryRate.fromJson(v));
      });
    }
    officePickup = json['officePickup'];
    totalSlots = json['totalSlots'];
    availableSlots = json['availableSlots'];
    sold = json['sold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['images'] = this.images;
    data['date'] = this.date!.toIso8601String();
    data['totalPrice'] = this.totalPrice;
    data['description'] = this.description;
    data['location'] = this.location;
    data['category'] = this.category;
    data['freeDelivery'] = this.freeDelivery;
    if (this.deliveryRates != null) {
      data['deliveryRates'] =
          this.deliveryRates!.map((v) => v.toJson()).toList();
    }
    data['officePickup'] = this.officePickup;
    data['totalSlots'] = this.totalSlots;
    data['availableSlots'] = this.availableSlots;
    data['sold'] = this.sold;
    return data;
  }
}
