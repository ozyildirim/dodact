import 'dart:io';

import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/common/validators/validators.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class UserPersonalProfileSettingsPage extends StatefulWidget {
  @override
  _UserPersonalProfileSettingsPageState createState() =>
      _UserPersonalProfileSettingsPageState();
}

class _UserPersonalProfileSettingsPageState
    extends BaseState<UserPersonalProfileSettingsPage> {
  var logger = Logger();

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  TextEditingController emailController;
  TextEditingController locationController;

  PickedFile picture;
  String nameSurname;
  String location;
  String education;
  String profession;

  bool isChanged = false;
  bool isAvailableUsername;

  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  FocusNode nameSurnameFocus;
  FocusNode usernameFocus;
  FocusNode descriptionFocus;
  FocusNode educationFocus;
  FocusNode professionFocus;

  @override
  void initState() {
    super.initState();

    location = userProvider.currentUser.location;

    emailController =
        TextEditingController(text: userProvider.currentUser.email);

    nameSurnameFocus = FocusNode();
    usernameFocus = FocusNode();
    descriptionFocus = FocusNode();
    educationFocus = FocusNode();
    professionFocus = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
                  Icon(Icons.check),
                ],
              ),
            )
          : null,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Kişisel Bilgiler"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: dynamicHeight(1),
          width: dynamicWidth(1),
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "E-posta Adresi",
                          style: TextStyle(
                              fontSize: kSettingsTitleSize,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
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
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ad - Soyad",
                          style: TextStyle(
                              fontSize: kSettingsTitleSize,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        TextFieldContainer(
                          width: mediaQuery.size.width * 0.9,
                          child: FormBuilderTextField(
                            name: "nameSurname",
                            focusNode: nameSurnameFocus,
                            initialValue:
                                userProvider.currentUser.nameSurname ?? "",
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person),
                            ),
                            onChanged: (value) {
                              if (userProvider.currentUser.nameSurname !=
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
                              FormBuilderValidators.required(context,
                                  errorText: "Bu alan boş bırakılamaz"),
                              (value) {
                                return ProfanityChecker.profanityValidator(
                                    value);
                              }
                            ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kullanıcı Adı",
                          style: TextStyle(
                              fontSize: kSettingsTitleSize,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        TextFieldContainer(
                          width: mediaQuery.size.width * 0.9,
                          child: FormBuilderTextField(
                            name: "username",
                            focusNode: usernameFocus,
                            initialValue: userProvider.currentUser.username,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person),
                            ),
                            onChanged: (value) {
                              if (userProvider.currentUser.username != value) {
                                setState(() {
                                  isAvailableUsername = false;
                                  checkUsername(value);
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
                                return ProfanityChecker.profanityValidator(
                                    value);
                              },
                            ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lokasyon",
                          style: TextStyle(
                              fontSize: kSettingsTitleSize,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
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
                              FormBuilderValidators.required(context,
                                  errorText: "Bu alan boş bırakılamaz"),
                              (value) {
                                return ProfanityChecker.profanityValidator(
                                    value);
                              }
                            ]),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.location_city),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hakkımda",
                          style: TextStyle(
                              fontSize: kSettingsTitleSize,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        TextFieldContainer(
                          // padding: EdgeInsets.all(6),
                          width: mediaQuery.size.width * 0.9,
                          child: FormBuilderTextField(
                            name: "userDescription",
                            maxLines: null,
                            focusNode: descriptionFocus,
                            keyboardType: TextInputType.multiline,
                            initialValue:
                                userProvider.currentUser.userDescription,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person),
                            ),
                            onChanged: (value) {
                              if (userProvider.currentUser.userDescription !=
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
                                return ProfanityChecker.profanityValidator(
                                    value);
                              }
                            ]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Okul/Eğitim Kurumu",
                          style: TextStyle(
                              fontSize: kSettingsTitleSize,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        TextFieldContainer(
                          width: mediaQuery.size.width * 0.9,
                          child: FormBuilderTextField(
                            name: "education",
                            maxLines: 1,
                            focusNode: educationFocus,
                            initialValue: userProvider.currentUser.education,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.school),
                            ),
                            validator: FormBuilderValidators.compose([
                              (value) {
                                return ProfanityChecker.profanityValidator(
                                    value);
                              }
                            ]),
                            onChanged: (value) {
                              if (userProvider.currentUser.education != value) {
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
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Meslek",
                          style: TextStyle(
                              fontSize: kSettingsTitleSize,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        TextFieldContainer(
                          width: mediaQuery.size.width * 0.9,
                          child: FormBuilderTextField(
                            name: "profession",
                            maxLines: 1,
                            focusNode: professionFocus,
                            initialValue: userProvider.currentUser.profession,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.work),
                            ),
                            onChanged: (value) {
                              if (userProvider.currentUser.profession !=
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
                                return ProfanityChecker.profanityValidator(
                                    value.trim());
                              }
                            ]),
                          ),
                        ),
                      ],
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
            child: InkWell(
              onTap: () {
                CustomMethods.showImagePreviewDialog(context,
                    url: userProvider.currentUser.profilePictureURL);
              },
              child: Container(
                width: 200,
                height: 200,
                child: Image.network(
                  userProvider.currentUser.profilePictureURL,
                  fit: BoxFit.cover,
                ),
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
    CustomMethods().showLoaderDialog(context, "Fotoğrafın Güncelleniyor");
    await userProvider
        .updateCurrentUserProfilePicture(File(picture.path))
        .then((url) {
      NavigationService.instance.pop();
      setState(() {});
      showSnackbar("Fotoğrafın güncellendi");
      debugPrint("Picture uploaded.");
    }).catchError((error) {
      CustomMethods()
          .showErrorDialog(context, "Fotoğraf yüklenirken hata oluştu.");
    });
  }

  showSnackbar(String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 4,
    );
  }

  Future<void> updateUser() async {
    if (isAvailableUsername == true || isAvailableUsername == null) {
      if (formKey.currentState.saveAndValidate()) {
        try {
          CustomMethods()
              .showLoaderDialog(context, "Değişiklikler Kaydediliyor");
          await userProvider.updateCurrentUser({
            'location':
                formKey.currentState.value['location'].toString().trim(),
            'username':
                formKey.currentState.value['username'].toString().trim(),
            'nameSurname': formKey.currentState.value['nameSurname'].toString(),
            'userDescription':
                formKey.currentState.value['userDescription'].toString().trim(),
            'education':
                formKey.currentState.value['education'].toString().trim(),
            'profession':
                formKey.currentState.value['profession'].toString().trim(),
          });
          NavigationService.instance.pop();
          showSnackbar("Profil bilgilerin güncellendi.");
          setState(() {
            isChanged = false;
          });
        } catch (e) {
          showSnackbar("Değişiklikler kaydedilirken bir hata oluştu.");
        }
      } else {}
    }
  }

  Future<bool> checkUsername(String value) async {
    try {
      var result = await CustomValidators.isUsernameAvailable(value);
      if (result) {
        setState(() {
          isAvailableUsername = true;
        });
      } else {
        formKey.currentState.invalidateField(
            name: "username", errorText: "Bu kullanıcı adı kullanılıyor");
        setState(() {
          isAvailableUsername = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
