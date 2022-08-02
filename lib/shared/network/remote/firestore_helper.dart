import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirestoreHelper {
  static final storageRef = FirebaseStorage.instance.ref();

  static Future uploadImage(String folder, File? image) async {
    if (image != null) {
      String? link;
      await storageRef
          .child(
              '${folder.toLowerCase()}/${Uri.file(image.path).pathSegments.last}')
          .putFile(image)
          .then((value) async {
        await value.ref.getDownloadURL().then((value) {
          link = value;
        }).catchError((error) {
          print(error.toString());
        });
      }).catchError((error) {
        print(error.toString());
      });
      return link;
    } else {
      print('the image to upload is null');
      return null;
    }
  }
}
