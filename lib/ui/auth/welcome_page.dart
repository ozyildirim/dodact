import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(Icons.arrow_forward, color: Colors.black),
          onPressed: () {
            navigateSignupPage(context);
          }),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/girisFoto.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Expanded(flex: 4, child: Container()),
            Expanded(
                flex: 3,
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
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Sanatın Sosyal Medyası",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 22,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void navigateSignupPage(BuildContext context) {
    NavigationService.instance.navigate(k_ROUTE_REGISTER);
  }
}
