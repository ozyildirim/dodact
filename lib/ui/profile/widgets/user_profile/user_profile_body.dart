import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_events_tab.dart';
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
    _controller = new TabController(length: 3, vsync: this);
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
                  child: UserProfilePostsTab(),
                ),
                Container(
                  child: UserProfileInfoTab(),
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
