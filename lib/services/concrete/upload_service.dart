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

  /// Örnek kullanım
  /// * uploadUserPhoto(user.userID,"profile_picture",File(example__file);
  /// * uploadUserPhoto(user.userID,"cover_picture",File(example__file);
  Future<String> uploadUserPhoto(
      String userID, String fileType, File fileToUpload) async {
    _storageReference = _firebaseStorage
        .ref()
        .child('users')
        .child(userID)
        .child('$fileType.png');

    var uploadTask = _storageReference.putFile(fileToUpload);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  /// Örnek kullanım
  /// * uploadGroupPhoto(group.groupID,"profile_picture",File(example__file);
  /// * uploadGroupPhoto(group.groupID,"extra_picture1",File(example__file);
  Future<String> uploadGroupPhoto(
      {String groupID, String fileType, File fileToUpload}) async {
    _storageReference = _firebaseStorage
        .ref()
        .child("groups")
        .child(groupID)
        .child('$fileType.png');

    var uploadTask = _storageReference.putFile(fileToUpload);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  /// Örnek kullanım
  /// * uploadGroupVideo(group.groupID,"group_video",File(example__file);
  Future<String> uploadGroupVideo(
      {String groupID, String fileType, File fileToUpload}) async {
    _storageReference = _firebaseStorage
        .ref()
        .child('groups')
        .child(groupID)
        .child('profile_picture.png');

    var uploadTask = _storageReference.putFile(fileToUpload);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  Future<String> uploadEventPhoto(
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

  Future<String> uploadEventVideo(
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

  Future<String> uploadPostPhoto(
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
