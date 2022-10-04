import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  String getRemainingTime(DateTime date) {
    var hours = date.difference(DateTime.now()).inHours;
    var minutes = date.difference(DateTime.now()).inMinutes % 60;
    var seconds = date.difference(DateTime.now()).inSeconds % 60;
    String remaining = '$hours:'.padLeft(3, '0') +
        '$minutes:'.padLeft(3, '0') +
        '$seconds'.padLeft(2, '0');
    if (remaining.contains('-')) {
      return 'Expired';
    }
    return remaining;
  }

  Future<void> saveAndOpenInvoice(List<int> bytes, String filename) async {
    final path = (await getApplicationDocumentsDirectory()).path;
    final file = File('$path/$filename');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$filename');
    ;
  }
}

class ImageHandler {
  static Future<File>? uploadPicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    return imageFile == null ? File('') : File(imageFile.path);
  }
}
