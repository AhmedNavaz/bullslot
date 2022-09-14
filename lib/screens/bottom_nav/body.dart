import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/screens/bottom_nav/history.dart';
import 'package:bullslot/screens/bottom_nav/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/authController.dart';
import '../../services/database.dart';

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

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    HistoryScreen(),
  ];

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
                    leading: const Icon(Icons.logout),
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
                _selectedIndex == 0 ? 'Home' : 'History',
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
                  icon: Icon(Icons.home),
                  label: 'Home',
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
            body: _widgetOptions.elementAt(_selectedIndex),
          );
  }
}
