import 'dart:async';

import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/constants/navigation.dart';
import 'package:bullslot/controllers/authController.dart';
import 'package:bullslot/controllers/categoryController.dart';
import 'package:bullslot/controllers/locationController.dart';
import 'package:bullslot/controllers/productController.dart';
import 'package:bullslot/router/routerGenerator.dart';
import 'package:bullslot/services/database.dart';
import 'package:bullslot/widgets/productListing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../controllers/imagesController.dart';
import '../../models/city.dart';
import '../../models/deliveryRate.dart';
import '../../models/location.dart';
import '../../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ImagesController imagesController = Get.put(ImagesController());
  CategoryController categoryController = Get.put(CategoryController());
  LocationController locationController = Get.put(LocationController());
  ProductController productController = Get.put(ProductController());
  bool isLoading = true;
  Location? dropdownvalue;

  String? _selectedLocation = 'All';

  List<dynamic> filteredProductList = [];

  @override
  void initState() {
    super.initState();
    imagesController.getBannerImages().then((value) {
      categoryController.getCategories().then((value) {
        locationController.getLocations().then((value) {
          productController.getProducts().then((value) {
            filteredProductList = productController.products;
            setState(() {
              isLoading = false;
            });
          });
        });
      });
    });
  }

  var _currentCarouselIndex = 0;
  int categoryIndex = 0;

  void filterProducts(String category, String location) {
    if (category == 'All' && location == 'All') {
      filteredProductList = productController.products;
    } else if (category == 'All' && location != 'All') {
      filteredProductList = productController.products
          .where((element) => element.location == location)
          .toList();
    } else if (category != 'All' && location == 'All') {
      filteredProductList = productController.products
          .where((element) => element.category == category)
          .toList();
    } else {
      filteredProductList = productController.products
          .where((element) =>
              element.category == category && element.location == location)
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          const SizedBox(height: 20),
          Obx(
            () => Stack(
              children: [
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          viewportFraction: 1,
                          initialPage: 0,
                          autoPlay: imagesController.bannerImages.length > 1
                              ? true
                              : false,
                          autoPlayInterval: const Duration(seconds: 5),
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentCarouselIndex = index;
                            });
                          }),
                      items: imagesController.bannerImages.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  i.url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imagesController.bannerImages.map(
                      (image) {
                        int index =
                            imagesController.bannerImages.indexOf(image);
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  navigationController.navigateTo(deliveryRates);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                child: Row(
                  children: const [
                    Icon(Icons.delivery_dining),
                    SizedBox(width: 5),
                    Text('24/7 Check Rate')
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  navigationController.navigateTo(customRequest);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                ),
                child: const Text('Custom Request'),
              )
            ],
          ),
          const SizedBox(height: 15),
          categoryController.categoriesList.isNotEmpty
              ? Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Category',
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: Colors.black, fontSize: 26),
                  ),
                )
              : Container(),
          const SizedBox(height: 15),
          categoryController.categoriesList.isNotEmpty
              ? SizedBox(
                  height: 35,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: categoryController.categoriesList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              categoryIndex = index;
                            });
                            filterProducts(
                                categoryController
                                    .categoriesList[categoryIndex].name,
                                _selectedLocation!);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: categoryIndex == index
                                    ? primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: categoryIndex == index
                                      ? Colors.transparent
                                      : Colors.black,
                                  width: 1,
                                )),
                            child: Center(
                              child: Text(
                                categoryController.categoriesList[index].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: categoryIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: categoryIndex == index
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              : Container(),
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
                  value: _selectedLocation,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: locationController.locationsList
                      .map<DropdownMenuItem<String>>((dynamic value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value.toString();
                    });
                    filterProducts(
                        categoryController.categoriesList[categoryIndex].name,
                        _selectedLocation!);
                  },
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: primaryColor))
              : productController.products.isEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          'No products added yet!',
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                          parent: NeverScrollableScrollPhysics()),
                      itemCount: filteredProductList.length,
                      itemBuilder: (context, index) {
                        return ProductListingWidget(
                            product: filteredProductList[index]);
                      })
        ],
      ),
    );
  }
}
