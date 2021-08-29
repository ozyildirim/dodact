import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/auth/signup/components/or_dividers.dart';
import 'package:dodact_v1/ui/auth/signup/components/social_icon.dart';
import 'package:dodact_v1/ui/common/widgets/custom_button.dart';
import 'package:dodact_v1/ui/common/widgets/rounded_button.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

enum Mode { Login, Signup }

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends BaseState<LogInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _autoValidate = false;

  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  bool showCircular = false;

  // void _signInWithFacebook() async {
  //   UserObject _user = await authProvider.signInWithFacebook();
  // }

  void _signInWithGoogle() async {
    var status = await authProvider.signInWithGoogle();
    showLoadingProgressContainer();
    if (status != AuthResultStatus.successful) {
      NavigationService.instance.pop();
      if (status != AuthResultStatus.abortedByUser) {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
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
          ),
        );
      }
    } else {
      NavigationService.instance.pop();
      NavigationService.instance.popUntil(k_ROUTE_LANDING);
    }
  }

  @override
  void initState() {
    authProvider = getProvider<AuthProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backwardsCompatibility: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: dynamicHeight(1),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kAuthBackgroundImage), fit: BoxFit.cover),
          ),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: "logo",
                  child: Image(
                    height: 180,
                    width: 180,
                    image: AssetImage(kDodactLogo),
                  ),
                ),
                SizedBox(
                  height: dynamicHeight(0.03),
                ),
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
                    onEditingComplete: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                      });
                    },
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
                    onEditingComplete: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Lütfen parolanızı giriniz.")
                    ]),
                  ),
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
                        Icons.lock,
                        color: Colors.white,
                      ),
                      titleText: Text(
                        "Şifremi Unuttum",
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
                      press: () {},
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

  void _formSubmit() async {
    if (_formKey.currentState.saveAndValidate()) {
      showLoadingProgressContainer();
      var status = await authProvider.signInWithEmail(
          _formKey.currentState.value['email'].toString().trim(),
          _formKey.currentState.value['password'].toString().trim());

      if (status != AuthResultStatus.successful) {
        NavigationService.instance.pop();
        final errorMessage =
            AuthExceptionHandler.generateExceptionMessage(status);
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
        debugPrint(errorMessage);
      } else {
        NavigationService.instance.pop();
        NavigationService.instance.popUntil(k_ROUTE_LANDING);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _navigateToForgotPassword(BuildContext context) {
    NavigationService.instance.navigate(k_ROUTE_FORGOT_PASSWORD);
  }

  showLoadingProgressContainer() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.loading,
        text: "Giriş Yapılıyor",
        barrierDismissible: false);
  }
}
