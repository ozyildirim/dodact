import 'package:cloud_functions/cloud_functions.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendNotification(authProvider.currentUser.uid);
        },
        child: Icon(Icons.send),
      ),
      appBar: AppBar(
        actions: [],
        title: Text('Davetler'),
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

  sendNotification(String userId) async {
    debugPrint(userId);
    FirebaseFunctions firebaseFunctions = FirebaseFunctions.instance;
    // firebaseFunctions.useFunctionsEmulator("localhost", 5001);
    var callable = firebaseFunctions.httpsCallable('sendNotificationToUser');
    try {
      final HttpsCallableResult result = await callable.call(<String, dynamic>{
        'userId': userId,
      });
      print(result.data);
    } on FirebaseFunctionsException catch (e) {
      print('Firebase Functions Exception');
      print(e.code);
      print(e.message);
    } catch (e) {
      print('Caught Exception');
      print(e);
    }
  }
}
