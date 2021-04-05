import 'dart:io';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpDetail_2 extends StatefulWidget {
  @override
  _SignUpDetail_2State createState() => _SignUpDetail_2State();
}

class _SignUpDetail_2State extends BaseState<SignUpDetail_2> {
  PickedFile _profilePicture;
  String error;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          backwardsCompatibility: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          width: dynamicWidth(1),
          child: Column(
            children: [
              upperPart(),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: _profilePicture == null
                                ? NetworkImage(
                                    "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png")
                                : AssetImage(_profilePicture.path),
                            radius: 80,
                            backgroundColor: Colors.transparent,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    //TODO : Image Picker hatası düzenlenmeli. Fotoğraf seçilemiyor.
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: 120,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading: Icon(Icons.image),
                                                  title: Text("Galeriden Seç"),
                                                  onTap: () {
                                                    _takePhotoFromGallery(
                                                        context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(
                                                      Icons.camera),
                                                  title: Text("Kameradan Çek"),
                                                  onTap: () {
                                                    _takePhotoFromCamera(
                                                        context);
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    child: Text("Fotoğraf Seç"),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    padding: EdgeInsets.all(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _profilePicture != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            _updateProfilePhoto(context);
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 30,
                                            child: Text(
                                              "Yükle",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              bottomPart()
            ],
          ),
        ),
      ),
    );
  }

  // Expanded middlePart() {
  //   return Expanded(
  //       flex: 3,
  //       child: Container(
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Column(
  //             children: [
  //               CircleAvatar(
  //                 backgroundImage: _profilePicture == null
  //                     ? NetworkImage(
  //                         "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png")
  //                     : AssetImage(_profilePicture.path),
  //                 radius: 80,
  //                 backgroundColor: Colors.transparent,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: GestureDetector(
  //                       onTap: () {
  //                         //TODO : Image Picker hatası düzenlenmeli. Fotoğraf seçilemiyor.
  //                         showModalBottomSheet(
  //                             context: context,
  //                             builder: (context) {
  //                               return Container(
  //                                 height: 120,
  //                                 child: Column(
  //                                   children: [
  //                                     ListTile(
  //                                       leading: Icon(Icons.image),
  //                                       title: Text("Galeriden Seç"),
  //                                       onTap: () {
  //                                         _takePhotoFromGallery(context);
  //                                       },
  //                                     ),
  //                                     ListTile(
  //                                       leading: Icon(FontAwesomeIcons.camera),
  //                                       title: Text("Kameradan Çek"),
  //                                       onTap: () {
  //                                         _takePhotoFromCamera(context);
  //                                       },
  //                                     )
  //                                   ],
  //                                 ),
  //                               );
  //                             });
  //                       },
  //                       child: Container(
  //                         alignment: Alignment.bottomRight,
  //                         child: Text("Fotoğraf Seç"),
  //                         decoration: BoxDecoration(
  //                             color: Colors.blue,
  //                             borderRadius: BorderRadius.circular(30)),
  //                         padding: EdgeInsets.all(16),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   _profilePicture != null
  //                       ? Padding(
  //                           padding: const EdgeInsets.all(16.0),
  //                           child: Container(
  //                             alignment: Alignment.bottomRight,
  //                             child: GestureDetector(
  //                               onTap: () {
  //                                 _updateProfilePhoto(context);
  //                               },
  //                               child: CircleAvatar(
  //                                 backgroundColor: Colors.black,
  //                                 radius: 30,
  //                                 child: Text(
  //                                   "Yükle",
  //                                   style: TextStyle(color: Colors.white),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       : Container()
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ));
  // }

  Expanded upperPart() {
    return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Bir de profil fotoğrafı rica edebilir miyiz?",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 25),
          ),
        ));
  }

  Expanded bottomPart() => Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            _moveToInterests();
          },
          child: Container(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 25,
              child: Icon(
                Icons.navigate_next,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));

  void _takePhotoFromGallery(BuildContext context) async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePicture = newImage;
      Navigator.of(context).pop(context);
    });
  }

  void _takePhotoFromCamera(BuildContext context) async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _profilePicture = newImage;
      Navigator.of(context).pop(context);
    });
  }

  void _updateProfilePhoto(BuildContext context) async {
    if (_profilePicture != null) {
      var url = await UploadService().uploadFile(
          authProvider.currentUser.uid, 'profile_picture', File(_profilePicture.path));
      return await usersRef
          .doc(authProvider.currentUser.uid)
          .update({'profilePictureURL': url})
          .then((value) => print("UserProfilePicture Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      debugPrint("Picture uploaded.");
    }
  }

  void _moveToInterests() async {
    if (_profilePicture == null) {
      await usersRef.doc(authProvider.currentUser.uid).update({
        'profilePictureURL':
            'https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png'
      });
      debugPrint("userPicture default olarak ayarlandı.");
    }
    NavigationService.instance.navigateReplacement('/interest_choice');
  }
}
