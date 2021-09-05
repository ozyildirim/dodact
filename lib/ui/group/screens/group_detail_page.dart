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
  TabController tabController;

  @override
  void initState() {
    group = widget.group;
    tabController = new TabController(length: 6, vsync: this);
    super.initState();

    Provider.of<GroupProvider>(context, listen: false).getGroupPosts(group);
    Provider.of<GroupProvider>(context, listen: false).getGroupMembers(group);
    Provider.of<GroupProvider>(context, listen: false).getGroupEvents(group);
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
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            navigateCreationPage(group.groupId);
          }),
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
        child: pageBody(),
      ),
    );
  }

  pageBody() {
    return Column(
      children: [
        Expanded(
          flex: 2,
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
          flex: 3,
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
