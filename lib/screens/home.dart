import 'package:bullslot/controllers/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'HomeScreen',
            style: Theme.of(context).textTheme.headline1,
          ),
          ElevatedButton(
              onPressed: () {
                _authController.signOut();
              },
              child: Text("Logout"))
        ],
      ),
    );
  }
}
