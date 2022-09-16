import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Gallery',
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 20,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Image.network(
                'https://media.istockphoto.com/photos/baby-sheep-close-up-picture-id1164046558?k=20&m=1164046558&s=612x612&w=0&h=zxGnSQ5FUPcLfES4v4tzz4836vepegA8bcevwjnkf0s=',
                fit: BoxFit.cover,
              );
            }),
      ),
    );
  }
}
