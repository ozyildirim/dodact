import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                              title: Text(groupItem.groupName),
                              subtitle: Text(groupItem.groupDescription),
                              onTap: () {
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
            return Center(
                child: Text("Bu il ve kategoride grup bulunmamakta :("));
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