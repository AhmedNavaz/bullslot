import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/controllers/categoryController.dart';
import 'package:bullslot/controllers/locationController.dart';
import 'package:bullslot/models/city.dart';
import 'package:bullslot/widgets/productListing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/images.dart';
import '../../controllers/productController.dart';
import '../../models/deliveryRate.dart';
import '../../models/location.dart';
import '../../models/product.dart';

class LiveSellScreen extends StatefulWidget {
  LiveSellScreen({super.key});

  @override
  State<LiveSellScreen> createState() => _LiveSellScreenState();
}

class _LiveSellScreenState extends State<LiveSellScreen> {
  ProductController productController = Get.find<ProductController>();
  CategoryController categoryController = Get.find<CategoryController>();
  LocationController locationController = Get.find<LocationController>();
  Location? dropdownvalue;

  int categoryIndex = -1;

  String? _selectedLocation = 'All';
  List<dynamic> filteredProductList = [];

  // filter with category
  void filterCategory(String category) {
    setState(() {
      filteredProductList = productController.liveProducts
          .where((element) => element.category == category)
          .toList();
    });
  }

  // filter with location
  void filterLocation(String location) {
    setState(() {
      filteredProductList = productController.liveProducts
          .where((element) => element.location == location)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
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
                    itemCount: categoryController.categoriesList.length + 1,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            categoryIndex = index;
                          });
                          if (index == 0) {
                            setState(() {
                              filteredProductList =
                                  productController.liveProducts;
                            });
                          } else {
                            filterCategory(categoryController
                                .categoriesList[index - 1].name);
                          }
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
                              index == 0
                                  ? 'All'
                                  : categoryController
                                      .categoriesList[index - 1].name,
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
                  if (_selectedLocation == 'All') {
                    setState(() {
                      filteredProductList = productController.liveProducts;
                    });
                  } else {
                    filterLocation(_selectedLocation!);
                  }
                },
              ),
            ],
          ),
        ),
        productController.liveProducts.isEmpty
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
                itemCount: productController.liveProducts.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: ProductListingWidget(
                      product: productController.liveProducts[index],
                    ),
                  );
                }),
        const SizedBox(height: 30),
      ],
    );
  }
}
