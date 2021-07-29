import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpDetail_2 extends StatefulWidget {
  @override
  _SignUpDetail_2State createState() => _SignUpDetail_2State();
}

class _SignUpDetail_2State extends BaseState<SignUpDetail_2> {
  PickedFile _profilePicture;
  String error;
  bool _isUploaded = false;
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        backwardsCompatibility: true,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          FlatButton(
              onPressed: () {
                _uploadDefaultPicture();
              },
              child: Text("Atla"))
        ],
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
                              : FileImage(File(_profilePicture.path)),
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
                                                leading: Icon(Icons.camera),
                                                title: Text("Kameradan Çek"),
                                                onTap: () {
                                                  _takePhotoFromCamera(context);
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
                                      borderRadius: BorderRadius.circular(30)),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
    );
  }

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

  //fotoğraf upload edildiyse ileri butonu gelsin, yoksa boş container gözüksün.
  Expanded bottomPart() => Expanded(
      flex: 1,
      child: _isUploaded
          ? Padding(
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
            )
          : Container());

  void _takePhotoFromGallery(BuildContext context) async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePicture = newImage;
      NavigationService.instance.pop();
    });
  }

  void _takePhotoFromCamera(BuildContext context) async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _profilePicture = newImage;
      NavigationService.instance.pop();
    });
  }

  void _updateProfilePhoto(BuildContext context) async {
    if (_profilePicture != null) {
      showLoaderDialog(context);
      await authProvider
          .updateCurrentUserProfilePicture(File(_profilePicture.path))
          .then((url) {
        NavigationService.instance.pop();
        setState(() {
          _isUploaded = true;
        });
        authProvider.currentUser.profilePictureURL = url;
      }).catchError((error) {
        showErrorDialog(context, "Fotoğraf yüklenirken hata oluştu.");
      });

      debugPrint("Picture uploaded.");
    }
  }

  void _moveToInterests() async {
    NavigationService.instance.navigateReplacement(k_ROUTE_INTERESTS_CHOICE);
  }

  void _uploadDefaultPicture() async {
    try {
      await usersRef.doc(authProvider.currentUser.uid).update({
        'profilePictureURL':
            'https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png'
      });
      authProvider.currentUser.profilePictureURL =
          "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png";
      debugPrint("userPicture default olarak ayarlandı.");
      _moveToInterests();
    } catch (e) {
      showErrorDialog(context, "Teknik bir problem oluştu.");
    }
  }

  void showLoaderDialog(BuildContext context) {
    CoolAlert.show(
      barrierDismissible: false,
      context: context,
      type: CoolAlertType.loading,
      text: "Fotoğraf yükleniyor.",
    );
  }

  void showErrorDialog(BuildContext context, String message) {
    CoolAlert.show(
      barrierDismissible: true,
      context: context,
      type: CoolAlertType.error,
      text: message,
    );
  }
}
