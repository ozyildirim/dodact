import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

enum SearchCategory { User, Post, Group, Event }

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  SearchCategory radioValue1 = SearchCategory.Post;
  SearchCategory radioValue2 = SearchCategory.User;
  SearchCategory radioValue3 = SearchCategory.Group;
  SearchCategory radioValue4 = SearchCategory.Event;

  List<DropdownMenuItem> categoryItems = [
    DropdownMenuItem(
      child: Text("Gönderi"),
      value: SearchCategory.Post,
    ),
    DropdownMenuItem(
      child: Text("Kullanıcı"),
      value: SearchCategory.User,
    ),
    DropdownMenuItem(
      child: Text("Etkinlik"),
      value: SearchCategory.Event,
    ),
    DropdownMenuItem(
      child: Text("Topluluk"),
      value: SearchCategory.Group,
    ),
  ];

  SearchCategory category = SearchCategory.Post;

  @override
  Widget build(BuildContext context) {
    Logger().i(category);
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Ara'),
        // ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: AssetImage(kBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFieldContainer(
                        width: MediaQuery.of(context).size.width * 0.6,
                        padding: EdgeInsets.all(4),
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Ara',
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.search)),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                      ),
                      TextFieldContainer(
                        width: MediaQuery.of(context).size.width * 0.30,
                        padding: EdgeInsets.only(
                            left: 8, top: 4, bottom: 4, right: 4),
                        child: FormBuilderDropdown(
                          name: "searchCategory",
                          initialValue: category,
                          items: categoryItems,
                          hint:
                              Text("Kategori", style: TextStyle(fontSize: 10)),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(4)),
                          onChanged: (value) {
                            setState(() {
                              category = value;
                              Logger().i("onchanged value: category");
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                buildStreamer(context, name, category)
              ],
            ),
          ),
        ),
      ),
    );
  }

  handleSearchCategory(SearchCategory selectedCategory) {
    setState(() {
      category = selectedCategory;
    });
  }

  buildStreamer(
      BuildContext context, String input, SearchCategory searchCategory) {
    var size = MediaQuery.of(context).size;

    switch (searchCategory) {
      case SearchCategory.Post:
        Logger().d("Post case seçildi");
        return Expanded(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: (input != "" && input != null)
                  ? FirebaseFirestore.instance
                      .collection('posts')
                      .where("searchKeywords", arrayContains: name)
                      .where('visible', isEqualTo: true)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("posts")
                      .where('visible', isEqualTo: true)
                      .limit(5)
                      .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Container(
                        height: size.height * 0.5,
                        child: Center(child: spinkit),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          PostModel post = PostModel.fromJson(data.data());

                          var thumbnail = CommonMethods.createThumbnailURL(
                              post.isLocatedInYoutube, post.postContentURL);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                NavigationService.instance
                                    .navigate(k_ROUTE_POST_DETAIL, args: post);
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(thumbnail),
                                radius: 40,
                              ),
                              title: Text(
                                post.postTitle,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(post.postCategory),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        );
        break;
      case SearchCategory.User:
        Logger().d("User case seçildi");
        return Expanded(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: (input != "" && input != null)
                  ? FirebaseFirestore.instance
                      .collection('users')
                      .where("searchKeywords", arrayContains: name)
                      .where('newUser', isEqualTo: false)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("users")
                      .where('newUser', isEqualTo: false)
                      .limit(5)
                      .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: spinkit)
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          UserObject user = UserObject.fromDoc(data);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                NavigationService.instance.navigate(
                                    k_ROUTE_OTHERS_PROFILE_PAGE,
                                    args: user);
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user.profilePictureURL),
                                radius: 40,
                              ),
                              title: Text(
                                user.username,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: user.privacySettings['hide_profession']
                                  ? Container()
                                  : Text(user.profession),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        );
        break;
      case SearchCategory.Event:
        Logger().d("Event case seçildi");
        return Expanded(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: (input != "" && input != null)
                  ? FirebaseFirestore.instance
                      .collection('events')
                      .where("searchKeywords", arrayContains: name)
                      .where('visible', isEqualTo: true)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("events")
                      .where('visible', isEqualTo: true)
                      .limit(5)
                      .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: spinkit)
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          EventModel event = EventModel.fromJson(data.data());

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                NavigationService.instance.navigate(
                                    k_ROUTE_EVENT_DETAIL,
                                    args: event);
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(event.eventImages[0]),
                                radius: 40,
                              ),
                              title: Text(
                                event.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(event.category),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        );
        break;
      case SearchCategory.Group:
        Logger().d("Grup case seçildi");
        return Expanded(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: (input != "" && input != null)
                  ? FirebaseFirestore.instance
                      .collection('groups')
                      .where("groupName", arrayContains: name)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("groups")
                      .limit(5)
                      .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: spinkit)
                    : ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          GroupModel group = GroupModel.fromJson(data.data());

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                NavigationService.instance.navigate(
                                    k_ROUTE_GROUP_DETAIL,
                                    args: group);
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(group.groupProfilePicture),
                                radius: 40,
                              ),
                              title: Text(
                                group.groupName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(group.groupCategory),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        );
        break;
    }
  }
}
