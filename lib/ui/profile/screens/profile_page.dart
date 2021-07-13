import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/profile/widgets/drawer.dart';
import 'package:dodact_v1/ui/profile/widgets/profile_info_part.dart'
    as ProfileInfo;
import 'package:dodact_v1/ui/profile/widgets/profile_posts_part.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage>
    with SingleTickerProviderStateMixin {
  UserProvider _userProvider;

  TabController _controller;

  @override
  void initState() {
    _controller = new TabController(length: 3, vsync: this);

    _userProvider = getProvider<UserProvider>();
    _userProvider.getCurrentUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context);
    // EventRepository()
    //     .getUserEvents(authProvider.currentUser)
    //     .then((value) => print(value));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: ProfileDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Profil",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfo.ProfileInfoPart(),
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Paylaşımlar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 15),
              //   child: Container(
              //     height: 1,
              //     color: Colors.grey.shade300,
              //     width: dynamicWidth(0.90),
              //   ),
              // ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: TabBar(
                      labelColor: Colors.black,
                      controller: _controller,
                      tabs: const [
                        const Tab(text: "Müzik"),
                        const Tab(text: "Resim"),
                        const Tab(text: "Tiyatro"),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(controller: _controller, children: [
                        ProfilePostsPart(),
                        ProfilePostsPart(),
                        ProfilePostsPart(),
                      ]),
                    ),
                  ),
                ],
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
