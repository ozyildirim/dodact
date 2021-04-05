import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backwardsCompatibility: false,
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

  void _navigateToLanding() {
    Future.delayed(Duration(milliseconds: 300), () {
      NavigationService.instance.navigateToReset('/home');
    });
  }
}
