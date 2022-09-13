import 'package:bullslot/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants/navigation.dart';
import 'controllers/authBinding.dart';
import 'controllers/navigationController.dart';
import 'router/routerGenerator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(NavigationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AuthBinding(),
      theme: theme,
      debugShowCheckedModeBanner: false,
      initialRoute: root,
      defaultTransition: Transition.zoom,
      onGenerateRoute: RouteGenerator.onGeneratedRoutes,
      navigatorKey: navigationController.navigationKey,
    );
  }
}
