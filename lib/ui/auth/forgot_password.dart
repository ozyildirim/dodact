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
  String _email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backwardsCompatibility: false,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: dynamicWidth(1),
          color: oxfordBlue,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                    flex: 2,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Şifreni sıfırla",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: kFontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        SizedBox(height: dynamicHeight(0.03)),
                        RoundedInputField(
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
      ),
    );
  }

  Future _passwordReset(String email) async {
    try {
      _formKey.currentState.save();

      var result = await authProvider.forgotPassword(email);
      if (result != null) {
        print("User sent forgot password mail:");
      }
    } catch (e) {
      print(e);
    }
  }
}
