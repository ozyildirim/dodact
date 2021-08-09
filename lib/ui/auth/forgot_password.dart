import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/common_widgets/rounded_button.dart';
import 'package:dodact_v1/ui/common_widgets/rounded_input_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends BaseState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();

  String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kAuthBackgroundImage), fit: BoxFit.cover),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 2,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                      RoundedInputField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "E-posta adresi",
                        onChanged: (value) {
                          _email = value;
                        },
                      ),
                      RoundedButton(
                        textSize: 15,
                        text: "Sıfırlama Linki Gönder",
                        textColor: Colors.white,
                        press: () {
                          _passwordReset(_email);
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future _passwordReset(String email) async {
    try {
      _formKey.currentState.save();
      await authProvider.forgotPassword(email);

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

      emailController.text = "";
    } catch (e) {
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
  }
}
