import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/event/widgets/parallax_events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupEventsTab extends StatelessWidget {
  final String groupId;

  GroupEventsTab({this.groupId});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print("çalıştı");
    var provider = Provider.of<GroupProvider>(context, listen: false);
    // return Container(
    //   child: provider.groupEvents != null
    //       ? provider.groupEvents.isNotEmpty
    //           ? SingleChildScrollView(
    //               child: ParallaxEvents(
    //                 events: provider.groupEvents,
    //               ),
    //             )
    //           : Center(
    //               child: Container(
    //                 color: Colors.white60,
    //                 child: Text("Bu grup henüz bir etkinlik paylaşmadı.",
    //                     style: TextStyle(fontSize: 22)),
    //               ),
    //             )
    //       : Center(
    //           child: spinkit,
    //         ),
    // );

    return FutureBuilder(
        future: provider.getGroupEvents(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var event = snapshot.data[index];
                    return Container(
                      height: size.height * 0.2,
                      child: ParallaxEvent(
                        event: event,
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Container(
                    color: Colors.white60,
                    child: Text("Bu grup henüz bir etkinlik paylaşmadı.",
                        style: TextStyle(fontSize: kPageCenteredTextSize)),
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  "Bir hata oluştu.",
                  style: TextStyle(fontSize: kPageCenteredTextSize),
                ),
              );
            }
          } else {
            return Center(
              child: spinkit,
            );
          }
        });
  }
}
