import 'package:bullslot/models/orderStatus.dart';
import 'package:bullslot/services/database.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  RxList bankAccounts = [].obs;
  var officeAddress = ''.obs;

  DatabaseMethods databaseMethods = DatabaseMethods();

  // get bank accounts
  Future<void> getBankAccounts() async {
    try {
      await databaseMethods.getBankAccounts().then((value) {
        bankAccounts.assignAll(value);
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // add order
  Future<void> sendOrder(String userId, OrderStatus order) async {
    try {
      await databaseMethods.addOrder(userId, order);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // get office address
  Future<void> getOfficeAddress() async {
    try {
      await databaseMethods.getOfficeAddress().then((value) {
        officeAddress.value = value;
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // update available slots
  Future<void> updateAvailableSlots(String id, int slot) async {
    try {
      await databaseMethods.updateAvailableSlots(id, slot);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // mark as sold
  Future<void> markAsSold(String id) async {
    try {
      await databaseMethods.markAsSold(id);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
