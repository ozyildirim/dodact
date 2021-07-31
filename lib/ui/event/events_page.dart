import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:flutter/material.dart';
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
            image: AssetImage("assets/images/app/app-background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            RefreshIndicator(
              onRefresh: () => _refreshEvents(),
              child: Container(
                width: double.infinity,
                height: 500,
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

                      return ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          var eventItem = filteredEvents[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: eventItem != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        eventItem.eventImages[0],
                                      ),
                                    )
                                  : null,
                              title: Text(eventItem.eventTitle),
                              subtitle: Text(eventItem.eventDescription),
                              onTap: () => NavigationService.instance.navigate(
                                  k_ROUTE_EVENT_DETAIL,
                                  args: eventItem),
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

  Future<void> _refreshEvents() async {
    await Provider.of<EventProvider>(context, listen: false).getAllEventsList();
  }
}
