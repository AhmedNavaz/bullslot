import 'package:bullslot/controllers/authController.dart';
import 'package:bullslot/models/orderStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/bankAccount.dart';
import '../models/category.dart';
import '../models/deliveryRate.dart';
import '../models/image.dart';
import '../models/location.dart';
import '../models/product.dart';
import '../models/user.dart';

class DatabaseMethods extends GetxController {
  Future<UserLocal> getUser(String uid) async {
    try {
      final user =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return UserLocal.fromJson(user.data()!);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  uploadUserInfo(UserLocal user) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .set(user.toJson());
  }

  // update user info
  Future<void> updateUserInfo(UserLocal user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update(user.toJson());
  }

  isNewUser(String uid) async {
    if (uid == null) {
      return false;
    } else {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      return doc.exists;
    }
  }

  // get banner images
  Future<List<ImageModel>> getBannerImages() async {
    try {
      final images =
          await FirebaseFirestore.instance.collection('bannerImages').get();
      return images.docs
          .map((e) => ImageModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // get gallery images
  Future<List<ImageModel>> getGalleryImages() async {
    try {
      final images =
          await FirebaseFirestore.instance.collection('galleryImages').get();
      return images.docs
          .map((e) => ImageModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // get delivery rates
  Future<List<DeliveryRate>> getDeliveryRates() async {
    try {
      final deliveryRates = await FirebaseFirestore.instance
          .collection('deliveryRates')
          .orderBy('location')
          .get();
      return deliveryRates.docs
          .map((e) => DeliveryRate.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // get categories
  Future<List<Category>> getCategories() async {
    try {
      final categories = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('name')
          .get();
      return categories.docs
          .map((e) => Category.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // get locations
  Future<List<Location>> getLocations() async {
    try {
      final locations = await FirebaseFirestore.instance
          .collection('locations')
          .orderBy('name')
          .get();
      return locations.docs
          .map((e) => Location.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final products = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('title')
          .get();
      return products.docs
          .map((e) => Product.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // send message
  Future<void> sendMessage(String name, String email, String title,
      String description, String phone) async {
    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'id': Uuid().v1(),
        'name': name,
        'email': email,
        'title': title,
        'description': description,
        'phone': phone,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'isRead': false,
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // send request
  Future<void> sendRequest(int slot, String name, String email,
      String description, String phone) async {
    try {
      await FirebaseFirestore.instance.collection('requests').add({
        'id': Uuid().v1(),
        'slot': slot,
        'name': name,
        'email': email,
        'description': description,
        'phone': phone,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'isRead': false,
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // get bank accounts
  Future<List<BankAccount>> getBankAccounts() async {
    try {
      final bankAccounts = await FirebaseFirestore.instance
          .collection('bankAccounts')
          .orderBy('accountName')
          .get();
      return bankAccounts.docs
          .map((e) => BankAccount.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // add order
  Future<void> addOrder(String userId, OrderStatus order) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("ordersHistory")
          .doc(order.id)
          .set(order.toJson());
      await FirebaseFirestore.instance
          .collection('products')
          .doc(order.productId)
          .collection('orders')
          .doc(order.id)
          .set(order.toJson());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // get office address
  Future<String> getOfficeAddress() async {
    try {
      final officeAddress = await FirebaseFirestore.instance
          .collection('officeAddress')
          .doc('officeAddress')
          .get();
      return officeAddress.data()!['address'];
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // update available slots
  Future<void> updateAvailableSlots(String id, int slot) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .update({'availableSlots': slot});
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // mark as sold
  Future<void> markAsSold(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .update({'sold': true});
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
