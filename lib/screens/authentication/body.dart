import 'package:bullslot/screens/authentication/signup.dart';
import 'package:flutter/material.dart';

import '../../constants/navigation.dart';
import 'login.dart';

class AuthBody extends StatelessWidget {
  const AuthBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Expanded(
              child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: navigationController.authSheetController,
            children: [SignupScreen(), LoginScreen()],
          ))
        ],
      ),
    );
  }
}
