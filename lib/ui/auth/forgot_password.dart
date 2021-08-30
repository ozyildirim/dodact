import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/common/widgets/rounded_button.dart';
import 'package:dodact_v1/ui/common/widgets/rounded_input_field.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends BaseState<ForgotPasswordPage> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();

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
                          errorText: "Lütfen e-posta adresi gir."),
                      FormBuilderValidators.email(context,
                          errorText: "Lütfen geçerli bir e-posta adresi gir."),
                    ]),
                  ),
                ),
                RoundedButton(
                  textSize: 15,
                  text: "Sıfırlama Linki Gönder",
                  textColor: Colors.white,
                  press: () {
                    resetPassword();
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

  Future resetPassword() async {
    if (_formKey.currentState.saveAndValidate()) {
      var email = _formKey.currentState.value['email'].toString().trim();
      var result = await authProvider.forgotPassword(email);

      if (result) {
        _formKey.currentState.reset();
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: new Duration(seconds: 2),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // new CircularProgressIndicator(),
              Expanded(
                child: new Text(
                  "Şifre sıfırlama talimatları mail adresinize gönderildi.",
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
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: new Duration(seconds: 2),
          content: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // new CircularProgressIndicator(),
              Expanded(
                child: new Text(
                  "Bir hata ile karşılaşıldı.",
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
    } else {}

    emailController.text = "";
  }
}
