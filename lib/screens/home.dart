import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/controllers/authController.dart';
import 'package:bullslot/widgets/productListing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../constants/images.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = Get.put(AuthController());

  List<int> carouselImgList = [1, 2, 3, 4];
  var _currentCarouselIndex = 0;

  int categoryIndex = -1;

  final List<Product> _productList = [
    Product(
        id: '1',
        title: 'Australian Cow',
        image:
            'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80',
        date: DateTime(2022, 9, 15),
        totalPrice: 210000,
        totalSlots: 7,
        bookedSlots: 0,
        weight: 100),
    Product(
        id: '2',
        title: 'African Cow',
        image:
            'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80',
        date: DateTime(2022, 9, 16),
        totalPrice: 120000,
        totalSlots: 6,
        bookedSlots: 6,
        weight: 90)
  ];

  String dropdownvalue = 'New York';

  var items = [
    'New York',
    'Louisiana',
    'Texas',
    'Mexico',
    'LA',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: primaryColor),
              child: Center(
                child: Text('BullSlot',
                    style: Theme.of(context).textTheme.headline2),
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
          'Home',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Card(
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                          child: CarouselSlider(
                        options: CarouselOptions(
                            initialPage: 0,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentCarouselIndex = index;
                              });
                            }),
                        items: carouselImgList.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text(
                                      'Image $i',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                  ));
                            },
                          );
                        }).toList(),
                      )),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: MediaQuery.of(context).size.width * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: carouselImgList.map(
                        (image) {
                          int index = carouselImgList.indexOf(image);
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentCarouselIndex == index
                                    ? Colors.white
                                    : secondaryColor.withOpacity(0.5)),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Category',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Colors.black, fontSize: 26),
              ),
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: animalTypeImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          categoryIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: categoryIndex == index
                                  ? secondaryColor
                                  : Colors.white,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(animalTypeImages[index]),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(animalTypeNames[index],
                                style: Theme.of(context).textTheme.bodySmall)
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Location',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                    parent: NeverScrollableScrollPhysics()),
                itemCount: _productList.length,
                itemBuilder: (context, index) {
                  return ProductListing(product: _productList[index]);
                })
          ],
        ),
      ),
    );
  }
}
