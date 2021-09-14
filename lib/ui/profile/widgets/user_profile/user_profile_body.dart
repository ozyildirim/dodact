import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_events_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_groups_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_info_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_posts_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class UserProfileBody extends StatefulWidget {
  @override
  _UserProfileBodyState createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends State<UserProfileBody>
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
          color: Colors.white54,
          width: double.infinity,
          height: 60,
          child: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16),
            controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                icon: Icon(
                  FontAwesome5Solid.layer_group,
                  size: 20,
                ),
                child: Text(
                  "Paylaşımlar",
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const Tab(
                icon: Icon(
                  FontAwesome5Solid.question,
                  size: 20,
                ),
                child: Text(
                  "Hakkında",
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const Tab(
                icon: Icon(
                  FontAwesome5Solid.user_friends,
                  size: 20,
                ),
                child: Text(
                  "Gruplar",
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const Tab(
                icon: Icon(
                  FontAwesome5Solid.calendar_alt,
                  size: 20,
                ),
                child: Text(
                  "Etkinlikler",
                  style: TextStyle(fontSize: 13),
                ),
              ),
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
                  child: UserProfilePostsTab(),
                ),
                Container(
                  child: UserProfileInfoTab(),
                ),
                Container(
                  child: UserProfileGroupsTab(),
                ),
                Container(
                  child: UserProfileEventsTab(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
