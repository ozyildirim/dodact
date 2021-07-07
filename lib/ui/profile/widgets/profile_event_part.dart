// import 'package:dodact_v1/config/base/base_state.dart';
// import 'package:dodact_v1/config/constants/theme_constants.dart';
// import 'package:dodact_v1/model/event_model.dart';
// import 'package:dodact_v1/provider/event_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProfileEventsPart extends StatefulWidget {
//   @override
//   _ProfileEventsPartState createState() => _ProfileEventsPartState();
// }

// class _ProfileEventsPartState extends BaseState<ProfileEventsPart> {
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<EventProvider>(context, listen: false);

//     return FutureBuilder(
//       // ignore: missing_return
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//           case ConnectionState.active:
//           case ConnectionState.waiting:
//             return Center(child: spinkit);
//           case ConnectionState.done:
//             if (snapshot.hasError) {
//               return Text("Error: ${snapshot.error}");
//             }
//             List<EventModel> _userEvents = snapshot.data;
//             _userEvents != null
//                 ? _userEvents.map((e) => print(e.eventTitle))
//                 : print("Etkinlik yok");
//             return ListView(
//               scrollDirection: Axis.horizontal,
//               children: _userEvents != null
//                   ? _userEvents.map((e) => _buildUserEventCard(e)).toList()
//                   : [
//                       Center(
//                         child: Text("Etkinlik Yok :("),
//                       )
//                     ],
//             );
//         }
//       },
//       future: provider.getUserEvents(authProvider.currentUser),
//     );
//   }

//   Widget _buildUserEventCard(EventModel e) {
//     print(e);
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: GridTile(
//         child: Image.network(
//           e.eventImages[0],
//         ),
//       ),
//     );
//   }
// }
