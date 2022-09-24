import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/screens/bottom_nav/history.dart';
import 'package:bullslot/screens/bottom_nav/home.dart';
import 'package:bullslot/screens/bottom_nav/liveSell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authController.dart';
import '../router/routerGenerator.dart';
import '../services/database.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final AuthController _authController = Get.put(AuthController());

  var isLoading = true;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    databaseMethods.getUser(_authController.firebaseUser!.uid).then((value) {
      _authController.localUser.value = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator(color: primaryColor)))
        : Scaffold(
            drawer: Drawer(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: primaryColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BullSlot',
                            style: Theme.of(context).textTheme.headline2),
                        const SizedBox(height: 30),
                        Text(_authController.localUser.value.name!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white)),
                        const SizedBox(height: 10),
                        Text(_authController.localUser.value.email!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.contact_mail_outlined),
                    title: const Text('Contact Us'),
                    onTap: () {
                      navigationController.navigateTo(contactUs);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_outlined),
                    title: const Text('Gallery'),
                    onTap: () {
                      navigationController.navigateTo(gallery);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group_outlined),
                    title: const Text('About Us'),
                    onTap: () {
                      _authController.signOut();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.policy_outlined),
                    title: const Text('Terms and Conditions'),
                    onTap: () {
                      _authController.signOut();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_outlined),
                    title: const Text('Logout'),
                    onTap: () {
                      _authController.signOut();
                    },
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                _selectedIndex == 0
                    ? 'Home'
                    : _selectedIndex == 1
                        ? 'Live Sell'
                        : 'History',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 22, color: Colors.black),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Slot Deal',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.discount_outlined),
                  label: 'Live Sell',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: accentColor,
              onTap: _onItemTapped,
            ),
            body: IndexedStack(index: _selectedIndex, children: [
              const HomeScreen(),
              LiveSellScreen(),
              HistoryScreen(),
            ]),
          );
  }
}
