import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FilteredGroupView extends StatelessWidget {
  String category;
  String city;

  FilteredGroupView({this.category, this.city});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupProvider>(
      builder: (_, provider, child) {
        if (provider.groupList != null) {
          if (provider.groupList.isNotEmpty) {
            List<GroupModel> groups = provider.groupList;
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
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Image.network(
                                    groupItem.groupProfilePicture),
                                backgroundColor: Colors.transparent,
                                maxRadius: 80,
                              ),
                              title: Text(
                                groupItem.groupName,
                                style: TextStyle(fontSize: 22),
                              ),
                              subtitle: Text(
                                groupItem.groupSubtitle,
                                style: TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                provider.setGroup(groupItem);
                                NavigationService.instance.navigate(
                                    k_ROUTE_GROUP_DETAIL,
                                    args: groupItem);
                              },
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  color: Colors.white60,
                  child: Text(
                    "Bu girdilerle eşleşen bir grup bulunmuyor.",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            );
          }
        } else {
          return Container(
            height: MediaQuery.of(context).size.height - 200,
            child: Center(
              child: spinkit,
            ),
          );
        }
      },
    );
  }
}




/*

Column(
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




*/