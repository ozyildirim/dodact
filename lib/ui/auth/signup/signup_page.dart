import 'dart:io';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/auth/signup/components/social_icon.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/screens/agreements.dart';
import 'package:dodact_v1/ui/common/widgets/rounded_button.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends BaseState<SignUpPage> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _checkboxFocus = FocusNode();

  bool obsecure = true;

  @override
  void initState() {
    authProvider = getProvider<AuthProvider>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _checkboxFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
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
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/loginBG.jpg'),
                  fit: BoxFit.cover)),
          height: dynamicHeight(1),
          width: dynamicWidth(1),
          child: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: dynamicHeight(0.08),
                  ),
                  Hero(
                    tag: "logo",
                    child: Image(
                      height: dynamicHeight(0.20),
                      width: dynamicHeight(0.20),
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  SizedBox(height: dynamicHeight(0.02)),
                  TextFieldContainer(
                    child: FormBuilderTextField(
                      keyboardType: TextInputType.emailAddress,
                      name: "email",
                      cursorColor: kPrimaryColor,
                      autofocus: false,
                      autovalidateMode: _autoValidate,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.mail,
                          color: kPrimaryColor,
                        ),
                        errorStyle: TextStyle(fontSize: 14),
                        hintText: "E-posta adresi",
                        hintStyle: TextStyle(fontFamily: kFontFamily),
                        border: InputBorder.none,
                      ),
                      focusNode: _emailFocus,
                      textInputAction: TextInputAction.next,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "Bu alan boş bırakılamaz."),
                        FormBuilderValidators.email(context,
                            errorText:
                                "Lütfen geçerli bir e-posta adresi girin."),
                      ]),
                    ),
                  ),
                  TextFieldContainer(
                    child: FormBuilderTextField(
                      keyboardType: TextInputType.visiblePassword,
                      name: "password",
                      obscureText: obsecure,
                      cursorColor: kPrimaryColor,
                      autovalidateMode: _autoValidate,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obsecure = !obsecure;
                            });
                          },
                          icon: Icon(
                            obsecure == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        hintText: "Şifre",
                        hintStyle: TextStyle(fontFamily: kFontFamily),
                        errorStyle: TextStyle(fontSize: 14),
                        icon: Icon(
                          Icons.lock,
                          color: kPrimaryColor,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context,
                            errorText: "Bu alan boş bırakılamaz."),
                        FormBuilderValidators.minLength(context, 6,
                            errorText: "Şifren en az 6 karakter olmalı.")
                      ]),
                    ),
                  ),
                  Container(
                    width: dynamicWidth(1) * 0.8,
                    child: FormBuilderCheckbox(
                      autovalidateMode: _autoValidate,
                      checkColor: Colors.white,
                      activeColor: kNavbarColor,
                      name: "privacyCheckbox",
                      initialValue: false,
                      focusNode: _checkboxFocus,
                      title: ExcludeSemantics(
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return TermsOfUsagePage();
                                    }));
                                  },
                                text: "Kullanım koşullarını",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: " ve ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PrivacyPolicyPage();
                                    }));
                                  },
                                text: "gizlilik sözleşmesini",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: " okudum, kabul ediyorum.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        errorStyle:
                            TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      validator: FormBuilderValidators.equal(context, true,
                          errorText: "Sözleşmeyi kabul etmelisin."),
                    ),
                  ),

                  RoundedButton(
                    textSize: 15,
                    text: "Kayıt Ol",
                    textColor: Colors.white,
                    press: () {
                      signUp();
                    },
                  ),
                  // OrDivider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIcon(
                        iconSrc: "assets/images/google_logo.png",
                        press: () {
                          googleSignIn();
                        },
                        backgroundColor: Colors.black,
                      ),
                      if (Platform.isIOS)
                        GestureDetector(
                          onTap: () => _signInWithApple(),
                          child: Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            // padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              FontAwesome.apple,
                              // size: 38,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      NavigationService.instance.navigate(k_ROUTE_LOGIN);
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Zaten hesabın var mı?  ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: "Giriş Yap",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CustomButton(
                  //       icon: Icon(
                  //         Icons.info,
                  //         color: Colors.white,
                  //       ),
                  //       titleText: Text(
                  //         "Dodact Nedir?",
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //       onPressed: () {
                  //         NavigationService.instance
                  //             .navigate(k_ROUTE_ABOUT_DODACT);
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void googleSignIn() async {
    CommonMethods().showLoaderDialog(context, "Google ile Giriş Yapılıyor");
    var status = await authProvider.signInWithGoogle(context);

    if (status != AuthResultStatus.successful) {
      NavigationService.instance.pop();
      if (status != AuthResultStatus.abortedByUser) {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        showSnackBar(errorMsg);
      }
    } else {
      NavigationService.instance.pop();
      NavigationService.instance.navigateToReset(k_ROUTE_LANDING);
    }
  }

  void _signInWithApple() async {
    var status = await authProvider.signInWithApple(context);

    if (status != AuthResultStatus.successful) {
      NavigationService.instance.pop();
      if (status != AuthResultStatus.abortedByUser) {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        showSnackbar(errorMsg);
      }
    } else {
      NavigationService.instance.pop();
      NavigationService.instance.navigateToReset(k_ROUTE_LANDING);
    }
  }

  showSnackbar(String errorMsg) {
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

  void signUp() async {
    if (_formKey.currentState.saveAndValidate()) {
      CommonMethods().showLoaderDialog(context, "Hesap Oluşturuluyor");
      var registrationResult =
          await authProvider.createAccountWithEmailAndPassword(
        _formKey.currentState.value['email'].toString().trim(),
        _formKey.currentState.value['password'].toString().trim(),
      );
      if (registrationResult != AuthResultStatus.successful) {
        NavigationService.instance.pop();
        final errorMsg =
            AuthExceptionHandler.generateExceptionMessage(registrationResult);
        showSnackBar(errorMsg);
      } else {
        NavigationService.instance.pop();
        showSnackBar(
            "Onay linki e-posta hesabına gönderildi. Spam klasörünü de kontrol etmeyi unutma.",
            duration: 4);
        _formKey.currentState.reset();
      }
    } else {
      setState(() {
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  void showSnackBar(String message, {int duration = 2}) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: new Duration(seconds: duration),
        content: Flexible(
          child: new Text(
            message,
            // overflow: TextOverflow.fade,
            softWrap: true,
            // maxLines: 1,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void navigateLogin(BuildContext context) {
    NavigationService.instance.navigate(k_ROUTE_LOGIN);
  }
}
