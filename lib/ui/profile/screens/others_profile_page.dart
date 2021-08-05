import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile_info_part.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile_posts_part.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OthersProfilePage extends StatefulWidget {
  String otherUserID;
  OthersProfilePage({this.otherUserID});

  @override
  _OthersProfilePageState createState() => _OthersProfilePageState();
}

class _OthersProfilePageState extends BaseState<OthersProfilePage>
    with SingleTickerProviderStateMixin {
  String otherUserID;
  UserObject otherUser;

  TabController controller;

  @override
  void initState() {
    otherUserID = widget.otherUserID;
    Provider.of<UserProvider>(context, listen: false).getOtherUser(otherUserID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
      ),
      body: provider.otherUser == null
          ? Center(
              child: spinkit,
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(kBackgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    OthersProfileInfoPart(),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Paylaşımları",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    Container(
                      height: 300,
                      child: OthersProfilePostsPart(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
