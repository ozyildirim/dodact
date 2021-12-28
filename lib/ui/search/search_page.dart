import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/lists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

enum SearchCategory { User, Post, Group, Event }

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  String name = "";
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  List<DropdownMenuItem> objectCategories = [
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
  SearchCategory selectedMenuCategory;
  var selectedArtistLabel;

  var loader = Center(
    child: CircularProgressIndicator(color: Colors.black),
  );

  Query userSearchQuery =
      usersRef.where('newUser', isEqualTo: false).orderBy('nameSurname');

  @override
  void initState() {
    super.initState();
  }

  queryHandler() {
    setState(() {
      if (category == SearchCategory.User) {
        if (selectedArtistLabel != null) {
          if (name.isNotEmpty) {
            userSearchQuery = usersRef
                .where("searchKeywords", arrayContains: name)
                .where('newUser', isEqualTo: false)
                .where('artistLabel', isEqualTo: selectedArtistLabel)
                .orderBy('nameSurname');
          } else {
            userSearchQuery = usersRef
                .where('newUser', isEqualTo: false)
                .where('artistLabel', isEqualTo: selectedArtistLabel)
                .orderBy('nameSurname');
          }
        } else {
          if (name.isNotEmpty) {
            userSearchQuery = usersRef
                .where("searchKeywords", arrayContains: name)
                .where('newUser', isEqualTo: false)
                .orderBy('nameSurname');
          } else {
            userSearchQuery = usersRef
                .where('newUser', isEqualTo: false)
                .orderBy('nameSurname');
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.only(
                            left: 16, bottom: 4, top: 4, right: 4),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Ara',
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                              queryHandler();
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showFilterBottomSheet(name);
                        },
                        icon: Icon(Icons.filter_list),
                      )
                    ],
                  ),
                ),
                buildStreamer(context, name, category)
                // buildTabViews(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showFilterBottomSheet(String input) {
    var size = MediaQuery.of(context).size;

    artistLabels.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (context, StateSetter setModalState) {
          return FormBuilder(
            key: _formKey,
            child: new Container(
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 5.0,
                bottom: 5.0,
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    title: const Text(
                      'Filtre',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: size.width * 0.4,
                          child: Text(
                            "Tür",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              color: Colors.grey[200],
                              width: size.width * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, left: 16, right: 4),
                                child: FormBuilderDropdown(
                                    initialValue: category,
                                    name: "type",
                                    onChanged: (value) {
                                      setModalState(() {
                                        category = value;
                                        selectedMenuCategory = value;
                                      });
                                    },
                                    validator:
                                        FormBuilderValidators.required(context),
                                    decoration: InputDecoration(
                                      hintText: "Tür Seçin",
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    items: objectCategories),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Divider(
                    height: 10.0,
                  ),
                  selectedMenuCategory == SearchCategory.User
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: size.width * 0.4,
                                child: Text(
                                  "Unvan",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Container(
                                    color: Colors.grey[200],
                                    width: size.width * 0.4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4,
                                          bottom: 4,
                                          left: 16,
                                          right: 4),
                                      child: FormBuilderDropdown(
                                          initialValue: selectedArtistLabel,
                                          name: "label",
                                          decoration: InputDecoration(
                                            hintText: "Unvan Seçin",
                                            contentPadding: EdgeInsets.zero,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          items: artistLabels.map((e) {
                                            return new DropdownMenuItem(
                                                value: e, child: new Text(e));
                                          }).toList()),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: new ListTile(
                          title: const Text(
                            'Uygula',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () async {
                            submitFilterDialog();
                          },
                        ),
                      ),
                      Container(
                        width: size.width * 0.4,
                        child: new ListTile(
                          title: const Text(
                            'Temizle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () async {
                            setState(() {
                              selectedArtistLabel = null;
                              category = SearchCategory.Post;
                            });

                            setModalState(() {
                              selectedMenuCategory = SearchCategory.Post;
                            });

                            NavigationService.instance.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  buildStreamer(
      BuildContext context, String input, SearchCategory searchCategory) {
    var size = MediaQuery.of(context).size;

    switch (searchCategory) {
      case SearchCategory.Post:
        return Expanded(
          child: Container(
            child: PaginateFirestore(
              bottomLoader: loader,
              initialLoader: loader,
              onEmpty: Center(
                child: Text(
                  "Hiçbir gönderi bulunamadı",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              key: ValueKey<String>(name + category.toString()),
              itemBuilderType: PaginateBuilderType.listView,
              itemBuilder:
                  (context, List<DocumentSnapshot> postList, int index) {
                PostModel post = PostModel.fromJson(
                    postList[index].data() as Map<String, dynamic>);

                if (post.postContentURL != null) {
                  return PostCard(post: post);
                } else {
                  return Container();
                }
              },
              query: (input.isNotEmpty)
                  ? postsRef
                      .where("searchKeywords", arrayContains: input)
                      .where('visible', isEqualTo: true)
                      .orderBy('postDate', descending: true)
                  : postsRef
                      .where('visible', isEqualTo: true)
                      .orderBy('postDate', descending: true),
              isLive: true,
              itemsPerPage: 10,
            ),
          ),
        );
        break;
      case SearchCategory.User:
        return Expanded(
          child: Container(
            child: PaginateFirestore(
              bottomLoader: loader,
              initialLoader: loader,
              onEmpty: Center(
                child: Text(
                  "Hiçbir kullanıcı bulunamadı",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              key: ValueKey<String>(name +
                  category.toString() +
                  userSearchQuery.toString() +
                  selectedArtistLabel.toString()),
              itemBuilderType: PaginateBuilderType.listView,
              itemBuilder:
                  (context, List<DocumentSnapshot> userList, int index) {
                UserObject user = UserObject.fromDoc(userList[index]);

                if (user.profilePictureURL != null) {
                  return UserCard(user: user);
                } else {
                  return Container();
                }
              },
              isLive: true,
              itemsPerPage: 10,
              query: userSearchQuery,
            ),
          ),
        );
        break;
      case SearchCategory.Event:
        return Expanded(
          child: Container(
            child: PaginateFirestore(
              bottomLoader: loader,
              initialLoader: loader,
              onEmpty: Center(
                child: Text(
                  "Hiçbir etkinlik bulunamadı",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              key: ValueKey<String>(name + category.toString()),
              itemBuilderType: PaginateBuilderType.listView,
              itemBuilder: (context, eventList, int index) {
                EventModel event = EventModel.fromJson(eventList[index].data());

                if (event.eventImages[0] != null) {
                  return EventCard(event: event);
                } else {
                  return Container();
                }
              },
              query: (input.isNotEmpty)
                  ? eventsRef
                      .where("searchKeywords", arrayContains: name)
                      .where('visible', isEqualTo: true)
                      .orderBy('endDate', descending: true)
                  : eventsRef
                      .where('visible', isEqualTo: true)
                      .orderBy('endDate', descending: true),
              isLive: true,
              itemsPerPage: 10,
            ),
          ),
        );
        break;
      case SearchCategory.Group:
        return Expanded(
          child: Container(
            child: PaginateFirestore(
              bottomLoader: loader,
              initialLoader: loader,
              onEmpty: Center(
                child: Text(
                  "Hiçbir topluluk bulunamadı",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              key: ValueKey<String>(input + category.toString()),
              itemBuilderType: PaginateBuilderType.listView,
              itemBuilder:
                  (context, List<DocumentSnapshot> groupList, int index) {
                GroupModel group = GroupModel.fromJson(groupList[index].data());

                return GroupCard(group: group);
              },
              query: input.isNotEmpty
                  ? groupsRef
                      .where("searchKeywords", arrayContains: name)
                      .where('visible', isEqualTo: true)
                      .orderBy('groupName', descending: true)
                  : groupsRef
                      .where('visible', isEqualTo: true)
                      .orderBy('groupName', descending: true),
              isLive: true,
              itemsPerPage: 5,
            ),
          ),
        );
        break;
    }
  }

  void submitFilterDialog() {
    if (_formKey.currentState.saveAndValidate()) {
      SearchCategory searchCategory = _formKey.currentState.value['type'];
      var label = _formKey.currentState.value['label'];

      setState(() {
        selectedArtistLabel = label;
        category = searchCategory;
        queryHandler();
      });

      NavigationService.instance.pop();
    } else {}
  }
}

class UserCard extends StatelessWidget {
  final UserObject user;
  UserCard({this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.instance
            .navigate(k_ROUTE_OTHERS_PROFILE_PAGE, args: user);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GFAvatar(
                radius: 40,
                backgroundColor: kNavbarColor,
                child: GFAvatar(
                  radius: 37,
                  backgroundImage: NetworkImage(user.profilePictureURL),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.nameSurname,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Text(
                    user.artistLabel,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    user.location,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;
  EventCard({this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigate(k_ROUTE_EVENT_DETAIL, args: event);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GFAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  event.eventImages[0],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Text(
                    event.city,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    event.eventType,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final PostModel post;
  PostCard({this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigate(k_ROUTE_POST_DETAIL, args: post);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GFAvatar(
                backgroundImage: NetworkImage(CustomMethods.createThumbnailURL(
                    post.isLocatedInYoutube, post.postContentURL,
                    isAudio: post.postContentType == "Ses" ? true : false)),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.postTitle,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Text(
                    post.postDescription,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    DateFormat('dd MMMM yyyy', 'tr_TR').format(post.postDate),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final GroupModel group;
  GroupCard({this.group});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigate(k_ROUTE_GROUP_DETAIL, args: group);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GFAvatar(
                backgroundImage: NetworkImage(
                  group.groupProfilePicture,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.groupName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Text(
                    group.groupLocation,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
