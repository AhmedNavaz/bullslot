enum DeliveryType { CAR, VAN }

class DeliveryRate {
  String? id;
  String? location;
  DeliveryType? type;
  int? rate;

  DeliveryRate({this.id, this.location, this.type, this.rate});

  DeliveryRate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    type = json['type'] == 'CAR' ? DeliveryType.CAR : DeliveryType.VAN;
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['type'] = this.type == DeliveryType.CAR ? 'CAR' : 'VAN';
    data['rate'] = this.rate;
    return data;
  }
}
