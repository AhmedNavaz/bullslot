import 'package:bullslot/models/product.dart';

enum Status { PENDING, PAID, DELIVERED, REJECTED, REFUNDED }

class OrderStatus {
  String? id;
  String? productId;
  Status? status;
  DateTime? date;
  int? slots;
  String? deliveryCharges;
  String? deliveryType;
  String? imageProof;
  String? bill;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? invoiceUrl;

  OrderStatus({
    this.id,
    this.productId,
    this.status,
    this.date,
    this.slots,
    this.deliveryCharges,
    this.deliveryType,
    this.imageProof,
    this.bill,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.invoiceUrl,
  });

  OrderStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    status =
        json['status'] != null ? Status.values[json['status'] as int] : null;
    date = json['date'] != null ? DateTime.parse(json['date'] as String) : null;
    slots = json['slots'];
    deliveryCharges = json['deliveryCharges'];
    deliveryType = json['deliveryType'];
    imageProof = json['imageProof'];
    bill = json['bill'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    invoiceUrl = json['invoiceUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    if (this.status != null) {
      data['status'] = this.status!.index;
    }
    if (this.date != null) {
      data['date'] = this.date!.toIso8601String();
    }
    data['slots'] = this.slots;
    data['deliveryCharges'] = this.deliveryCharges;
    data['deliveryType'] = this.deliveryType;
    data['imageProof'] = this.imageProof;
    data['bill'] = this.bill;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['invoiceUrl'] = this.invoiceUrl;
    return data;
  }
}
