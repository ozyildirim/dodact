import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
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
  TabController _controller;

  @override
  void initState() {
    _controller = new TabController(length: 3, vsync: this);
    super.initState();
    authProvider.getUser();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context);
    // EventRepository()
    //     .getUserEvents(authProvider.currentUser)
    //     .then((value) => print(value));

    return Scaffold(
      drawer: ProfileDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profil",
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/app/app-background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileInfo.ProfileInfoPart(),
              Divider(),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Paylaşımların",
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.black),
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
              Container(
                height: 300,
                child: ProfilePostsPart(),
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
