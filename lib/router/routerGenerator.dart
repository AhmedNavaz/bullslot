import 'package:bullslot/screens/authentication/forgot.dart';
import 'package:flutter/material.dart';

import '../root.dart';

const String root = '/';
const String forgotPassword = 'forgot-password';

class RouteGenerator {
  static Route<dynamic> onGeneratedRoutes(RouteSettings settings) {
    late dynamic args;
    if (settings.arguments != null) {
      args = settings.arguments as Map;
    }
    switch (settings.name) {
      case root:
        return _getPageRoute(const Root());

      case forgotPassword:
        return _getPageRoute(const ForgotPasswordScreen());

      default:
        return _errorRoute();
    }
  }

  static PageRoute _getPageRoute(Widget child) {
    return MaterialPageRoute(builder: (ctx) => child);
  }

  static PageRoute _errorRoute() {
    return MaterialPageRoute(builder: (ctx) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('404'),
        ),
        body: const Center(
          child: Text('ERROR 404: Not Found'),
        ),
      );
    });
  }
}

class IdScreen {}
