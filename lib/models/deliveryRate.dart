import 'city.dart';

enum DeliveryType { CAR, VAN }

class DeliveryRate {
  String? id;
  City? city;
  DeliveryType? type;
  double? rate;

  DeliveryRate({this.id, this.city, this.type, this.rate});
}
