import 'dart:io';

import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserPersonalProfileSettingsPage extends StatefulWidget {
  @override
  _UserPersonalProfileSettingsPageState createState() =>
      _UserPersonalProfileSettingsPageState();
}

class _UserPersonalProfileSettingsPageState
    extends BaseState<UserPersonalProfileSettingsPage> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  TextEditingController emailController;
  TextEditingController locationController;

  PickedFile picture;
  String nameSurname;
  String location;
  String education;
  String profession;

  bool isChanged = false;

  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  FocusNode nameSurnameFocus = new FocusNode();
  FocusNode usernameFocus = new FocusNode();
  FocusNode descriptionFocus = new FocusNode();
  FocusNode educationFocus = new FocusNode();
  FocusNode professionFocus = new FocusNode();

  @override
  void initState() {
    super.initState();

    location = authProvider.currentUser.location != null
        ? authProvider.currentUser.location
        : "Belirtilmemiş";

    emailController =
        TextEditingController(text: authProvider.currentUser.email);
  }

  @override
  void dispose() {
    usernameFocus.dispose();
    nameSurnameFocus.dispose();
    descriptionFocus.dispose();
    educationFocus.dispose();
    professionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      floatingActionButton: isChanged
          ? FloatingActionButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
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
          "Kişisel Bilgiler",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: dynamicHeight(1),
          width: dynamicWidth(1),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(kBackgroundImage),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                autovalidateMode: autoValidate,
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    profilePicturePart(),
                    Container(
                      color: Colors.white70,
                      child: Text(
                        "E-posta Adresi",
                        style: TextStyle(fontSize: kSettingsTitleSize),
                      ),
                    ),
                    TextFieldContainer(
                      width: mediaQuery.size.width * 0.9,
                      child: FormBuilderTextField(
                        name: "email",
                        controller: emailController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white70,
                      child: Text(
                        "Ad - Soyad",
                        style: TextStyle(fontSize: kSettingsTitleSize),
                      ),
                    ),
                    TextFieldContainer(
                      width: mediaQuery.size.width * 0.9,
                      child: FormBuilderTextField(
                        name: "nameSurname",
                        focusNode: nameSurnameFocus,
                        initialValue:
                            authProvider.currentUser.nameSurname ?? "",
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          if (authProvider.currentUser.nameSurname != value) {
                            setState(() {
                              isChanged = true;
                            });
                          } else {
                            setState(() {
                              isChanged = false;
                            });
                          }
                        },
                        validator: FormBuilderValidators.compose([
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          }
                        ]),
                      ),
                    ),
                    Container(
                      color: Colors.white70,
                      child: Text(
                        "Kullanıcı Adı",
                        style: TextStyle(fontSize: kSettingsTitleSize),
                      ),
                    ),
                    TextFieldContainer(
                      width: mediaQuery.size.width * 0.9,
                      child: FormBuilderTextField(
                        name: "username",
                        focusNode: usernameFocus,
                        initialValue: authProvider.currentUser.username,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          if (authProvider.currentUser.username != value) {
                            setState(() {
                              isChanged = true;
                            });
                          } else {
                            setState(() {
                              isChanged = false;
                            });
                          }
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            context,
                            errorText: "Bu alan boş bırakılamaz.",
                          ),
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          },
                        ]),
                      ),
                    ),
                    Container(
                      color: Colors.white70,
                      child: Text(
                        "Lokasyon",
                        style: TextStyle(fontSize: kSettingsTitleSize),
                      ),
                    ),
                    TextFieldContainer(
                      width: mediaQuery.size.width * 0.9,
                      child: FormBuilderDropdown(
                        name: "location",
                        initialValue: location,
                        items: cities
                            .map((city) => DropdownMenuItem(
                                  value: city,
                                  child: Text('$city'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (location != value) {
                            setState(() {
                              isChanged = true;
                            });
                          } else {
                            setState(() {
                              isChanged = false;
                            });
                          }
                        },
                        validator: FormBuilderValidators.compose([
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          }
                        ]),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.location_city),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white70,
                      child: Text(
                        "Hakkımda",
                        style: TextStyle(fontSize: kSettingsTitleSize),
                      ),
                    ),
                    TextFieldContainer(
                      width: mediaQuery.size.width * 0.9,
                      child: FormBuilderTextField(
                        name: "userDescription",
                        maxLines: 3,
                        focusNode: descriptionFocus,
                        initialValue: authProvider.currentUser.userDescription,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (value) {
                          if (authProvider.currentUser.userDescription !=
                              value) {
                            setState(() {
                              isChanged = true;
                            });
                          } else {
                            setState(() {
                              isChanged = false;
                            });
                          }
                        },
                        validator: FormBuilderValidators.compose([
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          }
                        ]),
                      ),
                    ),
                    Container(
                      color: Colors.white70,
                      child: Text(
                        "Okul/Eğitim Kurumu",
                        style: TextStyle(fontSize: kSettingsTitleSize),
                      ),
                    ),
                    TextFieldContainer(
                      width: mediaQuery.size.width * 0.9,
                      child: FormBuilderTextField(
                        name: "education",
                        maxLines: 1,
                        focusNode: educationFocus,
                        initialValue: authProvider.currentUser.education,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.school),
                        ),
                        validator: FormBuilderValidators.compose([
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          }
                        ]),
                        onChanged: (value) {
                          if (authProvider.currentUser.education != value) {
                            setState(() {
                              isChanged = true;
                            });
                          } else {
                            setState(() {
                              isChanged = false;
                            });
                          }
                        },
                      ),
                    ),
                    Container(
                      color: Colors.white70,
                      child: Text(
                        "Meslek",
                        style: TextStyle(fontSize: kSettingsTitleSize),
                      ),
                    ),
                    TextFieldContainer(
                      width: mediaQuery.size.width * 0.9,
                      child: FormBuilderTextField(
                        name: "profession",
                        maxLines: 1,
                        focusNode: professionFocus,
                        initialValue: authProvider.currentUser.profession,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.work),
                        ),
                        onChanged: (value) {
                          if (authProvider.currentUser.profession != value) {
                            setState(() {
                              isChanged = true;
                            });
                          } else {
                            setState(() {
                              isChanged = false;
                            });
                          }
                        },
                        validator: FormBuilderValidators.compose([
                          (value) {
                            return ProfanityChecker.profanityValidator(
                                value.trim());
                          }
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profilePicturePart() {
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
                showPickerOptions();
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

  Future<void> showPickerOptions() {
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
                    takePhotoFromGallery();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Kameradan Çek"),
                  onTap: () {
                    takePhotoFromCamera();
                  },
                )
              ],
            ),
          );
        });
  }

  void takePhotoFromGallery() async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      picture = newImage;
      NavigationService.instance.pop();
    });
    if (picture != null) {
      updateProfilePhoto();
    } else {
      print("Kullanıcı fotoğraf seçmekten vazgeçti.");
    }
  }

  void takePhotoFromCamera() async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      picture = newImage;
      NavigationService.instance.pop();
    });
    if (picture != null) {
      updateProfilePhoto();
    } else {
      print("Kullanıcı fotoğraf seçmekten vazgeçti.");
    }
  }

  void updateProfilePhoto() async {
    CommonMethods().showLoaderDialog(context, "Fotoğrafınız değiştiriliyor.");
    await authProvider
        .updateCurrentUserProfilePicture(File(picture.path))
        .then((url) {
      NavigationService.instance.pop();
      debugPrint("Picture uploaded.");
    }).catchError((error) {
      CommonMethods()
          .showErrorDialog(context, "Fotoğraf yüklenirken hata oluştu.");
    });
  }

  Future<void> updateUser() async {
    if (formKey.currentState.saveAndValidate()) {
      try {
        CommonMethods().showLoaderDialog(context, "Değişiklikler Kaydediliyor");
        await authProvider.updateCurrentUser({
          'location': formKey.currentState.value['location'].toString().trim(),
          'username': formKey.currentState.value['username'].toString().trim(),
          'nameSurname': formKey.currentState.value['nameSurname'].toString(),
          'userDescription':
              formKey.currentState.value['userDescription'].toString().trim(),
          'education':
              formKey.currentState.value['education'].toString().trim(),
          'profession':
              formKey.currentState.value['profession'].toString().trim(),
        });
        NavigationService.instance.pop();
        setState(() {
          isChanged = false;
        });
      } catch (e) {
        CommonMethods().showErrorDialog(
            context, "Değişiklikler kaydedilirken bir hata oluştu");
      }
    } else {}
  }
}
