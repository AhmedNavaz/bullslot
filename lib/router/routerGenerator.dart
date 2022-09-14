import 'package:bullslot/screens/authentication/forgot.dart';
import 'package:bullslot/screens/deliverRates.dart';
import 'package:bullslot/screens/productDetails.dart';
import 'package:flutter/material.dart';

import '../root.dart';

const String root = '/';
const String forgotPassword = 'forgot-password';
const String productDetails = 'product-details';
const String deliveryRates = 'delivery-rates';

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

      case productDetails:
        return _getPageRoute(const ProductDetails());

      case deliveryRates:
        return _getPageRoute(DeliverRates());

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
