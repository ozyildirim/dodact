import 'package:cached_network_image/cached_network_image.dart';
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
    var size = MediaQuery.of(context).size;
    return Consumer<GroupProvider>(
      builder: (_, provider, child) {
        if (provider.groupList != null) {
          if (provider.groupList.isNotEmpty) {
            List<GroupModel> groups = provider.groupList;
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
                      // return Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: buildCustomListTile(context, groupItem));
                      return buildGroupCard(size, groupItem);
                    }),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  child: Text(
                    "Eşleşen bir grup bulunmuyor.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: kPageCenteredTextSize),
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

  buildGroupCard(Size size, GroupModel group) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          NavigationService.instance
              .navigate(k_ROUTE_GROUP_DETAIL, args: group);
        },
        child: Container(
          height: size.height * 0.15,
          child: Card(
            color: Colors.grey[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0.1,
                ),
                Container(
                  height: size.height * 0.10,
                  width: size.width * 0.25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            group.groupProfilePicture),
                      )),
                ),
                SizedBox(
                  width: size.width * 0.08,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: Text(
                        group.groupName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.4,
                      child: Text(
                        group.groupSubtitle,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildCustomListTile(BuildContext context, GroupModel group) {
    return GestureDetector(
      onTap: () {
        NavigationService.instance.navigate(k_ROUTE_GROUP_DETAIL, args: group);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: group.groupProfilePicture,
            placeholder: (context, url) => Center(
              child: spinkit,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageBuilder) {
              return CircleAvatar(
                radius: 50,
                backgroundImage: imageBuilder,
              );
            },
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(group.groupName, style: TextStyle(fontSize: 24)),
                  SizedBox(height: 5),
                  Text(group.groupSubtitle, style: TextStyle(fontSize: 16))
                ],
              ),
            ),
          ),
        ],
      ),
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