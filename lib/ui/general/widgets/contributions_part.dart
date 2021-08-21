import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class ContributionsPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationService.instance.navigate(k_ROUTE_CONTRIBUTIONS_PAGE);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.amberAccent,
          height: 100,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image(image: AssetImage("assets/images/app/spinner_image.png")),
            // Text(
            //   "Dodact Çark",
            //   style: TextStyle(fontSize: 18),
            // )
          ]),
        ),
      ),
    );
  }
}
