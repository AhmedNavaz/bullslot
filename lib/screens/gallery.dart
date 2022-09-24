import 'package:bullslot/constants/colors.dart';
import 'package:bullslot/controllers/imagesController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryScreen extends StatefulWidget {
  GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  ImagesController imagesController = Get.find<ImagesController>();
  bool isLoading = true;

  @override
  void initState() {
    imagesController.getGalleryImages().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: primaryColor))
            : Obx(
                () => GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: imagesController.galleryImages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imagesController.galleryImages[index].url,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
