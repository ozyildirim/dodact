import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SignUpDetail extends StatefulWidget {
  @override
  _SignUpDetailState createState() => _SignUpDetailState();
}

class _SignUpDetailState extends BaseState<SignUpDetail> {
  List<String> details;

  String _username, _nameSurname, _city;
  bool validation = false;
  final formKey = GlobalKey<FormState>();

  List<CityListItem> _dropdownItems = [
    CityListItem(1, "Lütfen bir şehir belirt"),
    CityListItem(2, "Adana"),
    CityListItem(3, "Adıyaman"),
    CityListItem(4, "Afyon"),
    CityListItem(5, "Ağrı"),
  ];

  //TODO: Şehirler başka bir listede tutulup, oradan çekilecek
  //TODO: Formlar form builder ile yapılacak..
  List<DropdownMenuItem<CityListItem>> _dropdownMenuItems;
  CityListItem _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    _city = _selectedItem.name;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            children: [buildUpperPart(), buildFormPart(), buildButtonPart()],
          ),
        ),
      ),
    );
  }

  Expanded buildButtonPart() => Expanded(
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
      ));

  Expanded buildFormPart() {
    Size size = MediaQuery.of(context).size;
    return Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            autovalidate: validation,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                  child: TextFormField(
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
                    onChanged: (value) {
                      _username = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Bir kullanıcı adı giriniz.";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                  child: TextFormField(
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
                    onChanged: (value) {
                      _nameSurname = value;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CityListItem>(
                      value: _selectedItem,
                      items: _dropdownMenuItems,
                      onChanged: (value) {
                        setState(() {
                          _selectedItem = value;
                          _city = value.name;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _formSubmit() async {
    formKey.currentState.save();
    await updateDetails();
    NavigationService.instance.navigate('/signup_detail_2');
  }

  Future<void> updateDetails() async {
    debugPrint(_selectedItem.name);
    return usersRef
        .doc(authProvider.currentUser.uid)
        .update({
          'username': _username,
          'nameSurname': _nameSurname,
          'location': _city
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Expanded buildUpperPart() {
    return Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Biraz kendinden bahseder misin?",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 25),
          ),
        ));
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

  Future<String> _usernameControl(String username) async {
    var result = await usersRef.where('username', isEqualTo: username);
  }

  String _nameControl(String nameSurname) {
    RegExp regex = RegExp("^[a-zA-Z]+\$");
    if (!regex.hasMatch(nameSurname))
      return 'İsim numara içermemeli!';
    else
      return null;
  }
}

class CityListItem {
  int value;
  String name;

  CityListItem(this.value, this.name);
}
