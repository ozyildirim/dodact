import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/invitation_model.dart';
import 'package:dodact_v1/provider/invitation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class UserNotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesome5Regular.check_square),
          )
        ],
        title: Text("Bildirimlerim"),
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
        child: buildBody(),
      ),
    );
  }

  buildBody() {
    return Column(
      children: [
        UserInvitationsPart(),
        Divider(thickness: 1),
      ],
    );
  }
}

class UserInvitationsPart extends StatefulWidget {
  @override
  State<UserInvitationsPart> createState() => _UserInvitationsPartState();
}

class _UserInvitationsPartState extends BaseState<UserInvitationsPart> {
  List<InvitationModel> userInvitations;
  InvitationProvider invitationProvider;

  @override
  initState() {
    super.initState();
    invitationProvider =
        Provider.of<InvitationProvider>(context, listen: false);
    invitationProvider.getUsersInvitations(authProvider.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<InvitationProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        // enabled: false,
        onTap: () {
          NavigationService.instance.navigate(k_ROUTE_USER_INVITATIONS_PAGE);
        },
        leading: CircleAvatar(
            backgroundColor: Colors.orangeAccent,
            radius: 40,
            child: Text(
              provider.usersInvitations.length < 10
                  ? provider.usersInvitations.length.toString()
                  : "10 +",
              style: TextStyle(color: Colors.black, fontSize: 20),
            )),
        title: Text("Davetler", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
