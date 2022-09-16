import 'package:bullslot/screens/authentication/body.dart';
import 'package:bullslot/screens/body.dart';
import 'package:bullslot/screens/bottom_nav/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/authController.dart';

class Root extends GetWidget<AuthController> {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthController>().firebaseUser != null)
          ? const BottomNavBar()
          : const AuthBody();
    });
  }
}
