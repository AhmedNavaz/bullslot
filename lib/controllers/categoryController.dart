import 'package:get/get.dart';

import '../models/category.dart';
import '../services/database.dart';

class CategoryController extends GetxController {
  RxList categoriesList = [].obs;

  DatabaseMethods databaseMethods = DatabaseMethods();

  // get all categories from firebase
  Future<void> getCategories() async {
    try {
      await databaseMethods.getCategories().then((value) {
        categoriesList.assignAll(value);
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
