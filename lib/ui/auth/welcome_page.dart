import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends BaseState<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/girisFoto.png'),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(flex: 4, child: Container()),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 15),
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: [
                              Text(
                                "Dodact'a",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Hoş Geldin",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Text(
                                "Sanatçı ruhların buluşma noktası",
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 20),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    navigateToSignUpPage(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: Icon(
                          Icons.navigate_next,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToLoginPage(BuildContext context) {
    NavigationService.instance.navigate('/login');
  }

  void navigateToSignUpPage(BuildContext context) {
    NavigationService.instance.navigate('/signup');
  }
}

class OptionalButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  TextStyle textStyle = TextStyle(fontSize: 16);

  OptionalButton({
    this.textStyle,
    this.onPressed,
    this.title,
    this.buttonColor,
    this.textColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 110,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        onPressed: onPressed,
        child: Text(title, style: textStyle),
        color: buttonColor,
        textColor: textColor,
      ),
    );
  }
}
