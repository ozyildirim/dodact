import 'package:circular_menu/circular_menu.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/group/widgets/group_events_tab_view.dart';
import 'package:dodact_v1/ui/group/widgets/group_members_tab_view.dart';
import 'package:dodact_v1/ui/group/widgets/group_photos_tab_view.dart';
import 'package:dodact_v1/ui/group/widgets/group_posts_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GroupDetailPage extends StatefulWidget {
  final GroupModel group;

  const GroupDetailPage({Key key, this.group}) : super(key: key);

  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends BaseState<GroupDetailPage>
    with SingleTickerProviderStateMixin {
  GroupModel group;
  GroupProvider groupProvider;

  TabController tabController;

  @override
  void initState() {
    group = widget.group;
    tabController = new TabController(length: 6, vsync: this);
    groupProvider = getProvider<GroupProvider>();
    super.initState();

    groupProvider.setGroup(group);
    groupProvider.getGroupPosts(group);
    groupProvider.getGroupMembers(group);
    groupProvider.getGroupEvents(group);
  }

  bool isUserGroupFounder() {
    if (group.founderId == authProvider.currentUser.uid) {
      return true;
    }
    return false;
  }

  navigateGroupManagementPage() {
    NavigationService.instance.navigate(k_ROUTE_GROUP_MANAGEMENT_PAGE);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    var size = MediaQuery.of(context).size;
    Logger().i(provider.group);

    return Scaffold(
      appBar: AppBar(
        actions: isUserGroupFounder()
            ? [
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(FontAwesome5Solid.cogs),
                              title: Text("Grup Yönetimi"),
                              onTap: () {
                                navigateGroupManagementPage();
                              },
                            ),
                          ),
                        ])
              ]
            : null,
        title: Text(group.groupName),
        elevation: 8,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: dynamicWidth(1),
        height: dynamicHeight(1),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              kBackgroundImage,
            ),
          ),
        ),
        child: isUserGroupFounder() ? adminView() : userView(),
      ),
    );
  }

  adminView() {
    return CircularMenu(
        // menu alignment
        alignment: Alignment.bottomRight,
        // menu radius
        radius: 100,
        // widget in the background holds actual page content
        backgroundWidget: pageBody(),
        // global key to control the animation anywhere in the code.
        key: GlobalKey<CircularMenuState>(),
        // animation duration
        animationDuration: Duration(milliseconds: 500),
        // animation curve in forward
        curve: Curves.bounceIn,
        // animation curve in reverse
        reverseCurve: Curves.fastOutSlowIn,
        // first item angle
        startingAngleInRadian: 3.14,
        endingAngleInRadian: 1.5 * 3.14,
        // toggle button callback
        toggleButtonOnPressed: () {
          //callback
        },
        // toggle button appearance properties
        toggleButtonColor: Colors.pink,
        // toggleButtonBoxShadow: [
        //   BoxShadow(
        //     color: Colors.blue,
        //     blurRadius: 10,
        //   ),
        // ],
        toggleButtonIconColor: Colors.white,
        toggleButtonMargin: 15.0,
        toggleButtonPadding: 15.0,
        toggleButtonSize: 30.0,
        items: [
          CircularMenuItem(
            // menu item callback
            onTap: () {
              NavigationService.instance
                  .navigate(k_ROUTE_CREATION, args: group.groupId);
            },
            // menu item appearance properties
            icon: Icons.add,

            iconColor: Colors.white,
            iconSize: 30.0,
            margin: 10.0,
            padding: 10.0,
            // when 'animatedIcon' is passed,above 'icon' will be ignored
          ),
          CircularMenuItem(icon: Icons.search, onTap: () {}),
          CircularMenuItem(icon: Icons.pages, onTap: () {}),
        ]);
  }

  userView() {
    return pageBody();
  }

  pageBody() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Card(
              child: Image.network(group.groupProfilePicture),
            ),
          )),
        ),
        Divider(),
        buildTabs(),
        Expanded(
          child: SingleChildScrollView(child: buildTabViews()),
        )
      ],
    );
  }

  buildTabs() {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.white60,
      child: TabBar(
        isScrollable: true,
        labelColor: Colors.black,
        labelStyle: GoogleFonts.poppins(
          fontSize: 18,
        ),
        controller: tabController,
        tabs: [
          Tab(text: "Grup Açıklaması"),
          Tab(text: "Üyeler"),
          Tab(text: "İçerikler"),
          Tab(text: "Etkinlikler"),
          Tab(text: "Fotoğraflar"),
          Tab(text: "Duyurular"),
        ],
      ),
    );
  }

  buildTabViews() {
    return Container(
      //TODO: Boyutu ayarla
      height: dynamicHeight(0.4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: tabController,
          children: [
            buildDetailTabView(),
            buildMembersTabView(),
            buildPostsTabView(),
            buildEventsTabView(),
            buildPhotosTabView(),
            buildAnnouncementsTabView(),
          ],
        ),
      ),
    );
  }

  buildDetailTabView() {
    return Container();
  }

  buildMembersTabView() {
    return GroupMembersTab();
  }

  buildPostsTabView() {
    return GroupPostsTab();
  }

  buildEventsTabView() {
    return GroupEventsTab();
  }

  buildAnnouncementsTabView() {
    return Container();
  }

  void navigateCreationPage(String groupId) {
    NavigationService.instance.navigate(k_ROUTE_CREATION, args: group.groupId);
  }

  buildPhotosTabView() {
    return GroupPhotosTabView();
  }
}
