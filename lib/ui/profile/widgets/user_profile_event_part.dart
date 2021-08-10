import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserProfileEventsPart extends StatefulWidget {
  @override
  _UserProfileEventsPartState createState() => _UserProfileEventsPartState();
}

class _UserProfileEventsPartState extends BaseState<UserProfileEventsPart> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context, listen: false);

    return FutureBuilder(
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: spinkit);
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            List<EventModel> _userEvents = snapshot.data;
            _userEvents != null
                ? _userEvents.map((e) => print(e.eventTitle))
                : print("Etkinlik yok");
            return ListView(
              scrollDirection: Axis.horizontal,
              children: _userEvents != null
                  ? _userEvents.map((e) => _buildUserEventCard(e)).toList()
                  : [
                      Center(
                        child: Text("Etkinlik Yok :("),
                      )
                    ],
            );
        }
      },
      future: provider.getUserEvents(authProvider.currentUser),
    );
  }

  Widget _buildUserEventCard(EventModel event) {
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
                bottom: 0,
                child: Container(
                  height: 55,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50].withOpacity(0.5),
                  ),
                  child: ListTile(
                    title: Text(
                      event.eventTitle,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat("dd/mm/yyyy")
                          .format(event.eventStartDate)
                          .toString(),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
