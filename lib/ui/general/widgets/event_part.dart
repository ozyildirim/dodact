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
      return GFCarousel(
        items: eventProvider.specialEvents.map((event) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(event.eventImages[0]),
                      fit: BoxFit.cover)),
            ),
          );
        }).toList(),
      );
    }
    return Container(
        child: Center(
      child: spinkit,
    ));
  }
}
