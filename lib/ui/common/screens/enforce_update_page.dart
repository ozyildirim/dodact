import 'dart:io';

import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';

class EnforcedUpdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(kAuthBackgroundImage),
          ),
        ),
        child: Center(
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lütfen uygulamayı güncelleyin",
                      style: TextStyle(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Platform.isAndroid
                        ? GFIconButton(
                            color: Colors.transparent,
                            icon: Icon(FontAwesome5Brands.google_play,
                                color: Colors.black),
                            onPressed: () {
                              CustomMethods.launchURL(context,
                                  "https://play.google.com/store/apps/details?id=com.dodact.dodact_v1");
                            })
                        : GFIconButton(
                            color: Colors.transparent,
                            icon: Icon(
                              FontAwesome5Brands.app_store_ios,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              CustomMethods.launchURL(context,
                                  "https://apps.apple.com/us/app/dodact/id1596151747");
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
