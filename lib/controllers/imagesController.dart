import 'package:get/get.dart';

import '../models/image.dart';
import '../services/database.dart';

class ImagesController extends GetxController {
  RxList bannerImages = [].obs;
  RxList galleryImages = [].obs;

  DatabaseMethods databaseMethods = DatabaseMethods();

  // get banner images
  Future<void> getBannerImages() async {
    try {
      databaseMethods.getBannerImages().then((value) {
        bannerImages.assignAll(value);
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // get gallery images
  Future<void> getGalleryImages() async {
    try {
      databaseMethods.getGalleryImages().then((value) {
        galleryImages.assignAll(value);
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
