import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
    FirebaseFirestore.instance.collection("users").doc(user.id).set({
      "uid": user.id,
      "name": user.name,
      "email": user.email,
      "dp": user.dp,
      "token": user.token,
    }).catchError((e) {
      print(e.toString());
    });
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
}
