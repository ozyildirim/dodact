import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/ui/event/events_page.dart';
import 'package:dodact_v1/ui/feed/feed_page.dart';
import 'package:dodact_v1/ui/general/general_page.dart';
import 'package:dodact_v1/ui/group/groups_page.dart';
import 'package:dodact_v1/ui/profile/screens/profile_page.dart';
import 'package:dodact_v1/ui/search/search_page.dart';
import 'package:extended_navbar_scaffold/extended_navbar_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

// Oturum açmış kullanıcıların görmesi gereken sayfa.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final List<Widget> _children = [
    GeneralPage(),
    FeedPage(),
    EventsPage(),
    GroupsPage(),
    ProfilePage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ExtendedNavigationBarScaffold(
      body: _children[_page],
      elevation: 0,
      navBarColor: Colors.white,
      navBarIconColor: Colors.black,
      floatingButtonNavigation: () {
        NavigationService.instance.navigate('/creation');
      },
      moreButtons: [
        MoreButtonModel(
          icon: MaterialCommunityIcons.earth,
          label: 'Anasayfa',
          onTap: () {
            setState(() {
              _page = 0;
            });
          },
        ),
        MoreButtonModel(
          icon: MaterialCommunityIcons.instagram,
          label: 'Akış',
          onTap: () {
            setState(() {
              _page = 1;
            });
          },
        ),
        MoreButtonModel(
          icon: MaterialCommunityIcons.air_horn,
          label: 'Etkinlikler',
          onTap: () {
            setState(() {
              _page = 2;
            });
          },
        ),
        MoreButtonModel(
          icon: FontAwesome.group,
          label: 'Gruplar',
          onTap: () {
            setState(() {
              _page = 3;
            });
          },
        ),
        MoreButtonModel(
          icon: MaterialCommunityIcons.calendar,
          label: 'Takvimim',
          onTap: () {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.loading,
              text: "Bu özelliğimiz henüz aktif değil.",
            );
          },
        ),
        MoreButtonModel(
          icon: FontAwesome5Regular.user_circle,
          label: 'Profilim',
          onTap: () {
            setState(() {
              _page = 4;
            });
          },
        ),
        null,
        MoreButtonModel(
          icon: Icons.settings,
          label: 'Ayarlar',
          onTap: () {},
        ),
        null,
      ],
      searchWidget: Container(
        height: 50,
        color: Colors.redAccent,
      ),
    );
  }
}

/*

Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.home, size: 50),
            Icon(Icons.search, size: 30),
            Icon(Icons.headset, size: 30),
            Icon(Icons.group_work, size: 30),
            Icon(Icons.person, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.black,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _children[_page]);


 */
