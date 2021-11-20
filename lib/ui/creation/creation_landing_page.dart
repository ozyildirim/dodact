import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/ui/creation/creation_menu_page.dart';
import 'package:dodact_v1/ui/creation/user_application_page.dart';
import 'package:flutter/material.dart';

class CreationLandingPage extends StatefulWidget {
  @override
  State<CreationLandingPage> createState() => _CreationLandingPageState();
}

class _CreationLandingPageState extends BaseState<CreationLandingPage> {
  initState() {
    super.initState();
  }

  doesUserHasPermission() {
    if (userProvider.currentUser.permissions['create_stream'] ||
        userProvider.currentUser.permissions['create_post'] ||
        userProvider.currentUser.permissions['create_event']) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (doesUserHasPermission())
      return CreationMenuPage();
    else
      return UserApplicationMenuPage();
  }
}
