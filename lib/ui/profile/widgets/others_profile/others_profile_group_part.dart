import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/common/widgets/group_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OthersProfileGroupsTab extends StatefulWidget {
  final UserObject user;

  const OthersProfileGroupsTab({this.user});

  @override
  _OthersProfileGroupsTabState createState() => _OthersProfileGroupsTabState();
}

class _OthersProfileGroupsTabState extends State<OthersProfileGroupsTab> {
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<GroupProvider>(context, listen: false);

    return FutureBuilder(
      future: provider.getUserGroups(widget.user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Herhangi bir topluluğa dahil değil",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: kPageCenteredTextSize),
                ),
              ),
            );
          } else {
            List<GroupModel> groups = snapshot.data;

            return ListView.builder(
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var groupItem = groups[index];
                  return Container(
                    child: GroupCard(group: groupItem),
                  );
                });
          }
        } else {
          return Center(child: spinkit);
        }
      },
    );
  }

  buildGroupCard(Size size, GroupModel group) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Get.toNamed(k_ROUTE_GROUP_DETAIL, arguments: group);
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
                          // fontFamily: "Poppins",
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
}
