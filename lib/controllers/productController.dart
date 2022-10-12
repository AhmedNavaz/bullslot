import 'package:get/state_manager.dart';

import '../models/product.dart';
import '../services/database.dart';

class ProductController extends GetxController {
  RxList products = [].obs;
  RxList liveProducts = [].obs;

  DatabaseMethods databaseMethods = DatabaseMethods();

  // get all products from firebase
  Future<void> getProducts() async {
    try {
      await databaseMethods.getProducts().then((value) {
        products.clear();
        liveProducts.clear();
        value.map((e) {
          if (e.totalSlots == null) {
            liveProducts.add(e);
          } else {
            products.add(e);
          }
        }).toList();
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
