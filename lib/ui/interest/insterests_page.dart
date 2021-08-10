import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends BaseState<InterestsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          actions: [
            IconButton(icon: Icon(Icons.info_outline), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  _navigateToLanding();
                })
          ],
        ),
        body: Container(),
      ),
    );
  }

  void _navigateToLanding() async {
    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
  }
}
