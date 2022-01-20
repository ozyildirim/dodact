import 'package:circular_menu/circular_menu.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';

import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/group/widgets/group_events_tab_view.dart';
import 'package:dodact_v1/ui/group/widgets/group_info_tab_view.dart';
import 'package:dodact_v1/ui/group/widgets/group_interests_tab_view.dart';
import 'package:dodact_v1/ui/group/widgets/group_members_tab_view.dart';
import 'package:dodact_v1/ui/group/widgets/group_photos_tab_view.dart';
import 'package:dodact_v1/ui/group/widgets/group_posts_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GroupDetailPage extends StatefulWidget {
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
    super.initState();
    tabController = new TabController(length: 6, vsync: this);
    groupProvider = getProvider<GroupProvider>();
    group = Get.arguments;
    groupProvider.setGroup(group);
    // fetchGroup();
  }

  // fetchGroup() async {
  //   await Provider.of<GroupProvider>(context, listen: false)
  //       .getGroupDetail(group.groupId)
  //       .then((value) {
  //     setState(() {
  //       group = value;
  //     });
  //   });
  // }

  bool isUserGroupFounder() {
    if (group.managerId == userProvider.currentUser.uid) {
      return true;
    }
    return false;
  }

  navigateGroupManagementPage() {
    Get.toNamed(k_ROUTE_GROUP_MANAGEMENT_PAGE);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: isUserGroupFounder()
          ? FloatingActionButton(
              onPressed: () {
                Get.toNamed(k_ROUTE_CREATION_MENU, arguments: group.groupId);
              },
              child: Icon(Icons.add),
            )
          : null,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.black),
        actions: isUserGroupFounder()
            ? [
                PopupMenuButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) async {
                      if (value == 0) {
                        navigateGroupManagementPage();
                      }
                    },
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(FontAwesome5Solid.cogs,
                                    size: 16, color: Colors.black),
                                SizedBox(width: 14),
                                Text("Topluluk Yönetimi",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ])
              ]
            : null,
        // title: Text(group.groupName),
        elevation: 0,
      ),
      body: Container(
        width: dynamicWidth(1),
        height: dynamicHeight(1),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        // child: isUserGroupFounder() ? adminView() : userView(),
        child: pageBody(),
      ),
    );
  }

  userView() {
    return pageBody();
  }

  pageBody() {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: dynamicHeight(0.3),
            width: dynamicWidth(1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: dynamicWidth(0.35),
                  child: Text(
                    group.groupName,
                    // maxLines: 3,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: dynamicWidth(0.02),
                ),
                GestureDetector(
                  onTap: () {
                    CustomMethods.showImagePreviewDialog(context,
                        url: group.groupProfilePicture);
                  },
                  child: Card(
                    elevation: 8,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(group.groupProfilePicture),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: dynamicHeight(0.25),
                      width: dynamicWidth(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider(),
          buildTabs(),
          Expanded(
            child: buildTabViews(),
          )
        ],
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
        toggleButtonBoxShadow: [
          // BoxShadow(
          //   color: Colors.blue,
          //   blurRadius: 10,
          // ),
        ],
        toggleButtonIconColor: Colors.white,
        toggleButtonMargin: 15.0,
        toggleButtonPadding: 15.0,
        toggleButtonSize: 30.0,
        items: [
          CircularMenuItem(
            // menu item callback
            onTap: () {
              Get.toNamed(k_ROUTE_CREATION_MENU, arguments: group.groupId);
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

  buildTabs() {
    return Container(
      width: double.infinity,
      height: 50,
      child: TabBar(
        isScrollable: true,
        labelColor: Colors.black,
        // labelStyle: GoogleFonts.poppins(
        //   fontSize: 18,
        // ),
        labelStyle: TextStyle(fontSize: 16),
        indicatorSize: TabBarIndicatorSize.label,
        controller: tabController,
        tabs: [
          Tab(text: "Açıklama"),
          Tab(text: "Üyeler"),
          Tab(text: "Gönderiler"),
          Tab(text: "Etkinlikler"),
          Tab(text: "Medya"),
          // Tab(text: "Duyurular"),
          Tab(text: "İlgi Alanları"),
        ],
      ),
    );
  }

  buildTabViews() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TabBarView(
        controller: tabController,
        children: [
          buildDetailTabView(),
          buildMembersTabView(),
          buildPostsTabView(),
          buildEventsTabView(),
          buildMediaTabView(),
          // buildAnnouncementsTabView(),
          buildInterestsTabView()
        ],
      ),
    );
  }

  buildDetailTabView() {
    return GroupInfoTab();
  }

  buildMembersTabView() {
    return GroupMembersTab(group: group);
  }

  buildPostsTabView() {
    return GroupPostsTab(groupId: group.groupId);
  }

  buildEventsTabView() {
    return GroupEventsTab(groupId: group.groupId);
  }

  // buildAnnouncementsTabView() {
  //   return Container(
  //     child:Center(
  //       child:Text("Bu topluluk henüz bir duyuru paylaşmadı")
  //     );
  //   );
  // }

  buildMediaTabView() {
    return GroupMediaTabView();
  }

  buildInterestsTabView() {
    return GroupInterestsTabView();
  }

  void navigateCreationPage(String groupId) {
    Get.toNamed(k_ROUTE_CREATION_MENU, arguments: group.groupId);
  }
}
