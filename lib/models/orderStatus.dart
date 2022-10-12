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
  String? userId;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? invoiceUrl;
  String? refundReason;
  String? refundProof;

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
    this.userId,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.invoiceUrl,
    this.refundReason,
    this.refundProof,
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
    userId = json['userId'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    invoiceUrl = json['invoiceUrl'];
    refundReason = json['refundReason'];
    refundProof = json['refundProof'];
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
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['invoiceUrl'] = this.invoiceUrl;
    data['refundReason'] = this.refundReason;
    data['refundProof'] = this.refundProof;
    return data;
  }
}
