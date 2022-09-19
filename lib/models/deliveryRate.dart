import 'city.dart';

enum DeliveryType { CAR, VAN }

class DeliveryRate {
  City? city;
  DeliveryType? type;
  double? rate;

  DeliveryRate({this.city, this.type, this.rate});
}
