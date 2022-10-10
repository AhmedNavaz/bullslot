import 'dart:async';

import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/router/routerGenerator.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentPage = 0;

  PageController pageController = PageController();

  @override
  void initState() {
    // change the page every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          navigationController.navigateTo(login);
        },
        child: PageView(
          controller: pageController,
          children: [
            Image.asset(
              'assets/images/landing_1.jpg',
              fit: BoxFit.fitHeight,
            ),
            Image.asset(
              'assets/images/landing_2.jpg',
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      ),
    );
  }
}
