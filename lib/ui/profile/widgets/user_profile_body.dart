import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/profile/widgets/user_collections_part.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile_event_part.dart';
import 'package:dodact_v1/ui/profile/widgets/user_profile_posts_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

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
          color: Colors.white,
          width: double.infinity,
          height: 60,
          child: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16),
            controller: _controller,
            tabs: const [
              const Tab(icon: Icon(FontAwesome5Solid.adjust)),
              const Tab(icon: Icon(FontAwesome5Solid.clone)),
              const Tab(icon: Icon(FontAwesome5Solid.calendar_alt)),
              const Tab(icon: Icon(FontAwesome5Solid.star)),
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
                  child: UserProfilePostsPart(),
                ),
                Container(
                  child: UserCollectionsPart(),
                ),
                Container(
                  child: UserProfileEventsPart(),
                ),
                Container(
                  child: UserProfilePostsPart(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
