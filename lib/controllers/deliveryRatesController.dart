import 'package:get/get.dart';

import '../services/database.dart';

class DeliveryRatesController extends GetxController {
  RxList deliveryRatesList = [].obs;

  DatabaseMethods databaseMethods = DatabaseMethods();

  // get all delivery rates from firebase
  Future<void> getDeliveryRates() async {
    try {
      await databaseMethods.getDeliveryRates().then((value) {
        deliveryRatesList.assignAll(value);
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
