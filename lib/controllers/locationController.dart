import 'package:get/get.dart';

import '../models/location.dart';
import '../services/database.dart';

class LocationController extends GetxController {
  RxList locationsList = [].obs;

  DatabaseMethods databaseMethods = DatabaseMethods();

  // get all locations from firebase
  Future<void> getLocations() async {
    try {
      await databaseMethods.getLocations().then((value) {
        locationsList.clear();
        locationsList.add('All');
        for (var element in value) {
          locationsList.add(element.name);
        }
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
