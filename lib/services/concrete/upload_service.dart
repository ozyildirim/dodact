import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference _storageReference;

  static Future<String> uploadImage(
      {@required String category, //içerik, profil fotoğrafı
      @required PlatformFile file,
      @required String name}) async {
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    Reference _storageReference;
    _storageReference = _firebaseStorage
        .refFromURL('gs://dodact-7ccd3.appspot.com/')
        .child(category)
        .child(
            "${name ?? file.name.toLowerCase()}. ${file.extension}"); //profil fotoğrafı, içerik gibi
    var uploadedImage = _storageReference.putFile(File(file.path));
    var downloadUrl = await (await uploadedImage).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadFile(
      String userID, String fileType, File fileToUpload) async {
    _storageReference = _firebaseStorage
        .ref()
        .child(fileType)
        .child('users')
        .child('profile_picture.png');

    var uploadTask = _storageReference.putFile(fileToUpload);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  // FirebaseFirestore.instance.collection('users').doc(user.id).update({
  // 'photo': ImageModel(imageUrl: downloadUrl, blurHash: blurHash).toMap()
  // });

}
