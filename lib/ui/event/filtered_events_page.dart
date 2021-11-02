// import 'package:dodact_v1/model/event_model.dart';
// import 'package:dodact_v1/provider/event_provider.dart';
// import 'package:dodact_v1/ui/event/widgets/parallax_events.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // ignore: must_be_immutable
// class FilteredEventView extends StatefulWidget {
//   @override
//   State<FilteredEventView> createState() => _FilteredEventViewState();
// }

// class _FilteredEventViewState extends State<FilteredEventView> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);

//     if (provider.eventsSnapshot.isNotEmpty) {
//       List<EventModel> events = provider.events;
//       return ListView.builder(
//           controller: scrollController,
//           itemCount: provider.events.length,
//           itemBuilder: (context, index) {
//             var event = sortedEvents[index];
//             return Container(
//                 height: mediaQuery.size.height * 0.3,
//                 child: ParallaxEvent(event: event));
//             ;
//           });
//     } else {
//       return Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset("assets/images/app/situations/not_found.png"),
//             Text(
//               "Bu kriterlere uyan bir etkinlik bulunamadı.",
//               style: TextStyle(fontSize: 22),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(
//               height: kToolbarHeight,
//             )
//           ],
//         ),
//       );
//     }
//   }
// }
