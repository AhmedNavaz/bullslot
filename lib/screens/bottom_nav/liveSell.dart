import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/controllers/categoryController.dart';
import 'package:bullslot/controllers/locationController.dart';
import 'package:bullslot/models/city.dart';
import 'package:bullslot/widgets/productListing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  int categoryIndex = 0;

  String? _selectedLocation = 'All';
  List<dynamic> filteredProductList = [];

  void filterProducts(String category, String location) {
    if (category == 'All' && location == 'All') {
      filteredProductList = productController.liveProducts.where((e) {
        return e.date!.isAfter(DateTime.now()) && e.sold == false;
      }).toList();
    } else if (category == 'All' && location != 'All') {
      filteredProductList = productController.liveProducts
          .where((element) =>
              element.location == location &&
              element.date!.isAfter(DateTime.now()) &&
              element.sold == false)
          .toList();
    } else if (category != 'All' && location == 'All') {
      filteredProductList = productController.liveProducts
          .where((element) =>
              element.category == category &&
              element.date!.isAfter(DateTime.now()) &&
              element.sold == false)
          .toList();
    } else {
      filteredProductList = productController.liveProducts
          .where((element) =>
              element.category == category &&
              element.location == location &&
              element.date!.isAfter(DateTime.now()) &&
              element.sold == false)
          .toList();
    }
    setState(() {});
  }

  @override
  void initState() {
    productController.getProducts().then((value) {
      filteredProductList = productController.liveProducts.where((e) {
        return e.date!.isAfter(DateTime.now()) && e.sold == false;
      }).toList();
    });

    super.initState();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    _refreshController.refreshCompleted();
    productController.getProducts().then((value) {
      filteredProductList = productController.liveProducts.where((e) {
        return e.date!.isAfter(DateTime.now()) && e.sold == false;
      }).toList();
      categoryIndex = 0;
      _selectedLocation = 'All';
      setState(() {});
    });
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      header: const ClassicHeader(
        completeIcon: Icon(
          Icons.done,
          color: primaryColor,
        ),
        refreshingIcon: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: primaryColor,
          ),
        ),
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
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
          filteredProductList.isEmpty
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
                    return Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: ProductListingWidget(
                        product: filteredProductList[index],
                      ),
                    );
                  }),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
