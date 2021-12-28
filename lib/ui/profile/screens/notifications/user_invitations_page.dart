import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/invitation_provider.dart';
import 'package:dodact_v1/ui/profile/screens/notifications/invitations/user_group_invitations_part.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInvitationsPage extends StatefulWidget {
  @override
  State<UserInvitationsPage> createState() => _UserInvitationsPageState();
}

class _UserInvitationsPageState extends BaseState<UserInvitationsPage> {
  var groupInvitations;

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<InvitationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Davetler'),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              UserGroupInvitationsPart(provider.usersInvitations),
            ],
          )),
    );
  }
}
