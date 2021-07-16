import 'package:dodact_v1/ui/discover/widgets/posts_part.dart';
import 'package:dodact_v1/ui/event/events_page.dart';
import 'package:dodact_v1/ui/group/groups_page.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with TickerProviderStateMixin {
  TabController tabController;
  var initialIndex = 0;

  @override
  void initState() {
    super.initState();
    initialIndex = 0;
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: GFAppBar(
          backgroundColor: GFColors.WHITE,
          centerTitle: true,
          title: GFSegmentTabs(
            labelStyle: Theme.of(context).textTheme.copyWith().bodyText1,
            unselectedLabelStyle:
                Theme.of(context).textTheme.copyWith().bodyText1,
            borderRadius: BorderRadius.circular(15),
            height: GFAppBar().preferredSize.height * 0.75,
            width: mediaQuery.size.width * 0.8,
            tabController: tabController,
            tabBarColor: GFColors.LIGHT,
            labelColor: GFColors.WHITE,
            unselectedLabelColor: GFColors.DARK,
            indicator: BoxDecoration(
              color: GFColors.DARK,
              borderRadius: BorderRadius.circular(15),
            ),
            indicatorPadding: EdgeInsets.all(8.0),
            indicatorWeight: 2.0,
            border: Border.all(color: Colors.white, width: 1.0),
            length: 3,
            tabs: <Widget>[
              Text(
                "Paylaşımlar",
              ),
              Text(
                "Etkinlikler",
              ),
              Text(
                "Topluluklar",
              ),
            ],
          ),
        ),
        body: GFTabBarView(
          controller: tabController,
          children: <Widget>[PostsPart(), EventsPage(), GroupsPage()],
        ),
      ),
    );
  }
}
