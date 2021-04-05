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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends BaseState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _secondPassword;
  AuthProvider _authProvider;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backwardsCompatibility: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: dynamicHeight(1),
          color: oxfordBlue,
          child: Form(
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
                // Text(
                //   "Aramıza Katıl!",
                //   textAlign: TextAlign.start,
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontFamily: kFontFamily,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 30),
                // ),
                SizedBox(height: dynamicHeight(0.03)),
                RoundedInputField(
                  keyboardType: TextInputType.emailAddress,
                  hintText: "E-posta adresi",
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                RoundedPasswordField(
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                RoundedPasswordField(
                  onChanged: (value) {
                    _secondPassword = value;
                  },
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
    UserObject _user = await _authProvider.signInWithGoogle();
  }

  void _signInWithFacebook() async {
    UserObject _user = await _authProvider.signInWithFacebook();
  }

  void _signUp() async {
    _formKey.currentState.save();
    try {
      UserObject _registeredUser = await _authProvider
          .createAccountWithEmailAndPassword(_email, _password);
      Future.delayed(Duration(milliseconds: 300), () {
        NavigationService.instance.popUntil('/landing');
      });
    } catch (e) {
      print("Hata: " + e.toString());
    }
  }

  void navigateToLoginPage(BuildContext context) {
    NavigationService.instance.navigate('/login');
  }
}
