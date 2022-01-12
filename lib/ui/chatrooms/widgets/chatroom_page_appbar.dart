import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatroomPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final UserObject user;

  ChatroomPageAppBar({this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Hero(
                tag: user.uid,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(k_ROUTE_OTHERS_PROFILE_PAGE, arguments: user);
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePictureURL),
                    maxRadius: 25,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(k_ROUTE_OTHERS_PROFILE_PAGE, arguments: user);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        user.nameSurname,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "@" + user.username,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              // Icon(
              //   Icons.more_vert,
              //   color: Colors.grey.shade700,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 1.2);
}
