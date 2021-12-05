import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_events_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_groups_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_info_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_interests_tab.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile/user_profile_posts_tab.dart';
import 'package:flutter/material.dart';

class UserProfileBody extends StatefulWidget {
  @override
  _UserProfileBodyState createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends State<UserProfileBody>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = new TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          // color: Colors.green,
          width: size.width,
          // height: size.height * 0.15,
          child: Center(
            child: TabBar(
              labelPadding: EdgeInsets.only(left: 8, right: 8),
              labelColor: Colors.black,
              // labelStyle: TextStyle(fontSize: 10),
              controller: _controller,
              indicatorSize: TabBarIndicatorSize.label, isScrollable: true,
              tabs: [
                const Tab(
                  child: Text(
                    "Hakkında",
                    style: TextStyle(fontSize: kUserProfileTabLabelSize),
                  ),
                ),
                const Tab(
                  child: Text(
                    "İlgi Alanları",
                    style: TextStyle(fontSize: kUserProfileTabLabelSize),
                  ),
                ),
                const Tab(
                  child: Text(
                    "Gönderiler",
                    style: TextStyle(fontSize: kUserProfileTabLabelSize),
                  ),
                ),
                const Tab(
                  child: Text(
                    "Topluluklar",
                    style: TextStyle(fontSize: kUserProfileTabLabelSize),
                  ),
                ),
                const Tab(
                  child: Text(
                    "Etkinlikler",
                    style: TextStyle(fontSize: kUserProfileTabLabelSize),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              Container(
                child: UserProfileInfoTab(),
              ),
              Container(
                child: UserProfileInterestsTab(),
              ),
              Container(
                child: UserProfilePostsTab(),
              ),
              Container(
                child: UserProfileGroupsTab(),
              ),
              Container(
                child: UserProfileEventsTab(),
              ),
            ],
          ),
        )
      ],
    );
  }
}
