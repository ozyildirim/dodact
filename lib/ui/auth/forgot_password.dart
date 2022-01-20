import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/common/widgets/rounded_button.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/error_handlers/auth_exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends BaseState<ForgotPasswordPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  bool isLoading = false;

  FocusNode emailFocus = FocusNode();

  String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: dynamicWidth(1),
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
                Text(
                  "Şifreni Sıfırla",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: kFontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                SizedBox(height: dynamicHeight(0.03)),
                TextFieldContainer(
                  child: FormBuilderTextField(
                    keyboardType: TextInputType.emailAddress,
                    name: "email",
                    cursorColor: kPrimaryColor,
                    autofocus: false,
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
                    focusNode: emailFocus,
                    textInputAction: TextInputAction.next,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: "Bu alan boş bırakılamaz."),
                      FormBuilderValidators.email(context,
                          errorText: "Lütfen geçerli bir e-posta adresi gir."),
                    ]),
                  ),
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
                RoundedButton(
                  textSize: 15,
                  text: "Sıfırlama Linki Gönder",
                  textColor: Colors.white,
                  press: () {
                    submitForm();
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submitForm() async {
    if (_formKey.currentState.saveAndValidate()) {
      setState(() {
        isLoading = true;
      });
      await sendPasswordResetMail();
      _formKey.currentState.reset();
      setState(() {
        isLoading = false;
      });
    } else {}
  }

  sendPasswordResetMail() async {
    try {
      var email = _formKey.currentState.value['email'].toString().trim();

      await _firebaseAuth.sendPasswordResetEmail(email: email);

      showSnackbar("Şifre sıfırlama talimatları mail adresine gönderildi.");
    } on FirebaseAuthException catch (e) {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(e.message);

      showSnackbar(errorMsg);
    } catch (e) {
      showSnackbar("Bir hata ile karşılaşıldı.");
    }
  }

  showSnackbar(String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 4,
    );
  }
}
