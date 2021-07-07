import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/repository/event_repository.dart';
import 'package:dodact_v1/ui/profile/widgets/drawer.dart';
import 'package:dodact_v1/ui/profile/widgets/profile_event_part.dart';
import 'package:dodact_v1/ui/profile/widgets/profile_info_part.dart'
    as ProfileInfo;
import 'package:dodact_v1/ui/profile/widgets/profile_posts_part.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  UserProvider _userProvider;
  @override
  void initState() {
    _userProvider = getProvider<UserProvider>();
    _userProvider.getCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EventRepository()
        .getUserEvents(authProvider.currentUser)
        .then((value) => print(value));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        endDrawer: ProfileDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text("Profil"),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                  // ignore: deprecated_member_use
                  overflow: Overflow.visible,
                  fit: StackFit.passthrough,
                  children: [
                    Container(
                      height: 206,
                      decoration: BoxDecoration(
                          color: oxfordBlue,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50))),
                    ),
                    ProfileInfo.ProfileInfoPart()
                  ]),
              SizedBox(
                height: 130,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Popüler Paylaşımlar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  height: 1,
                  color: Colors.grey.shade300,
                  width: dynamicWidth(0.90),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 250.0,
                  child: ProfilePostsPart(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: Text(
              //     "Katıldığı Etkinlikler",
              //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              //     textAlign: TextAlign.start,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 15),
              //   child: Container(
              //     height: 1,
              //     color: Colors.grey.shade300,
              //     width: dynamicWidth(0.90),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: Container(
              //     height: 250,
              //     child: ProfileEventsPart(),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
