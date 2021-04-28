import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/auth/signup/components/or_dividers.dart';
import 'package:dodact_v1/ui/auth/signup/components/social_icon.dart';
import 'package:dodact_v1/ui/common_widgets/custom_dialog_box.dart';
import 'package:dodact_v1/ui/common_widgets/rounded_button.dart';
import 'package:dodact_v1/ui/common_widgets/rounded_input_field.dart';
import 'package:dodact_v1/ui/common_widgets/rounded_password_field.dart';
import 'package:dodact_v1/ui/common_widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends BaseState<SignUpPage> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autoValidate = false;

  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    authProvider = getProvider<AuthProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backwardsCompatibility: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/loginBG.jpg'),
                  fit: BoxFit.cover)),
          height: dynamicHeight(1),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: dynamicHeight(0.08),
                ),
                Hero(
                  tag: "logo",
                  child: Image(
                    height: 150,
                    width: 150,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                SizedBox(height: dynamicHeight(0.03)),
                TextFieldContainer(
                  child: FormBuilderTextField(
                    name: "email",
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.mail,
                        color: kPrimaryColor,
                      ),
                      hintText: "E-posta adresi",
                      hintStyle: TextStyle(fontFamily: kFontFamily),
                      border: InputBorder.none,
                    ),
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Lütfen e-posta adresi giriniz."),
                      FormBuilderValidators.email(context,
                          errorText:
                              "Lütfen geçerli bir e-posta adresi giriniz."),
                    ]),
                  ),
                ),
                TextFieldContainer(
                  child: FormBuilderTextField(
                    keyboardType: TextInputType.visiblePassword,
                    name: "password",
                    obscureText: true,
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
                TextFieldContainer(
                  child: FormBuilderTextField(
                    keyboardType: TextInputType.visiblePassword,
                    name: "password",
                    obscureText: true,
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
                RoundedButton(
                  textSize: 15,
                  text: "Kayıt Ol",
                  textColor: Colors.white,
                  press: () {
                    _signUp();
                  },
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocialIcon(
                      iconSrc: "assets/images/facebook_circular.png",
                      press: () {
                        _signInWithFacebook();
                      },
                    ),
                    SocialIcon(
                      iconSrc: "assets/images/google_logo.png",
                      press: () {
                        _signInWithGoogle();
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hesabın var mı?",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        navigateToLoginPage(context);
                      },
                      child: Text(
                        " Giriş Yap",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    var status = await authProvider.signInWithGoogle();
    if (status != AuthResultStatus.successful) {
      if (status != AuthResultStatus.abortedByUser) {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: new Duration(seconds: 2),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // new CircularProgressIndicator(),
              Expanded(
                child: new Text(
                  errorMsg,
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

  void _signInWithFacebook() async {
    UserObject _user = await authProvider.signInWithFacebook();
  }

  void _signUp() async {
    if (_formKey.currentState.saveAndValidate()) {
      var registrationResult =
          await authProvider.createAccountWithEmailAndPassword(
        _formKey.currentState.value['email'].toString().trim(),
        _formKey.currentState.value['password'].toString().trim(),
      );
      if (registrationResult != AuthResultStatus.successful) {
        final errorMsg =
            AuthExceptionHandler.generateExceptionMessage(registrationResult);
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: new Duration(seconds: 2),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // new CircularProgressIndicator(),
              Expanded(
                child: new Text(
                  errorMsg,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ));
      } else {
        NavigationService.instance.popUntil('/landing');
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void navigateToLoginPage(BuildContext context) {
    NavigationService.instance.navigate('/login');
  }
}
