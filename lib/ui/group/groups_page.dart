import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/group/text_guide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends BaseState<GroupsPage> {
  GroupProvider _groupProvider;

  @override
  void initState() {
    super.initState();
    _groupProvider = getProvider<GroupProvider>();
    _groupProvider.getGroupList(isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [eventsPart()],
          ),
        ),
      ),
    );
  }

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
}
