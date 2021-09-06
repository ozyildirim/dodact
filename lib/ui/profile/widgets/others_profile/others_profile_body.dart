import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_event_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_group_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_info_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_posts_part.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_events_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_groups_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_info_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_posts_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class OthersProfileBody extends StatefulWidget {
  @override
  _OthersProfileBodyState createState() => _OthersProfileBodyState();
}

class _OthersProfileBodyState extends State<OthersProfileBody>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          height: 60,
          child: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16),
            controller: _controller,
            tabs: const [
              const Tab(icon: Icon(FontAwesome5Solid.adjust)),
              const Tab(icon: Icon(FontAwesome5Solid.info)),
              const Tab(icon: Icon(FontAwesome5Solid.object_group)),
              const Tab(icon: Icon(FontAwesome5Solid.calendar_alt)),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 320,
            child: TabBarView(
              controller: _controller,
              children: [
                Container(
                  child: OthersProfilePostsTab(),
                ),
                Container(
                  child: OthersProfileInfoTab(),
                ),
                Container(
                  child: OthersProfileGroupsTab(),
                ),
                Container(
                  child: OthersProfileEventsTab(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
