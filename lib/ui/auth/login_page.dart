import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/auth/forgot_password.dart';
import 'package:dodact_v1/ui/auth/signup/components/or_dividers.dart';
import 'package:dodact_v1/ui/auth/signup/components/social_icon.dart';
import 'package:dodact_v1/ui/common_widgets/custom_button.dart';
import 'package:dodact_v1/ui/common_widgets/rounded_button.dart';
import 'package:dodact_v1/ui/common_widgets/rounded_input_field.dart';
import 'package:dodact_v1/ui/common_widgets/rounded_password_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends BaseState<LogInPage> {
  AuthProvider _authProvider;

  String _email, _password;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backwardsCompatibility: false,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: dynamicHeight(1),
          decoration: BoxDecoration(color: oxfordBlue),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: "logo",
                  child: Image(
                    height: 200,
                    width: 200,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
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
                RoundedButton(
                  textSize: 15,
                  text: "Giriş Yap",
                  textColor: Colors.white,
                  press: () {
                    _formSubmit();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      icon: Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      titleText: Text(
                        "Dodact Nedir?",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                    CustomButton(
                      icon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      titleText: Text(
                        "Şifremi Unuttum?",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _navigateToForgotPassword(context);
                      },
                    )
                  ],
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIcon(
                      press: () => _signInWithFacebook(),
                      iconSrc: "assets/images/facebook_circular.png",
                    ),
                    SocialIcon(
                      press: () => _signInWithGoogle(),
                      iconSrc: "assets/images/google_logo.png",
                    ),
                  ],
                ),
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

  void _formSubmit() async {
    try {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 4),
        content: new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text(" Giriş yapılıyor.")
          ],
        ),
      ));
      _formKey.currentState.save();
      debugPrint("E posta: " + _email + " Password: " + _password);

      UserObject _user = await _authProvider.signInWithEmail(_email, _password);
      if (_user != null) {
        debugPrint(
            "User logged in with email: " + _email + " and ID: " + _user.uid);
        Future.delayed(Duration(milliseconds: 300), () {
          NavigationService.instance.popUntil('/landing');
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _signInWithFacebook() async {
    UserObject _user = await _authProvider.signInWithFacebook();
  }

  void _navigateToForgotPassword(BuildContext context) {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => ForgotPasswordPage()));
  }
}
