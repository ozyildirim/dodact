import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/event/widgets/parallax_events.dart';
import 'package:dodact_v1/ui/event/widgets/parallax_example.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool isFiltered = false;

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
                  // ignore: missing_return
                  builder: (context, provider, child) {
                    if (provider.eventList == null) {
                      return spinkit;
                    } else {
                      if (provider.eventList.isEmpty) {
                        return Center(child: Text("Etkinlik Bulunmamakta"));
                      }

                      List<EventModel> approvedEvents = provider.eventList;

                      approvedEvents = approvedEvents
                          .where((event) => event.approved == true)
                          .toList();

                      if (approvedEvents.isEmpty) {
                        return Center(child: Text("Etkinlik Bulunmamakta"));
                      }

                      return ParallaxEvents(events: approvedEvents);
                      // return ExampleParallax();

                      // return ListView.builder(
                      //   itemCount: approvedEvents.length,
                      //   itemBuilder: (context, index) {
                      //     var eventItem = approvedEvents[index];
                      //     return Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: GFListTile(
                      //         onTap: () {
                      //           NavigationService.instance.navigate(
                      //               k_ROUTE_EVENT_DETAIL,
                      //               args: eventItem);
                      //         },
                      //         avatar: eventItem.eventImages.isNotEmpty
                      //             ? CachedNetworkImage(
                      //                 placeholder: (context, url) => Container(
                      //                   child: Center(child: spinkit),
                      //                 ),
                      //                 imageUrl: eventItem.eventImages[0],
                      //                 imageBuilder: (context, imageProvider) {
                      //                   return GFAvatar(
                      //                     radius: 60,
                      //                     backgroundImage: imageProvider,
                      //                   );
                      //                 },
                      //               )
                      //             : GFAvatar(
                      //                 radius: 60,
                      //               ),
                      //         titleText: eventItem.eventTitle,
                      //         subTitleText:
                      //             'Lorem ipsum dolor sit amet, consectetur adipiscing',
                      //       ),
                      //     );
                      //   },
                      // );
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

  //TODO: Şehir filtreleme mekanizmasını ekle
  // Container _buildFilterBar() {
  //   return Container(
  //     height: 50,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SizedBox(width: 20),
  //         GestureDetector(
  //           child: filterCardContainer(selectedCity, Icon(Icons.location_on)),
  //           onTap: () {
  //             _showCityPicker();
  //           },
  //         ),
  //         GestureDetector(
  //           child: filterCardContainer(selectedCategory, Icon(Icons.category)),
  //           onTap: () {
  //             _showCategoryPicker();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Container filterCardContainer(String interest, Icon icon) {
  //   return Container(
  //     width: 140,
  //     height: 60,
  //     child: Card(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: Center(
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             icon,
  //             Text(interest),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // List<String> categoryItemValues = ["Tümü", "Müzik", "Tiyatro", "Dans"];

  Future<void> _refreshEvents() async {
    await Provider.of<EventProvider>(context, listen: false).getAllEventsList();
  }
}
