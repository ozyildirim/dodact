import 'dart:io';

import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/ui/common_widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

class SignUpDetail extends StatefulWidget {
  @override
  _SignUpDetailState createState() => _SignUpDetailState();
}

class _SignUpDetailState extends BaseState<SignUpDetail> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _nameFocus = FocusNode();
  FocusNode _usernameFocus = FocusNode();
  FocusNode _dropdownFocus = FocusNode();
  bool validation = false;

  CityListItem selectedCity;
  List<CityListItem> _dropdownItems = [];
  int _currentStep = 0;

  PickedFile profilePicture;
  String errorMessage;
  bool isUploaded = false;
  bool inProgress = false;

  void initState() {
    super.initState();

    _dropdownItems = _buildDropdownItems(cities);
    _dropdownMenuItems = buildDropdownMenuItems(_dropdownItems);
  }

  void forward() {
    _currentStep < 1
        ? setState(() {
            _currentStep++;
          })
        : null;
  }

  void back() {
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
                Container(
                  color: Colors.white70,
                  child: Text(
                    "Adın Soyadın",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  "(Opsiyonel)",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            SizedBox(height: 4),
            TextFieldContainer(
              width: size.width * 0.8,
              child: FormBuilderTextField(
                textInputAction: TextInputAction.done,
                //TODO: Burada hata var, düzenle
                name: "name",
                autofocus: false,
                decoration: InputDecoration(border: InputBorder.none),
                focusNode: _nameFocus,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(context),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              color: Colors.white70,
              child: Text(
                "Lokasyon",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 4),
            TextFieldContainer(
              width: size.width * 0.8,
              child: FormBuilderDropdown(
                decoration: InputDecoration(border: InputBorder.none),
                name: "location",
                items: _dropdownMenuItems,
                onChanged: (city) {
                  selectedCity = city;
                },
              ),
            ),
            SizedBox(
              height: 8,
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
            ),
            Container(
              color: Colors.white70,
              child: Text(
                "Kullanıcı Adın",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 4),
            TextFieldContainer(
              width: size.width * 0.8,
              child: FormBuilderTextField(
                textInputAction: TextInputAction.done,
                name: "username",
                autofocus: false,
                decoration: InputDecoration(border: InputBorder.none),
                focusNode: _usernameFocus,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    context,
                    errorText: "Bu alan boş bırakılamaz.",
                  ),
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: FormBuilder(
          key: _formKey,
          child: Stepper(
            controlsBuilder: (BuildContext context,
                {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
              return Row(
                children: <Widget>[
                  _currentStep != steps.length - 1
                      ?
                      // TextButton(
                      //     onPressed: forward,
                      //     child: const Text('İleri'),
                      //   )
                      GFButton(
                          onPressed: forward,
                          child: const Text('İleri'),
                          color: Theme.of(context).primaryColor,
                        )
                      : GFButton(
                          color: Theme.of(context).primaryColor,
                          child: Text('Tamamla'),
                          onPressed: () async {
                            await submitForm();
                          },
                        ),
                  TextButton(
                    onPressed: back,
                    child: const Text('Geri'),
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
    );
  }

  Future<dynamic> _showPickerOptions() {
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
                    _takePhotoFromGallery(context);
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
  }

  void submitForm() async {
    if (_formKey.currentState.saveAndValidate()) {
      var formNameSurname =
          _formKey.currentState.value['name'].toString().trim();
      var formUsername =
          _formKey.currentState.value['username'].toString().trim();
      print("nameSurname:" + formNameSurname);
      print("username:" + formUsername);

      try {
        await updateDetails(
          username: formUsername,
          name: formNameSurname,
        );
        NavigationService.instance.navigate(k_ROUTE_INTERESTS_CHOICE);
      } catch (e) {
        showErrorSnackBar("Bilgiler güncellenirken bir hata oluştu.");
      }
    } else {
      showErrorSnackBar("Formu doldururken bir hata oldu");
    }
  }

  void showErrorSnackBar(String errorMessage) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 2),
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

  Future<void> updateDetails({String username, String name}) async {
    try {
      var url = await _updateProfilePhoto(context);

      var result = await authProvider.updateCurrentUser({
        'username': username,
        'nameSurname': name,
        'location': selectedCity.name,
        'hiddenLocation': false,
        'hiddenNameSurname': false,
        'hiddenMail': false,
        'newUser': false,
      });
      authProvider.currentUser.username = username;
      authProvider.currentUser.nameSurname = name;
      authProvider.currentUser.location = selectedCity.name;
    } catch (e) {
      showErrorSnackBar("Bilgiler güncellenirken bir hata oluştu.");
    }
  }

  List<DropdownMenuItem<CityListItem>> buildDropdownMenuItems(
      List<CityListItem> listItems) {
    List<DropdownMenuItem<CityListItem>> items = [];
    for (CityListItem cityListItem in listItems) {
      items.add(DropdownMenuItem(
        child: Text(cityListItem.name),
        value: cityListItem,
      ));
    }
    return items;
  }

  List<CityListItem> _buildDropdownItems(List<String> cities) {
    List<CityListItem> _items = [];
    for (int i = 0; i < cities.length; i++) {
      _items.add(new CityListItem(i, cities[i]));
    }
    return _items;
  }

  List<DropdownMenuItem<CityListItem>> _dropdownMenuItems;

  _signOut() async {
    await authProvider.signOut();
  }

  void _takePhotoFromGallery(BuildContext context) async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      profilePicture = newImage;
      NavigationService.instance.pop();
    });
  }

  void _takePhotoFromCamera(BuildContext context) async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      profilePicture = newImage;
      NavigationService.instance.pop();
    });
  }

  Future<String> _updateProfilePhoto(BuildContext context) async {
    if (profilePicture != null) {
      CommonMethods().showLoaderDialog(context, "Fotoğraf yükleniyor");
      await authProvider
          .updateCurrentUserProfilePicture(File(profilePicture.path))
          .then((url) {
        NavigationService.instance.pop();
        authProvider.currentUser.profilePictureURL = url;
        return url;
      }).catchError((error) {
        //TODO: TRY CATCH BLOĞU EKLE - DÜZENLE
        CommonMethods()
            .showErrorDialog(context, "Fotoğraf yüklenirken hata oluştu.");
      });
      debugPrint("Picture uploaded.");
    } else {
      await _uploadDefaultPicture();
      navigateInterestSelectionPage();
    }
  }

  void _uploadDefaultPicture() async {
    try {
      await authProvider.updateCurrentUser({
        'profilePictureURL':
            'https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png'
      });
      authProvider.currentUser.profilePictureURL =
          "https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png";
      debugPrint("userPicture default olarak ayarlandı.");
    } catch (e) {
      showErrorSnackBar("Teknik bir problem oluştu.");
    }
  }

  void navigateInterestSelectionPage() async {
    NavigationService.instance.navigateReplacement(k_ROUTE_INTERESTS_CHOICE);
  }
}

class CityListItem {
  int value;
  String name;
  CityListItem(this.value, this.name);
}
