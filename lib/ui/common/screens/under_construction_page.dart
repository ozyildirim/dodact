import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';

class UnderConstructionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/app/under_construction.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.4,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/app/logo.png'),
              )),
            ),
            Text(
              "Kısa bir süreliğine bakımdayız",
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GFIconButton(
                    color: Colors.transparent,
                    shape: GFIconButtonShape.circle,
                    icon: Icon(FontAwesome5Brands.twitter),
                    onPressed: () {
                      CustomMethods.launchURL(
                          context, "https://twitter.com/dodactcom");
                    }),
                GFIconButton(
                    shape: GFIconButtonShape.circle,
                    color: Colors.transparent,
                    icon: Icon(FontAwesome5Brands.instagram),
                    onPressed: () {
                      CustomMethods.launchURL(
                          context, "https://twitter.com/dodactcom");
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
