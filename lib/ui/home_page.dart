import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:dodact_v1/ui/event/events_page.dart';
import 'package:dodact_v1/ui/feed/feed_page.dart';
import 'package:dodact_v1/ui/group/groups_page.dart';
import 'package:dodact_v1/ui/profile/profile_page.dart';
import 'package:dodact_v1/ui/search/search_page.dart';
import 'package:flutter/material.dart';

// Oturum açmış kullanıcıların görmesi gereken sayfa.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  final List<Widget> _children = [
    FeedPage(),
    SearchPage(),
    EventsPage(),
    GroupsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  }
}

//Yedek bottom bar
/*


 */

/*

new Builder(
            builder: (context) => new AnimatedBottomBar(
                  defaultIconColor: Colors.black,
                  activatedIconColor: Colors.redAccent,
                  background: Colors.white,
                  buttonsIcons: [
                    Icons.home,
                    Icons.search,
                    Icons.group_work_rounded,
                    Icons.person
                  ],
                  buttonsHiddenIcons: [
                    Icons.camera_alt,
                    Icons.videocam,
                    Icons.mic,
                    Icons.music_note
                  ],
                  backgroundColorMiddleIcon: Colors.purple,
                  onTapButton: (i) {
                    setState(() {
                      _page = i;
                    });
                  },
                ))
 */
