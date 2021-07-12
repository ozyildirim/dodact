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

import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
