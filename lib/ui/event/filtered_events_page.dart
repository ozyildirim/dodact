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
    return Consumer<EventProvider>(
      builder: (_, provider, child) {
        if (provider.eventList != null) {
          if (provider.eventList.isNotEmpty) {
            List<EventModel> events = provider.eventList;

            return ParallaxEvents(events: events);
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Center(
                    child: Text(
                      "Henüz bir grup yok.",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
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
}




/*

Column(
                            children: [
                              Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(groupItem
                                                      .groupProfilePicture))),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        title: Text(
                                          groupItem.groupName.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle:
                                            Text(groupItem.groupDescription),
                                        trailing: IconButton(
                                          icon: Icon(Icons.arrow_forward_ios),
                                          onPressed: () {
                                            NavigationService.instance.navigate(
                                                k_ROUTE_GROUP_DETAIL,
                                                args: groupItem);
                                          },
                                        ),
                                        isThreeLine: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 0.6,
                                indent: 40,
                                endIndent: 40,
                              )
                            ],
                          );




*/