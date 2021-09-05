import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/event/widgets/parallax_events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupEventsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    return Container(
      child: provider.groupEvents != null
          ? provider.groupEvents.isNotEmpty
              ? SingleChildScrollView(
                  child: ParallaxEvents(
                    events: provider.groupEvents,
                  ),
                )
              : Center(
                  child: Container(
                    color: Colors.white60,
                    child: Text("Bu grup henüz bir etkinlik paylaşmadı.",
                        style: TextStyle(fontSize: 22)),
                  ),
                )
          : Center(
              child: spinkit,
            ),
    );
  }
}
