import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/router/routerGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../services/database.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var localUser = UserLocal().obs;

  final Rxn<User> _firebaseUser = Rxn<User>();
  User? get firebaseUser => _firebaseUser.value;

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void onInit() async {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future signUp(String email, String password, String name) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      UserLocal user = UserLocal(
        id: authResult.user!.uid,
        name: name,
        email: email,
        phone: '',
        address: '',
      );
      localUser.value = user;
      databaseMethods.uploadUserInfo(user);
      Get.back();
    } catch (e) {
      Get.snackbar(
        '',
        '',
        titleText: const Text('Error Creating Account',
            style: TextStyle(fontWeight: FontWeight.bold)),
        messageText: Text(
          e.toString().split('] ')[1],
        ),
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      localUser.value = await databaseMethods.getUser(authResult.user!.uid);
      Get.back();
    } catch (e) {
      Get.snackbar(
        '',
        '',
        titleText: const Text('Error Signing In',
            style: TextStyle(fontWeight: FontWeight.bold)),
        messageText: Text(
          e.toString().split('] ')[1],
        ),
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return null;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      Get.snackbar(
        '',
        '',
        titleText: const Text('Email Not Found',
            style: TextStyle(fontWeight: FontWeight.bold)),
        messageText: Text(
          e.toString().split('] ')[1],
        ),
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
    return false;
  }

  void signOut() async {
    try {
      // FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(localUser.value.id)
      //     .update({"token": FieldValue.delete()}).then((value) {
      //   _auth.signOut();
      // });
      _auth.signOut().then((value) {
        navigationController.navigateTo(login);
      });
    } catch (e) {
      Get.snackbar(
        '',
        '',
        titleText: const Text(
          'Error Signing Out',
        ),
        messageText: Text(
          e.toString(),
        ),
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
