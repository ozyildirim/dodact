import 'package:flutter/material.dart';

class ContributionsPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // NavigationService.instance.navigate(k_ROUTE_CONTRIBUTIONS_PAGE);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Card(
          elevation: 2,
          child: Container(
            height: 100,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image(
                  image:
                      AssetImage("assets/images/app/contribution_image.png")),
              // Text(
              //   "Dodact Çark",
              //   style: TextStyle(fontSize: 18),
              // )
            ]),
          ),
        ),
      ),
    );
  }
}
