import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_event_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_group_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_info_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_posts_part.dart';
import 'package:flutter/material.dart';

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
          padding: EdgeInsets.all(18),
          color: Colors.white54,
          width: double.infinity,
          height: 60,
          child: TabBar(
            labelPadding: EdgeInsets.all(2),
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16),
            controller: _controller,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              const Tab(
                child: Text(
                  "Hakkında",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Tab(
                child: Text(
                  "Paylaşımlar",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Tab(
                child: Text(
                  "Gruplar",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Tab(
                child: Text(
                  "Etkinlikler",
                  style: TextStyle(fontSize: 15),
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
                  child: OthersProfileInfoTab(),
                ),
                Container(
                  child: OthersProfilePostsTab(),
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
