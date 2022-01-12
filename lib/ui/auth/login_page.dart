import 'dart:io';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/auth/signup/components/social_icon.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/screens/agreements.dart';
import 'package:dodact_v1/ui/common/widgets/custom_button.dart';
import 'package:dodact_v1/ui/common/widgets/rounded_button.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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

  bool obsecure = true;

  bool showCircular = false;

  void _signInWithGoogle() async {
    CustomMethods().showLoaderDialog(context, "Google ile Giriş Yapılıyor");
    await authProvider.signInWithGoogle(context);
  }

  void _signInWithApple() async {
    // var status = await authProvider.signInWithApple(context);

    // if (status != AuthResultStatus.successful) {
    //   NavigationService.instance.pop();
    //   if (status != AuthResultStatus.abortedByUser) {
    //     final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
    //     showSnackbar(errorMsg);
    //   }
    // } else {
    //   NavigationService.instance.pop();
    //   NavigationService.instance.navigateToReset(k_ROUTE_LANDING);
    // }

    CustomMethods().showLoaderDialog(context, "Apple ile Giriş Yapılıyor");
    await authProvider.signInWithApple(context);
  }

  showAgreementDialog(String channel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Onay", textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ExcludeSemantics(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          "Farklı giriş yöntemleri ile hesap oluşturduğunuzda veya giriş yaptığınızda, ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return TermsOfUsagePage();
                          }));
                        },
                      text: "Kullanım Koşullarını",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: " ve ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
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
                      text: "Gizlilik Sözleşmesini",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: " okuduğunuzu ve kabul ettiğinizi onaylıyorsunuz.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
              child: Text("Kabul et"),
              onPressed: () {
                if (channel == "apple") {
                  Navigator.of(context).pop();
                  _signInWithApple();
                } else if (channel == "google") {
                  Navigator.of(context).pop();
                  _signInWithGoogle();
                }
              },
            ),
            FlatButton(
              child: Text("Vazgeç"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    )),
                SizedBox(
                  height: dynamicHeight(0.03),
                ),
                TextFieldContainer(
                  child: FormBuilderTextField(
                    name: "email",
                    cursorColor: kPrimaryColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail, color: kPrimaryColor),
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
                          errorText: "Bu alan boş bırakılamaz."),
                      FormBuilderValidators.email(context,
                          errorText: "Lütfen geçerli bir e-posta adresi girin.")
                    ]),
                  ),
                ),
                TextFieldContainer(
                  child: FormBuilderTextField(
                    keyboardType: TextInputType.visiblePassword,
                    name: "password",
                    obscureText: obsecure,
                    focusNode: _passwordFocus,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obsecure = !obsecure;
                            });
                          },
                          icon: Icon(obsecure == true
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintText: "Şifre",
                        hintStyle: TextStyle(fontFamily: kFontFamily),
                        icon: Icon(Icons.lock, color: kPrimaryColor),
                        border: InputBorder.none),
                    onEditingComplete: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                      });
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Bu alan boş bırakılamaz.")
                    ]),
                  ),
                ),
                RoundedButton(
                    textSize: 15,
                    text: "GİRİŞ YAP",
                    textColor: Colors.white,
                    press: () {
                      FocusScope.of(context).unfocus();
                      submitForm();
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      icon: Icon(Icons.lock, color: Colors.white),
                      titleText: Text("Şifremi Unuttum",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      onPressed: _navigateToForgotPassword,
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIcon(
                      press: () {
                        showAgreementDialog("google");
                      },
                      iconSrc: "assets/images/google_logo.png",
                      backgroundColor: Colors.black,
                    ),
                    if (Platform.isIOS)
                      GestureDetector(
                        onTap: () {
                          showAgreementDialog("apple");
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 10),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitForm() async {
    if (_formKey.currentState.saveAndValidate()) {
      var email = _formKey.currentState.value['email'].toString().trim();
      var password = _formKey.currentState.value['password'].toString().trim();

      CustomMethods().showLoaderDialog(context, "Giriş Yapılıyor");
      var status = await authProvider.signin(email, password);

      if (status != AuthResultStatus.successful) {
        Get.back();
        final errorMessage =
            AuthExceptionHandler.generateExceptionMessage(status);

        CustomMethods.showSnackbar(context, errorMessage);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _navigateToForgotPassword() {
    Get.toNamed(k_ROUTE_FORGOT_PASSWORD);
  }
}
