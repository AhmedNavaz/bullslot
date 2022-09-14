import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<String> carouselImages = [
    'https://images.olx.com.pk/thumbnails/267000683-400x300.jpeg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwewJkQqGeQ-EjXTkXXsBHjl1qKM9Ex_guk3T5i3k974xGernQJTFxdzAS3ZpWxQrX_nk&usqp=CAU',
    'https://images.olx.com.pk/thumbnails/262165746-400x300.jpeg'
  ];
  int carouselIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
                height: 400.0,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                onPageChanged: (index, _) {
                  setState(() {
                    carouselIndex = index;
                  });
                }),
            items: carouselImages.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Image.network(
                      i,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: carouselImages.map(
                (image) {
                  int index = carouselImages.indexOf(image);
                  return Container(
                    width: 8,
                    height: 8,
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: carouselIndex == index
                            ? Border.all(width: 3, color: Colors.white)
                            : Border.all(
                                width: 1,
                                color: Colors.white.withOpacity(0.75)),
                        color: Colors.transparent),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
