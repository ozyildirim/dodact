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
  Future<String> uploadUserProfilePhoto(
      {@required String userID,
      @required String fileType,
      @required File fileToUpload}) async {
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
  // Future<String> uploadGroupPhoto({String groupID, File fileToUpload}) async {
  //   _storageReference = _firebaseStorage
  //       .ref()
  //       .child("groups")
  //       .child(groupID)
  //       .child('$fileType.png');
  //
  //   var uploadTask = _storageReference.putFile(fileToUpload);
  //
  //   var url = await (await uploadTask).ref.getDownloadURL();
  //   return url;
  // }

  /// Örnek kullanım
  /// * uploadGroupVideo(group.groupID,"group_video",File(example__file);
  // Future<String> uploadGroupVideo({String groupID, File fileToUpload}) async {
  //   _storageReference = _firebaseStorage
  //       .ref()
  //       .child('groups')
  //       .child(groupID)
  //       .child('profile_picture.png');
  //
  //   var uploadTask = _storageReference.putFile(fileToUpload);
  //
  //   var url = await (await uploadTask).ref.getDownloadURL();
  //   return url;
  // }

  Future<String> uploadEventMedia({
    @required String eventID,
    @required String fileNameAndExtension,
    @required File fileToUpload,
  }) async {
    _storageReference = _firebaseStorage
        .ref()
        .child('events')
        .child(eventID)
        .child(fileNameAndExtension);

    var uploadTask = _storageReference.putFile(fileToUpload);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  //TODO: Klasörlemeyi düzenle.
  Future<String> uploadPostMedia(
      {@required String postID,
      @required fileNameAndExtension,
      @required File fileToUpload}) async {
    _storageReference = _firebaseStorage
        .ref()
        .child('posts')
        .child(postID)
        .child(fileNameAndExtension);

    var uploadTask = _storageReference.putFile(fileToUpload);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

// FirebaseFirestore.instance.collection('users').doc(user.id).update({
  // 'photo': ImageModel(imageUrl: downloadUrl, blurHash: blurHash).toMap()
  // });

}
