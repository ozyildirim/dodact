import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/event/widgets/parallax_events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FilteredEventView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Consumer<EventProvider>(
      builder: (_, provider, child) {
        if (provider.eventList != null) {
          if (provider.eventList.isNotEmpty) {
            List<EventModel> events = provider.eventList;

            var sortedEvents = _sortEvents(events);

            return ParallaxEvents(events: sortedEvents);
          } else {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/app/situations/not_found.png"),
                  Text(
                    "Bu kriterlere uyan bir etkinlik bulunamadı.",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: kToolbarHeight,
                  )
                ],
              ),
            );
          }
        } else {
          return Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Center(
              child: spinkit,
            ),
          );
        }
      },
    );
  }

  List<EventModel> _sortEvents(List<EventModel> events) {
    events.sort((a, b) {
      var firstEventDate = a.eventStartDate;
      var secondEventDate = b.eventStartDate;
      return firstEventDate.compareTo(secondEventDate);
    });

    return events;
  }
}
