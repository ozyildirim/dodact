import 'dart:io';

import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/ui/common/validators/validators.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class SignUpDetail extends StatefulWidget {
  @override
  _SignUpDetailState createState() => _SignUpDetailState();
}

class _SignUpDetailState extends BaseState<SignUpDetail> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _nameFocus = FocusNode();
  FocusNode _usernameFocus = FocusNode();
  FocusNode dropdownFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  String name;
  String location;

  int _currentStep = 0;

  PickedFile profilePicture;
  String errorMessage;
  bool isUploaded = false;
  bool inProgress = false;
  bool isAvailableUsername;

  void initState() {
    super.initState();
  }

  void forward() {
    if (formKey.currentState.saveAndValidate()) {
      _currentStep < 1
          ? setState(() {
              location = formKey.currentState.value['location'];
              name = formKey.currentState.value['name'];
              _currentStep++;
            })
          : null;
    } else {}
  }

  void back() {
    formKey.currentState.save();

    _currentStep != 0
        ? setState(() {
            _currentStep--;
          })
        : null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Step> steps = [
      Step(
        title: Text(
          "Kişisel",
          style: TextStyle(fontSize: 18),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                  "Adın Soyadın",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: 6,
                ),
                // Text(
                //   "(Opsiyonel)",
                //   style: TextStyle(fontSize: 14),
                // )
              ],
            ),
            SizedBox(height: 4),
            TextFieldContainer(
              width: size.width * 0.9,
              child: FormBuilderTextField(
                textInputAction: TextInputAction.done,
                name: "name",
                autofocus: false,
                autovalidateMode: autoValidateMode,
                controller: nameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                focusNode: _nameFocus,
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
            SizedBox(
              height: 8,
            ),
            Text(
              "Lokasyon",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 4),
            TextFieldContainer(
              width: size.width * 0.9,
              child: FormBuilderDropdown(
                focusNode: dropdownFocus,
                hint: Text("Şehir Seçin"),
                decoration: InputDecoration(border: InputBorder.none),
                name: "location",
                items: cities
                    .map((city) => DropdownMenuItem(
                          value: city,
                          child: Text('$city'),
                        ))
                    .toList(),
                validator: FormBuilderValidators.required(context,
                    errorText: "Lütfen bulunduğun şehri belirt"),
              ),
            ),
          ],
        ),
        isActive: _currentStep == 0,
        state: _currentStep > 0 ? StepState.complete : StepState.disabled,
      ),
      Step(
        title: Text(
          "Profil",
          style: TextStyle(fontSize: 18),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: Center(
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                        width: 200,
                        height: 200,
                        child: profilePicture == null
                            ? Image.network(
                                "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png",
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(profilePicture.path),
                                fit: BoxFit.cover,
                              )),
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
            ),
            Text(
              "Kullanıcı Adın",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 4),
            TextFieldContainer(
              width: size.width * 0.9,
              child: FormBuilderTextField(
                name: "username",
                textInputAction: TextInputAction.done,
                autofocus: false,
                decoration: InputDecoration(border: InputBorder.none),
                focusNode: _usernameFocus,
                onChanged: (value) {
                  setState(() {
                    checkUsername(value);
                  });
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
          ],
        ),
        isActive: _currentStep == 1,
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.black,
            onPressed: () {
              _signOut();
            },
          )
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: FormBuilder(
            key: formKey,
            child: Stepper(
              controlsBuilder: (BuildContext context,
                  {void Function() onStepCancel,
                  void Function() onStepContinue}) {
                return Row(
                  children: <Widget>[
                    _currentStep != steps.length - 1
                        ? GFButton(
                            size: GFSize.LARGE,
                            shape: GFButtonShape.pills,
                            textStyle: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(fontSize: 18, color: Colors.white),
                            text: "İleri",
                            onPressed: forward,
                            child: const Text('İleri'),
                            color: kNavbarColor,
                          )
                        : GFButton(
                            size: GFSize.LARGE,
                            shape: GFButtonShape.pills,
                            textStyle: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(fontSize: 18, color: Colors.white),
                            color: kNavbarColor,
                            child: Text('Tamamla'),
                            onPressed: () async {
                              await submitForm();
                            },
                          ),
                    TextButton(
                      onPressed: back,
                      child: const Text('Geri',
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                  ],
                );
              },
              currentStep: _currentStep,
              type: StepperType.horizontal,
              steps: steps,
              onStepTapped: null,
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showPickerOptions() {
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
                    takePhotoFromGallery(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Kameradan Çek"),
                  onTap: () {
                    takePhotoFromCamera(context);
                  },
                )
              ],
            ),
          );
        });
  }

  void submitForm() async {
    await checkUsername(formKey.currentState.value["username"]);
    if (isAvailableUsername) {
      if (formKey.currentState.saveAndValidate()) {
        // CommonMethods().showLoaderDialog(context, "Kaydın gerçekleştiriliyor");

        var username = formKey.currentState.value['username'].toString().trim();

        Logger().e("name: $name, location: $location, username: $username");

        try {
          await updateDetails(
            username: username,
            name: name ?? "Dodact Kullanıcısı",
            location: location,
          );
          CommonMethods().hideDialog();
          navigateInterestSelectionPage();
        } catch (e) {
          showErrorSnackBar("Bilgiler güncellenirken bir hata oluştu.");
        }
      } else {
        showErrorSnackBar("Formu doldururken bir hata oldu");
      }
    }
  }

  void showErrorSnackBar(String errorMessage) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 1),
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // new CircularProgressIndicator(),
          Expanded(
            child: new Text(
              errorMessage,
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    ));
  }

  Future<void> updateDetails(
      {String username, String name, String location}) async {
    try {
      var url = await updateProfilePhoto(context);
      var searchKeywords = createSearchKeywords(username);

      var result = await userProvider.updateCurrentUser({
        'username': username,
        'nameSurname': name,
        'location': location,
        'hiddenLocation': false,
        'hiddenNameSurname': false,
        'hiddenMail': false,
        'newUser': false,
        'searchKeywords': searchKeywords,
      });
      userProvider.currentUser.username = username;
      userProvider.currentUser.nameSurname = name;
      userProvider.currentUser.location = location;
    } catch (e) {
      showErrorSnackBar("Bilgiler güncellenirken bir hata oluştu.");
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
      }
    } catch (e) {
      print(e);
    }
  }

  List<String> createSearchKeywords(String username) {
    List<String> searchKeywords = [];

    var splittedUsername = username.split(" ");
    splittedUsername.forEach((word) {
      searchKeywords.add(word.toLowerCase());
    });

    for (int i = 1; i < username.length; i++) {
      searchKeywords.add(username.substring(0, i).toLowerCase());
    }
    return searchKeywords;
  }

  _signOut() async {
    await authProvider.signOut();
  }

  void takePhotoFromGallery(BuildContext context) async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      profilePicture = newImage;
      NavigationService.instance.pop();
    });
  }

  void takePhotoFromCamera(BuildContext context) async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      profilePicture = newImage;
      NavigationService.instance.pop();
    });
  }

  Future<String> updateProfilePhoto(BuildContext context) async {
    if (profilePicture != null) {
      CommonMethods().showLoaderDialog(context, "Fotoğraf Yükleniyor");
      await userProvider
          .updateCurrentUserProfilePicture(File(profilePicture.path))
          .then((url) {
        NavigationService.instance.pop();
        userProvider.currentUser.profilePictureURL = url;
        return url;
      }).catchError((error) {
        //TODO: TRY CATCH BLOĞU EKLE - DÜZENLE
        CommonMethods()
            .showErrorDialog(context, "Fotoğraf Yüklenirken hata oluştu.");
      });
      debugPrint("Picture uploaded.");
    } else {
      uploadDefaultPicture();
      navigateInterestSelectionPage();
    }
  }

  void uploadDefaultPicture() async {
    try {
      await userProvider.updateCurrentUser({
        'profilePictureURL':
            'https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png'
      });
      userProvider.currentUser.profilePictureURL =
          "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png";
      debugPrint("userPicture default olarak ayarlandı.");
    } catch (e) {
      showErrorSnackBar("Teknik bir problem oluştu.");
    }
  }

  void navigateInterestSelectionPage() async {
    NavigationService.instance.navigate(k_ROUTE_INTEREST_REGISTRATION);
  }
}
