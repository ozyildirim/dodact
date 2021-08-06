import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false).getAllEventsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            RefreshIndicator(
              onRefresh: () => _refreshEvents(),
              child: Container(
                width: double.infinity,
                height: 600,
                child: Consumer<EventProvider>(
                  builder: (context, provider, child) {
                    if (provider.eventList == null) {
                      return spinkit;
                    } else {
                      if (provider.eventList.isEmpty) {
                        return Center(child: Text("Etkinlik Bulunmamakta"));
                      }

                      List<EventModel> filteredEvents = provider.eventList;

                      filteredEvents = filteredEvents
                          .where((event) => event.approved == true)
                          .toList();

                      if (filteredEvents.isEmpty) {
                        return Center(child: Text("Etkinlik Bulunmamakta"));
                      }

                      /*
CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      imageUrl: eventItem.eventImages[0],
                                      imageBuilder: (context, imageProvider) {
                                        return CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              imageProvider.toString()),
                                        );
                                      })
  

  */

                      return ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          var eventItem = filteredEvents[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GFListTile(
                              onTap: () {
                                NavigationService.instance.navigate(
                                    k_ROUTE_EVENT_DETAIL,
                                    args: eventItem);
                              },
                              avatar: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: Center(child: spinkit),
                                ),
                                imageUrl: eventItem.eventImages[0],
                                imageBuilder: (context, imageProvider) {
                                  return GFAvatar(
                                    radius: 60,
                                    backgroundImage: imageProvider,
                                  );
                                },
                              ),
                              titleText: eventItem.eventTitle,
                              subtitleText:
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing',
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

/*
child: ListTile(
                              leading: eventItem != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Center(child: spinkit),
                                        imageUrl: eventItem.eventImages[0],
                                        imageBuilder: (context, imageProvider) {
                                          return CircleAvatar(
                                            radius: 50,
                                            backgroundImage: imageProvider,
                                          );
                                        },
                                      ),
                                    )
                                  : null,
                              title: Text(eventItem.eventTitle),
                              subtitle: Text(eventItem.eventDescription),
                              onTap: () => NavigationService.instance.navigate(
                                  k_ROUTE_EVENT_DETAIL,
                                  args: eventItem),
                            ),

*/

  Future<void> _refreshEvents() async {
    await Provider.of<EventProvider>(context, listen: false).getAllEventsList();
  }
}
