import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilteredGroups extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GroupProvider>(
      builder: (_, provider, child) {
        if (provider.groupList != null) {
          if (provider.groupList.isNotEmpty) {
            List<GroupModel> groups = provider.groupList;
            print(provider.groupList.length);
            return Column(
              children: [
                Padding(
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
                              Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(groupItem
                                                      .groupProfilePicture))),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ListTile(
                                        title: Text(
                                          groupItem.groupName.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle:
                                            Text(groupItem.groupDescription),
                                        trailing: IconButton(
                                          icon: Icon(Icons.arrow_forward_ios),
                                          onPressed: () {
                                            NavigationService.instance.navigate(
                                                k_ROUTE_GROUP_DETAIL,
                                                args: groupItem);
                                          },
                                        ),
                                        isThreeLine: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 0.6,
                                indent: 40,
                                endIndent: 40,
                              )
                            ],
                          );
                        }),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: spinkit);
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

/*

Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(
                              height: 150,
                              width: 70,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          height: 120,
                                          width: 180,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(groupItem
                                                      .groupProfilePicture),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
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
                                              groupItem.groupDescription
                                                  .substring(0, 10),
                                              style: TextStyle(
                                                  color: kDetailTextColor,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Bağlar",
                                              style: TextStyle(
                                                  color: kDetailTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
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
                                        )),
                                    Divider(
                                      thickness: 0.5,
                                    )
                                  ]),
                            ),
                          );
 */
