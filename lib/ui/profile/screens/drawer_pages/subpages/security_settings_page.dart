import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/ui/common_widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SecuritySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Güvenlik Ayarları"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.vpn_key),
                ),
                title: Text("Şifre Değiştirme"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  FocusNode _passwordFocus = FocusNode();

  bool isChanged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isChanged
          ? FloatingActionButton(
              child: Icon(Icons.save),
            )
          : null,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Şifre Değiştir"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            TextFieldContainer(
              child: FormBuilderTextField(
                keyboardType: TextInputType.visiblePassword,
                name: "password",
                obscureText: true,
                focusNode: _passwordFocus,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: "Parola",
                  hintStyle: TextStyle(fontFamily: kFontFamily),
                  icon: Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  border: InputBorder.none,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context,
                      errorText: "Lütfen parolanızı giriniz.")
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
