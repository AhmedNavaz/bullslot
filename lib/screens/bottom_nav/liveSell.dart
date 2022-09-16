import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/models/liveProduct.dart';
import 'package:bullslot/widgets/liveSellListing.dart';
import 'package:flutter/material.dart';

import '../../constants/images.dart';

class LiveSellScreen extends StatefulWidget {
  LiveSellScreen({super.key});

  @override
  State<LiveSellScreen> createState() => _LiveSellScreenState();
}

class _LiveSellScreenState extends State<LiveSellScreen> {
  int categoryIndex = -1;

  List<LiveProduct> liveProductLists = [
    LiveProduct(
      id: '1',
      title: 'Australian Cow',
      image:
          'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80',
      date: DateTime(2022, 9, 19),
      totalPrice: 210000,
    ),
    LiveProduct(
      id: '2',
      title: 'African Cow',
      image:
          'https://images.unsplash.com/photo-1570042225831-d98fa7577f1e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHx8&w=1000&q=80',
      date: DateTime(2022, 9, 16),
      totalPrice: 120000,
    )
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: 40),
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
              itemCount: liveProductLists.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: LiveSellListingWidget(
                    product: liveProductLists[index],
                  ),
                );
              }),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
