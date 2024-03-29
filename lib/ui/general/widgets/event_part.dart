import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventPart extends StatefulWidget {
  @override
  State<EventPart> createState() => _EventPartState();
}

class _EventPartState extends State<EventPart> {
  List<EventModel> specialEvents;

  @override
  void initState() {
    super.initState();
    getSpecialEvents();
  }

  getSpecialEvents() async {
    Provider.of<EventProvider>(context, listen: false)
        .getSpecialEvents()
        .then((value) => {
              setState(() {
                specialEvents = value;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (specialEvents != null) {
      // return GFCarousel(
      //   items: specialEvents.map(
      //     (event) {
      //       return InkWell(
      //         onTap: () {
      // NavigationService.instance.navigate(
      //   k_ROUTE_EVENT_DETAIL,
      //   args: event,
      // );
      //         },
      //         child: buildEventCard(),
      //       );
      //     },
      //   ).toList(),
      // );

      // return Container(
      //   height: size.height * 0.20,
      //   width: size.width,
      //   child: ListView.builder(
      //     scrollDirection: Axis.horizontal,
      //     itemBuilder: (context, index) {
      //       return buildEventCard(specialEvents[index]);
      //     },
      //     itemCount: specialEvents.length,
      //   ),
      // );

      return GFCarousel(
          aspectRatio: 16 / 8,
          autoPlay: true,
          pagerSize: size.width * 0.8,
          viewportFraction: 1.0,
          items: specialEvents.map((event) {
            return InkWell(
              onTap: () {
                NavigationService.instance.navigate(
                  k_ROUTE_EVENT_DETAIL,
                  args: event,
                );
              },
              child: buildEventCard(event),
            );
          }).toList());
    }
    return Container(
        child: Center(
      child: spinkit,
    ));
  }

  buildEventCard(EventModel event) {
    var size = MediaQuery.of(context).size;

    var cardWidth = size.width * 0.9;
    return InkWell(
      onTap: () {
        NavigationService.instance.navigate(
          k_ROUTE_EVENT_DETAIL,
          args: event,
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: size.height * 0.12,
          width: cardWidth,
          child: Row(
            children: [
              Container(
                width: cardWidth * 0.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(event.eventImages[0]),
                        fit: BoxFit.cover)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormat("EEE, d/M", "tr_TR")
                                .format(event.startDate)
                                .toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(DateFormat("HH:mm").format(event.startDate)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: size.height * 0.07,
                        child: Text(
                          event.title,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          event.isOnline
                              ? Flexible(
                                  child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text("Online")),
                                )
                              : Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      event.city,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                event.eventType,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
