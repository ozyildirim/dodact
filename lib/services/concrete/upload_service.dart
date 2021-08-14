import 'dart:io';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class UploadService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference _storageReference;

  // static Future<String> uploadImage(
  //     {@required String category, //içerik, profil fotoğrafı
  //     @required PlatformFile file,
  //     @required String name}) async {
  //   FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  //   Reference _storageReference;
  //   _storageReference = _firebaseStorage
  //       .refFromURL('gs://dodact-7ccd3.appspot.com/')
  //       .child(category)
  //       .child(
  //           "${name ?? file.name.toLowerCase()}. ${file.extension}"); //profil fotoğrafı, içerik gibi
  //   var uploadedImage = _storageReference.putFile(File(file.path));
  //   var downloadUrl = await (await uploadedImage).ref.getDownloadURL();
  //   return downloadUrl;
  // }

  /// Örnek kullanım
  /// * uploadUserPhoto(user.userID,"profile_picture",File(example__file);
  /// * uploadUserPhoto(user.userID,"cover_picture",File(example__file);
  Future<String> uploadUserProfilePhoto(
      {@required String userID,
      @required String fileType,
      @required File fileToUpload}) async {
    var compressedImage = await compressImage(fileToUpload);

    _storageReference = _firebaseStorage
        .ref()
        .child('users')
        .child(userID)
        .child('$fileType.png');

    var uploadTask = _storageReference.putFile(compressedImage);

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
    var compressedImage = await compressImage(fileToUpload);

    _storageReference = _firebaseStorage
        .ref()
        .child('events')
        .child(eventID)
        .child(fileNameAndExtension);

    var uploadTask = _storageReference.putFile(compressedImage);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  //TODO: Klasörlemeyi düzenle.
  Future<String> uploadPostMedia(
      {@required String postId,
      @required fileNameAndExtension,
      @required File fileToUpload,
      @required bool isImage}) async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // var filePath = appDocDir.path + '/' + postId + '/' + fileNameAndExtension;
    var mediaObject = fileToUpload;

    if (isImage) {
      mediaObject = await compressImage(fileToUpload);
    }

    _storageReference = _firebaseStorage
        .ref()
        .child('posts')
        .child(postId)
        .child(fileNameAndExtension);

    var uploadTask = _storageReference.putFile(mediaObject);

    var url = await (await uploadTask).ref.getDownloadURL();

    // final dir = Directory(filePath);
    // dir.deleteSync(recursive: true);

    return url;
  }

  Future<void> deletePostMedia(String postId) async {
    var postRef = storageRef.child('posts').child(postId);

    postRef
        .listAll()
        .then(
          (files) => {
            files.items.forEach((file) {
              file.delete();
            }),
          },
        )
        .catchError((error) {
      print(error);
    });
  }

  Future<void> deleteEventMedia(String eventId) async {
    var eventRef = storageRef.child('events').child(eventId);

    eventRef
        .listAll()
        .then(
          (files) => {
            files.items.forEach((file) {
              file.delete();
            }),
          },
        )
        .catchError((error) {
      print(error);
    });
  }

  Future<File> compressImage(File file) async {
    // Get file path
    // eg:- "Volume/VM/abcd.jpeg"
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        minWidth: 1000, minHeight: 1000, quality: 70);

    return compressedImage;
  }

// FirebaseFirestore.instance.collection('users').doc(user.id).update({
  // 'photo': ImageModel(imageUrl: downloadUrl, blurHash: blurHash).toMap()
  // });

}
