import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends BaseState<GroupsPage> {
  GroupProvider _groupProvider;
  int tappedIndex;

  final List<Widget> _pageBody = [filteredGroups(), randomGroups()];

  @override
  void initState() {
    super.initState();
    tappedIndex = 0;
    _groupProvider = getProvider<GroupProvider>();
    _groupProvider.getGroupList(isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(child: Consumer<GroupProvider>(
          builder: (_, provider, child) {
            if (provider.groupList != null) {
              if (provider.groupList.isNotEmpty) {
                List<GroupModel> groups = provider.groupList;
                print(provider.groupList.length);
                return Container(
                  height: dynamicHeight(1),
                  color: Color(0xFFF1F0F2),
                  child: Column(
                    children: [
                      customAppBar(),
                      filterBar(),
                      _pageBody[tappedIndex]
                    ],
                  ),
                );
              } else {
                return Center(
                  child: spinkit,
                );
              }
            } else {
              return Center(child: spinkit);
            }
          },
        )

            // Column(
            //   children:
            //
            //    [customAppBar(), _pageBody[tappedIndex]],
            // ),
            ),
      ),
    );
  }

  Container customAppBar() {
    return Container(
      decoration: BoxDecoration(
          color: kCustomAppBarColor,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          )),
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          menuButtons('ARA', 0),
          menuButtons('KEŞFET', 1),
          menuButtons('YAKINDA', 2),
        ],
      ),
    );
  }

  RaisedButton menuButtons(String menuName, int menuIndex) {
    // ignore: deprecated_member_use
    return RaisedButton(
        color: tappedIndex == menuIndex ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40.0)),
        onPressed: () {
          setState(() {
            tappedIndex = menuIndex;
          });
        },
        child: Text(
          menuName,
          style: TextStyle(
            color: tappedIndex == menuIndex ? Colors.black : Colors.grey,
          ),
        ));
  }
}

Container filterBar() {
  return Container(
    height: 50,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        filterCardContainer('Eskişehir'),
        filterCardContainer('Müzik'),
      ],
    ),
  );
}

Container filterCardContainer(String interest) {
  return Container(
      width: 120,
      height: 40,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.location_on),
              Text(interest),
            ],
          ))));
}

Consumer<GroupProvider> filteredGroups() {
  return Consumer<GroupProvider>(
    builder: (_, provider, child) {
      if (provider.groupList != null) {
        if (provider.groupList.isNotEmpty) {
          List<GroupModel> groups = provider.groupList;
          print(provider.groupList.length);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemCount: provider.groupList.length,
                  itemBuilder: (context, index) {
                    var groupItem = provider.groupList[index];
                    return Container(
                      height: 140,
                      width: 70,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  height: 160,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              groupItem.groupProfilePicture),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  groupItem.groupName,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  groupItem.groupDescription.substring(0, 10),
                                  style: TextStyle(
                                      color: kDetailTextColor, fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Bağlar",
                                  style: TextStyle(color: kDetailTextColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 10,
                              child: Icon(
                                Icons.navigate_next,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          );
        } else {
          return Center(
            child: spinkit,
          );
        }
      } else {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 200,
            color: Colors.purple,
            child: Center(
                child: Text(
              "Henüz bir grup yok :(",
              style: TextStyle(fontSize: 25),
            )),
          ),
        ));
      }
    },
  );
}

Consumer<GroupProvider> randomGroups() {
  return Consumer<GroupProvider>(
    builder: (_, provider, child) {
      if (provider.groupList != null) {
        if (provider.groupList.isNotEmpty) {
          List<GroupModel> groups = provider.groupList;
          print(provider.groupList.length);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: provider.groupList.length,
                    itemBuilder: (context, index) {
                      var groupItem = provider.groupList[index];
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 130,
                                  width: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                        groupItem.groupProfilePicture),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      groupItem.groupName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(groupItem.groupDescription
                                        .substring(0, 15))
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "ROCK",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            indent: 20,
                            endIndent: 20,
                            color: Colors.grey,
                            thickness: 1.5,
                          ),
                        ],
                      );
                    })),
          );
        } else {
          return Center(
            child: spinkit,
          );
        }
      } else {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 200,
            color: Colors.purple,
            child: Center(
                child: Text(
              "Henüz bir grup yok :(",
              style: TextStyle(fontSize: 25),
            )),
          ),
        ));
      }
    },
  );
}

/*
  Consumer<GroupProvider> eventsPart() {
    return Consumer<GroupProvider>(
      builder: (_, provider, child) {
        if (provider.groupList != null) {
          if (provider.groupList.isNotEmpty) {
            List<GroupModel> groups = provider.groupList;
            print(provider.groupList.length);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      itemCount: provider.groupList.length,
                      itemBuilder: (context, index) {
                        var groupItem = provider.groupList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  child: Image(
                                    image: NetworkImage(
                                        groupItem.groupProfilePicture),
                                    height: 150,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              groupItem.groupName,
                                              style: eventTitleTextStyle,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            FittedBox(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.group),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    groupItem.groupMemberList
                                                            .length
                                                            .toString() +
                                                        " üye",
                                                    style:
                                                        eventLocationTextStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          groupItem.groupCategory,
                                          textAlign: TextAlign.right,
                                          style:
                                              eventLocationTextStyle.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            );
          } else {
            return Center(
              child: spinkit,
            );
          }
        } else {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              color: Colors.purple,
              child: Center(
                  child: Text(
                "Henüz bir grup yok :(",
                style: TextStyle(fontSize: 25),
              )),
            ),
          ));
        }
      },
    );
  }



 */
