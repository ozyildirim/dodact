import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class EventPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventProvider>(context);

    if (eventProvider.specialEvents != null) {
      return GFItemsCarousel(
        rowCount: 2,
        children: [
          GFCard(
            padding: EdgeInsets.all(0),
            boxFit: BoxFit.cover,
            image: Image.asset('assets/images/drawerBg.jpg'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Örnek Etkinlik 1",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GFCard(
            padding: EdgeInsets.all(0),
            boxFit: BoxFit.cover,
            image: Image.asset('assets/images/drawerBg.jpg'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Örnek Etkinlik 2",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GFCard(
            padding: EdgeInsets.all(0),
            boxFit: BoxFit.cover,
            image: Image.asset('assets/images/drawerBg.jpg'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Örnek Etkinlik 3",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GFCard(
            padding: EdgeInsets.all(0),
            boxFit: BoxFit.cover,
            image: Image.asset('assets/images/drawerBg.jpg'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Örnek Etkinlik 4",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      );
    }
    return Container(
        child: Center(
      child: spinkit,
    ));
  }
}
