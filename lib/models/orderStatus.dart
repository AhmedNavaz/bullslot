import 'package:bullslot/models/product.dart';

enum Status { PENDING, PAID, DELIVERED, REJECTED, REFUNDED }

class OrderStatus {
  String? id;
  Product? product;
  Status? status;
  DateTime? date;
  int? slots;
  String? deliveryCharges;
  String? deliveryType;
  String? imageProof;
  String? bill;
  String? name;
  String? email;
  String? phone;
  String? address;

  OrderStatus({
    this.id,
    this.product,
    this.status,
    this.date,
    this.slots,
    this.deliveryCharges,
    this.deliveryType,
    this.imageProof,
    this.bill,
    this.name,
    this.email,
    this.phone,
    this.address,
  });

  OrderStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null
        ? new Product.fromJson(json['product'] as Map<String, dynamic>)
        : null;
    status =
        json['status'] != null ? Status.values[json['status'] as int] : null;
    date = json['date'] != null ? DateTime.parse(json['date'] as String) : null;
    slots = json['slots'];
    deliveryCharges = json['deliveryCharges'];
    deliveryType = json['deliveryType'];
    imageProof = json['imageProof'];
    bill = json['bill'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.index;
    }
    if (this.date != null) {
      data['date'] = this.date!.toIso8601String();
    }
    data['slots'] = this.slots;
    data['deliveryCharges'] = this.deliveryCharges;
    data['imageProof'] = this.imageProof;
    data['bill'] = this.bill;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    return data;
  }
}
