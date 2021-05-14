// import 'package:dodact_v1/config/base/base_state.dart';
// import 'package:dodact_v1/config/constants/theme_constants.dart';
// import 'package:dodact_v1/provider/event_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class EventsPage extends StatefulWidget {
//   @override
//   _EventsPageState createState() => _EventsPageState();
// }
//
// class _EventsPageState extends BaseState<EventsPage> {
//   EventProvider _eventProvider;
//
//   @override
//   void initState() {
//     super.initState();
//     _eventProvider = getProvider<EventProvider>();
//     _eventProvider.getList(isNotify: false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: spinkit,
//         ),
//       ),
//     );
//   }
//
//   // Consumer<EventProvider> eventsPart() {
//   //   return Consumer<EventProvider>(
//   //     builder: (_, provider, child) {
//   //       if (provider.eventList != null) {
//   //         if (provider.eventList.isNotEmpty) {
//   //           List<EventModel> events = provider.eventList;
//   //           print(provider.eventList.length);
//   //           return Padding(
//   //             padding: const EdgeInsets.all(8.0),
//   //             child: Container(
//   //                 child: ListView.builder(
//   //                     shrinkWrap: true,
//   //                     primary: false,
//   //                     scrollDirection: Axis.vertical,
//   //                     itemCount: provider.eventList.length,
//   //                     itemBuilder: (context, index) {
//   //                       var eventItem = provider.eventList[index];
//   //                     })),
//   //           );
//   //         } else {
//   //           return Center(child: spinkit);
//   //         }
//   //       } else {
//   //         return Center(
//   //           child: spinkit,
//   //         );
//   //       }
//   //     },
//   //   );
//   // }
// }

import 'package:dodact_v1/model/date_model.dart';
import 'package:dodact_v1/model/event_type_model.dart';
import 'package:dodact_v1/model/events_model.dart';
import 'package:dodact_v1/ui/event/data.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<DateModel> dates = [];
  List<EventTypeModel> eventsType = [];
  List<EventsModel> events = [];

  String todayDateIs = "12";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dates = getDates();
    eventsType = getEventTypes();
    events = getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Merhaba, Kutay!",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 21),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Etrafında neler oluyor?",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15),
                              )
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      /// Dates
                      Container(
                        height: 60,
                        child: ListView.builder(
                            itemCount: dates.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return DateTile(
                                weekDay: dates[index].weekDay,
                                date: dates[index].date,
                                isSelected: todayDateIs == dates[index].date,
                              );
                            }),
                      ),

                      /// Events
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Bütün Etkinlikler",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 100,
                        child: ListView.builder(
                            itemCount: eventsType.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return EventTile(
                                imgAssetPath: eventsType[index].imgAssetPath,
                                eventType: eventsType[index].eventType,
                              );
                            }),
                      ),

                      /// Popular Events
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Popüler Etkinlikler",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: ListView.builder(
                            itemCount: events.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return PopularEventTile(
                                desc: events[index].desc,
                                imgeAssetPath: events[index].imgeAssetPath,
                                date: events[index].date,
                                address: events[index].address,
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  String weekDay;
  String date;
  bool isSelected;
  DateTile({this.weekDay, this.date, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: isSelected ? Color(0xffFCCD00) : Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            weekDay,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  String imgAssetPath;
  String eventType;
  EventTile({this.imgAssetPath, this.eventType});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imgAssetPath,
            height: 27,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            eventType,
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}

class PopularEventTile extends StatelessWidget {
  String desc;
  String date;
  String address;
  String imgeAssetPath;

  /// later can be changed with imgUrl
  PopularEventTile({this.address, this.date, this.imgeAssetPath, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    desc,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/calender.png",
                        height: 12,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        date,
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/location.png",
                        height: 12,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        address,
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Image.asset(
                imgeAssetPath,
                height: 100,
                width: 120,
                fit: BoxFit.cover,
              )),
        ],
      ),
    );
  }
}
