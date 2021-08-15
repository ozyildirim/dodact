import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                title: Text("Parola Değiştirme"),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.mail),
                ),
                title: Text("E-posta Adresi Değiştirme"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeEmailPage(),
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

class _ChangePasswordPageState extends BaseState<ChangePasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  TextEditingController passwordController = new TextEditingController();
  TextEditingController secondPasswordController = new TextEditingController();

  FocusNode _passwordFocus = FocusNode();
  FocusNode _secondPasswordFocus = FocusNode();

  bool isChanged = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      floatingActionButton: isChanged
          ? FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () async {
                await _submitForm();
              },
            )
          : null,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Parola Değiştir"),
      ),
      body: Container(
        width: dynamicWidth(1),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldContainer(
                  width: mediaQuery.size.width * 0.8,
                  child: FormBuilderTextField(
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    focusNode: _passwordFocus,
                    controller: passwordController,
                    name: "password",
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      hintText: "Yeni parola",
                      border: InputBorder.none,
                      icon: Icon(Icons.lock),
                    ),
                    onEditingComplete: () {
                      setState(() {
                        isChanged = true;
                      });
                    },
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_secondPasswordFocus);
                    },
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(context,
                            errorText: "Yeni parolanızı giriniz"),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFieldContainer(
                  width: mediaQuery.size.width * 0.8,
                  child: FormBuilderTextField(
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    focusNode: _secondPasswordFocus,
                    controller: secondPasswordController,
                    name: "secondPassword",
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      hintText: "Tekrar yeni parola",
                      border: InputBorder.none,
                      icon: Icon(Icons.lock),
                    ),
                    onEditingComplete: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        isChanged = true;
                      });
                    },
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(context,
                            errorText: "Yeni parolanızı giriniz"),
                        FormBuilderValidators.equal(
                            context, passwordController.text,
                            errorText: "Parolalar eşleşmiyor"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState.saveAndValidate()) {
      try {
        await changePassword();
      } catch (e) {}
    }
  }

  Future changePassword() async {
    try {
      //TODO:
      //Her halükarda şifreniz başarıyla değiştirildi diyor.

      var password = _formKey.currentState.value['password'];
      CommonMethods().showLoaderDialog(context, "İşlemin gerçekleştiriliyor");
      await authProvider.updatePassword(password);
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 2),
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new CircularProgressIndicator(),
            Expanded(
              child: new Text(
                "Şifreniz başarıyla değiştirildi.",
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ));
      CommonMethods().hideDialog();
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthExceptionHandler.generateExceptionMessage(e);
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
  }
}

class ChangeEmailPage extends StatefulWidget {
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends BaseState<ChangeEmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  TextEditingController emailController = new TextEditingController();

  FocusNode emailFocusNode = new FocusNode();

  bool isChanged = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: isChanged
          ? FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () async {
                await _submitForm();
              },
            )
          : null,
      appBar: AppBar(
        title: Text("E-posta Adres Değiştir"),
      ),
      body: Container(
        width: dynamicWidth(1),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldContainer(
                  width: mediaQuery.size.width * 0.8,
                  child: FormBuilderTextField(
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    textInputAction: TextInputAction.done,
                    focusNode: emailFocusNode,
                    controller: emailController,
                    name: "email",
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      hintText: "Yeni e-posta adresi",
                      border: InputBorder.none,
                      icon: Icon(Icons.mail),
                    ),
                    onEditingComplete: () {
                      setState(() {
                        isChanged = true;
                      });
                    },
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(context,
                            errorText: "Yeni e-posta adresini gir."),
                        FormBuilderValidators.email(context)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _submitForm() async {
    if (_formKey.currentState.saveAndValidate()) {
      await updateEmail();
    }
  }

  Future updateEmail() async {
    try {
      var email = _formKey.currentState.value['email'];
      CommonMethods().showLoaderDialog(context, "İşlemin gerçekleştiriliyor");
      await authProvider.updateEmail(email);
      await authProvider.updateCurrentUser(
        {'email': email},
      );
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 2),
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new CircularProgressIndicator(),
            Expanded(
              child: new Text(
                "E-posta adresin başarıyla değiştirildi.",
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ));
      _formKey.currentState.reset();
      CommonMethods().hideDialog();
    } catch (e) {
      print(e);
      final errorMessage = AuthExceptionHandler.generateExceptionMessage(e);
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
  }
}
