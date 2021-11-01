import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_event_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_group_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_info_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_posts_part.dart';
import 'package:flutter/material.dart';

class OthersProfileBody extends StatefulWidget {
  final UserObject user;

  OthersProfileBody({this.user});

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
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(18),
          width: size.width,
          height: size.height * 0.1,
          child: TabBar(
            labelPadding: EdgeInsets.all(2),
            labelColor: Colors.black,
            controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              const Tab(
                child: Text(
                  "Hakkında",
                  style: TextStyle(fontSize: kUserProfileTabLabelSize),
                ),
              ),
              const Tab(
                child: Text(
                  "Paylaşımlar",
                  style: TextStyle(fontSize: kUserProfileTabLabelSize),
                ),
              ),
              const Tab(
                child: Text(
                  "Gruplar",
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
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              Container(
                child: OthersProfileInfoTab(user: widget.user),
              ),
              Container(
                child: OthersProfilePostsTab(user: widget.user),
              ),
              Container(
                child: OthersProfileGroupsTab(user: widget.user),
              ),
              Container(
                child: OthersProfileEventsTab(user: widget.user),
              ),
            ],
          ),
        )
      ],
    );
  }
}
