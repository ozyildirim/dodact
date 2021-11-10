import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/discover/widgets/posts_part.dart';
import 'package:dodact_v1/ui/event/events_page.dart';
import 'package:dodact_v1/ui/group/screens/groups_page.dart';
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
    return Scaffold(
      appBar: GFAppBar(
        // backgroundColor: GFColors.WHITE,
        centerTitle: true,
        title: GFSegmentTabs(
          labelStyle: Theme.of(context).textTheme.copyWith().bodyText1,
          unselectedLabelStyle: Theme.of(context)
              .textTheme
              .copyWith(
                bodyText1: TextStyle(fontSize: 14, fontFamily: "Raleway"),
              )
              .bodyText1,
          borderRadius: BorderRadius.circular(15),
          height: GFAppBar().preferredSize.height * 0.65,
          width: mediaQuery.size.width * 0.9,
          tabController: tabController,
          tabBarColor: GFColors.LIGHT,
          labelPadding: EdgeInsets.zero,

          unselectedLabelColor: GFColors.DARK,
          indicator: BoxDecoration(
            // color: Colors.orange[700],
            color: Color(0xff194d25),
            borderRadius: BorderRadius.circular(15),
          ),
          // indicatorPadding: EdgeInsets.all(8.0),

          indicatorWeight: 2.0,
          border: Border.all(color: Colors.white, width: 1.0),
          length: 3,
          tabs: <Widget>[
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Paylaşımlar",
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Etkinlikler",
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Topluluklar",
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: GFTabBarView(
          controller: tabController,
          children: <Widget>[
            PostsPart(),
            EventsPage(),
            GroupsPage(),
          ],
        ),
      ),
    );
  }
}
