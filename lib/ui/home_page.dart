import 'package:dodact_v1/ui/creation/creation_page.dart';
import 'package:dodact_v1/ui/discover/discover_page.dart';
import 'package:dodact_v1/ui/general/general_page.dart';
import 'package:dodact_v1/ui/profile/screens/profile_page.dart';
import 'package:dodact_v1/ui/suffle/shuffle_page.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

// Oturum açmış kullanıcıların görmesi gereken sayfa.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> _children = [
    GeneralPage(),
    DiscoverPage(),
    ShufflePage(),
    CreationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[selectedIndex],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     NavigationService.instance.navigate(k_ROUTE_CREATION);
      //   },
      //   child: Icon(Icons.add),
      // ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBackgroundColor: Colors.grey,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: FontAwesome5Solid.home,
            label: 'Anasayfa',
          ),
          FFNavigationBarItem(
            iconData: FontAwesome5Solid.globe_europe,
            label: 'Keşfet',
          ),
          FFNavigationBarItem(
            iconData: Icons.shuffle,
            label: 'Karışık',
          ),
          FFNavigationBarItem(
            iconData: Icons.add,
            label: 'Oluştur',
          ),
          FFNavigationBarItem(
            iconData: Icons.person,
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
