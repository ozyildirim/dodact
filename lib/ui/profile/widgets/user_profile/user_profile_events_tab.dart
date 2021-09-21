import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class UserProfileEventsTab extends StatefulWidget {
  @override
  _UserProfileEventsTabState createState() => _UserProfileEventsTabState();
}

class _UserProfileEventsTabState extends BaseState<UserProfileEventsTab> {
  @override
  void initState() {
    super.initState();
    Provider.of<EventProvider>(context, listen: false)
        .getUserEvents(authProvider.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    if (provider.userEventList != null) {
      if (provider.userEventList.isNotEmpty) {
        Logger().i("EventList boş değil");
        List<EventModel> approvedEvents =
            getApprovedEvents(provider.userEventList);

        if (approvedEvents != null && approvedEvents.isNotEmpty) {
          Logger().i("onaylanan listeler boş değil");
          Logger().i("onaylanan listeler: ${approvedEvents.length}");
          return ListView(
              scrollDirection: Axis.horizontal,
              children:
                  approvedEvents.map((e) => _buildUserEventCard(e)).toList());
        } else {
          Logger().i("onaylanan listeler boş");
          return Center(
            child: Text(
              "Herhangi bir etkinlik oluşturulmamış.",
              style: TextStyle(fontSize: 22),
            ),
          );
        }
      } else {
        Logger().i("EventList boş");
        return Center(
          child: Text(
            "Herhangi bir etkinlik oluşturulmamış.",
            style: TextStyle(fontSize: 22),
          ),
        );
      }
    } else {
      Logger().i("EventList null");
      return Center(child: spinkit);
    }
  }

  List<EventModel> getApprovedEvents(List<EventModel> eventList) {
    List<EventModel> _userEvents = eventList;
    List<EventModel> approvedEvents = [];

    approvedEvents =
        _userEvents.where((element) => element.approved == true).toList();

    return approvedEvents;
  }

  Widget _buildUserEventCard(EventModel event) {
    bool isEnded = isEventEnded(event);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          NavigationService.instance
              .navigate(k_ROUTE_EVENT_DETAIL, args: event);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(children: [
            CachedNetworkImage(
              imageUrl: event.eventImages[0],
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 320,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        event.eventImages[0],
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 10,
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50].withOpacity(0.8),
                ),
                child: ListTile(
                  title: Text(
                    event.eventTitle,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                      DateFormat("dd/MM/yyyy")
                          .format(event.eventStartDate)
                          .toString(),
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            Positioned(
              top: 1,
              right: 1,
              child: isEnded
                  ? Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.hourglass_full, color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(),
            )
          ]),
        ),
      ),
    );
  }

  bool isEventEnded(EventModel event) {
    var now = DateTime.now();
    var eventEndDate = event.eventEndDate;
    return now.isAfter(eventEndDate);
  }

// List<EventModel> _sortEvents(List<EventModel> events) {
//   events.sort((a, b) {
//     var firstEventDate = a.eventStartDate;
//     var secondEventDate = b.eventStartDate;
//     return firstEventDate.compareTo(secondEventDate);
//   });

//   return events;
// }
}
