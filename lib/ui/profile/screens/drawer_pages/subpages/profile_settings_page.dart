import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/common_widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends BaseState<ProfileSettingsPage> {
  TextEditingController _emailController;
  TextEditingController _nameSurnameController;
  TextEditingController _usernameController;
  TextEditingController _locationController;

  PickedFile _picture;
  String nameSurname;
  String location;

  bool _isChanged = false;

  FocusNode _nameSurnameFocus = new FocusNode();
  FocusNode _usernameFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    nameSurname = authProvider.currentUser.nameSurname != null
        ? authProvider.currentUser.nameSurname
        : "Belirtilmemiş";

    location = authProvider.currentUser.location != null
        ? authProvider.currentUser.location
        : "Belirtilmemiş";

    _emailController =
        TextEditingController(text: authProvider.currentUser.email);
    _nameSurnameController = TextEditingController(text: nameSurname);
    _usernameController =
        TextEditingController(text: authProvider.currentUser.username);
    _locationController = TextEditingController(text: location);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      floatingActionButton: _isChanged
          ? FloatingActionButton(
              onPressed: () {
                updateUser();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                ],
              ),
            )
          : null,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Profil Ayarları",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profilePicturePart(),
              Text("E-posta Adresi"),
              TextFieldContainer(
                width: mediaQuery.size.width * 0.6,
                child: TextField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              Text("Ad - Soyad"),
              TextFieldContainer(
                width: mediaQuery.size.width * 0.6,
                child: TextField(
                  focusNode: _nameSurnameFocus,
                  controller: _nameSurnameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (_) {
                    setState(() {
                      _isChanged = true;
                    });
                  },
                ),
              ),
              Text("Kullanıcı Adı"),
              TextFieldContainer(
                width: mediaQuery.size.width * 0.6,
                child: TextField(
                  focusNode: _usernameFocus,
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (_) {
                    setState(() {
                      _isChanged = true;
                    });
                  },
                ),
              ),
              Text("Lokasyon"),
              InkWell(
                onTap: () => _showLocationPicker(),
                child: TextFieldContainer(
                  width: mediaQuery.size.width * 0.6,
                  child: TextField(
                    enabled: false,
                    readOnly: true,
                    controller: _locationController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilePicturePart() {
    return Container(
      height: 250,
      width: double.infinity,
      child: Center(
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 200,
              height: 200,
              child: Image.network(
                authProvider.currentUser.profilePictureURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 160,
            child: InkWell(
              onTap: () {
                _showPickerOptions();
              },
              child: GFBadge(
                size: 60,
                child: Icon(FontAwesome5Solid.camera,
                    color: Colors.white, size: 20),
                shape: GFBadgeShape.circle,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  //TODO: Sosyal medya girişlerini ekle

  Future<void> _showPickerOptions() {
    return showModalBottomSheet(
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
                    _takePhotoFromGallery();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Kameradan Çek"),
                  onTap: () {
                    _takePhotoFromCamera();
                  },
                )
              ],
            ),
          );
        });
  }

  void _takePhotoFromGallery() async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _picture = newImage;
      NavigationService.instance.pop();
    });
    _updateProfilePhoto();
  }

  void _takePhotoFromCamera() async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _picture = newImage;
      NavigationService.instance.pop();
    });
    _updateProfilePhoto();
  }

  void _updateProfilePhoto() async {
    showLoaderDialog("Fotoğrafınız değiştiriliyor.");
    await authProvider
        .updateCurrentUserProfilePicture(File(_picture.path))
        .then((url) {
      NavigationService.instance.pop();
      debugPrint("Picture uploaded.");
    }).catchError((error) {
      showErrorDialog(context, "Fotoğraf yüklenirken hata oluştu.");
    });
  }

  void showLoaderDialog(String message) {
    CoolAlert.show(
      barrierDismissible: false,
      context: context,
      type: CoolAlertType.loading,
      text: message,
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

  Future<String> _showLocationPicker() {
    return showMaterialScrollPicker<String>(
      context: context,
      title: 'Pick Your State',
      items: cities,
      selectedItem: location,
      onChanged: (value) {
        setState(() {
          location = value;
          _locationController.text = value;
          _isChanged = true;
        });
      },
    );
  }

  Future<void> updateUser() async {
    try {
      showLoaderDialog("Değişiklikler kaydediliyor.");
      await authProvider.updateCurrentUser({
        'location': _locationController.text,
        'username': _usernameController.text,
        'nameSurname': _nameSurnameController.text,
      });
      NavigationService.instance.pop();
      setState(() {
        _isChanged = false;
      });
    } catch (e) {
      showErrorDialog(context, "Değişiklikler kaydedilirken bir hata oluştu");
    }
  }
}
