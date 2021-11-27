import 'dart:io';
import 'dart:ui';

import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/ui/common/screens/agreements.dart';
import 'package:dodact_v1/ui/common/validators/validators.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_cropper/image_cropper.dart';
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

  PickedFile profilePicture;
  String socialAccountProfilePictureUrl;
  String errorMessage;
  bool isUploaded = false;
  bool isLoading = false;
  bool isAvailableUsername;

  double fieldLabelSize = 20.0;

  void initState() {
    super.initState();
    if ((userProvider.currentUser.nameSurname != null) &
        (userProvider.currentUser.nameSurname != '')) {
      nameController.text = userProvider.currentUser.nameSurname;
    }

    if (userProvider.currentUser.profilePictureURL != null) {
      socialAccountProfilePictureUrl =
          userProvider.currentUser.profilePictureURL;
    } else {
      socialAccountProfilePictureUrl = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: isLoading
          // ignore: missing_required_param
          ? FloatingActionButton(
              child: CircularProgressIndicator(color: Colors.white))
          : FloatingActionButton(
              onPressed: submitForm,
              child: Icon(Icons.cloud_upload_rounded),
            ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(Colors.white)),
              child: Text(
                "Bilgilendirme",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: showInformationDialog),
          TextButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(Colors.white)),
              child: Text(
                "Çıkış Yap",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: _signOut)
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: buildForm(),
        ),
      ),
    );
  }

  buildForm() {
    var size = MediaQuery.of(context).size;
    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircleAvatar(
                  maxRadius: 90,
                  minRadius: 70,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    minRadius: 60,
                    maxRadius: 80,
                    backgroundImage: profilePicture == null
                        ? NetworkImage(
                            socialAccountProfilePictureUrl ??
                                "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png",
                          )
                        : FileImage(
                            File(profilePicture.path),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  child: Text(
                    "Profil fotoğrafı seç",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  onTap: showPickerOptions),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kullanıcı Adı",
                  style: TextStyle(
                      fontSize: fieldLabelSize, fontWeight: FontWeight.w500),
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
            SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ad Soyad",
                  style: TextStyle(
                      fontSize: fieldLabelSize, fontWeight: FontWeight.w500),
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
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lokasyon",
                  style: TextStyle(
                      fontSize: fieldLabelSize, fontWeight: FontWeight.w500),
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
                        errorText: "Bu alan boş bırakılamaz."),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showInformationDialog() {
    double textSize = 16.0;

    var text = RichText(
      text: TextSpan(
        children: [
          TextSpan(
              style: TextStyle(color: Colors.black, fontSize: textSize),
              text: 'Sevgili Dodact’li Merhaba!'),
          TextSpan(text: '\n\n'),
          TextSpan(
              style: TextStyle(color: Colors.black, fontSize: textSize),
              text:
                  "Kayıt bölümümüzde, ad-soyad vb bilgilerinizi rica ediyoruz.Amacımız platformumuzu güvenilir, samimi, üretken ve kalıcı değerler yaratabilen bir topluluk çerçevesinde oluşturabilmektir."),
          TextSpan(text: '\n\n'),
          TextSpan(
              style: TextStyle(color: Colors.black, fontSize: textSize),
              text: "Amacımızın sürdürülebilir olması için,"),
          TextSpan(
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: textSize),
              text: "\nyasal sorumluluklarını "),
          TextSpan(
              style: TextStyle(color: Colors.black, fontSize: textSize),
              text:
                  "da göz önünde bulundurarak platformumuzun bir parçası olmanı diliyoruz."),
          TextSpan(text: '\n\n'),
          TextSpan(
              style: TextStyle(color: Colors.black, fontSize: textSize),
              text:
                  "Aramıza katıldığın için çok mutluyuz. \nTekrar hoş geldin😊"),
        ],
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bilgilendirme"),
          content: InkWell(
            child: text,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TermsOfUsagePage();
              }));
              ;
            },
          ),
          actions: [
            FlatButton(
              child: Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

  Future cropImage(File file) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Özelleştir',
            toolbarColor: Color(0xff194d25),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Özelleştir',
        ));
    if (croppedFile != null) {
      return croppedFile;
    }
  }

  void submitForm() async {
    setState(() {
      isLoading = true;
    });
    await checkUsername(formKey.currentState.value["username"]);
    if (isAvailableUsername) {
      if (formKey.currentState.saveAndValidate()) {
        // CommonMethods().showLoaderDialog(context, "Kaydın gerçekleştiriliyor");

        var username = formKey.currentState.value['username'].toString().trim();
        var name = formKey.currentState.value['name'].toString().trim();
        var location = formKey.currentState.value['location'].toString().trim();

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
        setState(() {
          isLoading = false;
        });
        showErrorSnackBar("Formu doldururken bir hata oldu");
      }
    } else {
      setState(() {
        isLoading = false;
      });
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
            name: "username", errorText: "Bu kullanıcı adı kullanılıyor.");
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

    File croppedFile = await cropImage(File(newImage.path));
    setState(() {
      profilePicture = PickedFile(croppedFile.path);
      NavigationService.instance.pop();
    });
  }

  void takePhotoFromCamera(BuildContext context) async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);

    File croppedFile = await cropImage(File(newImage.path));
    setState(() {
      profilePicture = PickedFile(croppedFile.path);
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
    } else if (socialAccountProfilePictureUrl != null) {
    } else {
      uploadDefaultPicture();
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
