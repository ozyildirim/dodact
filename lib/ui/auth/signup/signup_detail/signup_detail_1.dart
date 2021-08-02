import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUpDetail1 extends StatefulWidget {
  @override
  _SignUpDetail1State createState() => _SignUpDetail1State();
}

class _SignUpDetail1State extends BaseState<SignUpDetail1> {
  AuthProvider authProvider;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool validation = false;

  FocusNode _nameFocus = FocusNode();
  FocusNode _usernameFocus = FocusNode();
  FocusNode _dropdownFocus = FocusNode();

  CityListItem selectedCity;
  List<CityListItem> _dropdownItems = [];

  void initState() {
    super.initState();
    authProvider = getProvider<AuthProvider>();

    _dropdownItems = _buildDropdownItems(cities);
    _dropdownMenuItems = buildDropdownMenuItems(_dropdownItems);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        width: dynamicWidth(1),
        child: Column(
          children: [
            //page header title
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Biraz kendinden bahseder misin?",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 25),
                  ),
                )),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilder(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: const Offset(
                                  1.0,
                                  1.0,
                                ),
                                blurRadius: 5.0,
                                spreadRadius: 0.5,
                              ),
                            ],
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FormBuilderTextField(
                            textInputAction: TextInputAction.next,
                            focusNode: _usernameFocus,
                            name: "username",
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.people_alt_sharp,
                                color: kPrimaryColor,
                              ),
                              hintText: "Kullanıcı Adın",
                              hintStyle: TextStyle(fontFamily: kFontFamily),
                              border: InputBorder.none,
                            ),
                            validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: const Offset(
                                  1.0,
                                  1.0,
                                ),
                                blurRadius: 5.0,
                                spreadRadius: 0.5,
                              ),
                            ],
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FormBuilderTextField(
                            textInputAction: TextInputAction.next,
                            focusNode: _nameFocus,
                            name: "nameSurname",
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.people_alt_sharp,
                                color: kPrimaryColor,
                              ),
                              hintText: "Adın Soyadın",
                              hintStyle: TextStyle(fontFamily: kFontFamily),
                              border: InputBorder.none,
                            ),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: const Offset(
                                  1.0,
                                  1.0,
                                ),
                                blurRadius: 5.0,
                                spreadRadius: 0.5,
                              ),
                            ],
                            color: kPrimaryLightColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FormBuilderDropdown(
                            focusNode: _dropdownFocus,
                            name: "city",
                            hint: Text("Bir şehir belirtiniz."),
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            allowClear: true,
                            validator: FormBuilderValidators.required(context,
                                errorText: "Lütfen bir şehir seçiniz."),
                            items: _dropdownMenuItems,
                            onChanged: (value) {
                              selectedCity = value;
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    _formSubmit();
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
              ),
            )
          ],
        ),
      ),
    );
  }

  List<CityListItem> _buildDropdownItems(List<String> cities) {
    List<CityListItem> _items = [];
    for (int i = 0; i < cities.length; i++) {
      _items.add(new CityListItem(i, cities[i]));
    }
    return _items;
  }

  List<DropdownMenuItem<CityListItem>> _dropdownMenuItems;

  void _formSubmit() async {
    _formKey.currentState.saveAndValidate();
    var formUsername =
        _formKey.currentState.value['username'].toString().trim();
    var formNameSurname =
        _formKey.currentState.value['nameSurname'].toString().trim();

    // var usernameControlResult = await _usernameControl(username);

    try {
      await updateDetails(username: formUsername, nameSurname: formNameSurname);
      print(
          "AFTER SIGNUP DETAIL 1, USER INFO\n: ${authProvider.currentUser.toString()}");
      NavigationService.instance.navigate(k_ROUTE_REGISTER_DETAIL_2);
    } catch (e) {
      showErrorSnackBar("Bilgiler güncellenirken bir hata oluştu.");
    }

    print(_formKey.currentState.value['nameSurname'].toString());
    print(_formKey.currentState.value['username'].toString());
    print(selectedCity.name);
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

  Future<bool> updateDetails({String username, String nameSurname}) async {
    // var result = await usersRef.doc(authProvider.currentUser.uid).update({
    //   'username': username,
    //   'nameSurname': nameSurname,
    //   'location': selectedCity.name,
    // }).then((value) {
    //   return true;
    // }).catchError((error) {
    //   return false;
    // });

    var result = await authProvider.updateCurrentUser({
      'username': username,
      'nameSurname': nameSurname,
      'location': selectedCity.name,
      'hiddenLocation': false,
      'hiddenNameSurname': false,
      'hiddenMail': false,
    }).then((value) {
      authProvider.currentUser.username = username;
      authProvider.currentUser.nameSurname = nameSurname;
      authProvider.currentUser.location = selectedCity.name;

      return true;
    }).catchError((error) {
      return false;
    });
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

  _signOut() async {
    await authProvider.signOut();
  }

  Future<bool> _usernameControl(String username) async {
    var result = await usersRef.where('username', isEqualTo: username).get();
    if (result != null) {
      return true;
    } else {
      return false;
    }
  }

  bool _nameControl(String nameSurname) {
    RegExp regex = RegExp("^[a-zA-Z]+\$");
    if (!regex.hasMatch(nameSurname)) //isim hatalıysa
      return false;
    else //isim doğruysa
      return true;
  }
}

class CityListItem {
  int value;
  String name;
  CityListItem(this.value, this.name);
}
