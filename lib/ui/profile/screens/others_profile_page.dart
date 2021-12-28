import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_body.dart';
import 'package:dodact_v1/ui/profile/widgets/others_profile/others_profile_header.dart';
import 'package:dodact_v1/utilities/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class OthersProfilePage extends StatefulWidget {
  UserObject otherUser;
  OthersProfilePage({this.otherUser});

  @override
  _OthersProfilePageState createState() => _OthersProfilePageState();
}

class _OthersProfilePageState extends BaseState<OthersProfilePage>
    with SingleTickerProviderStateMixin {
  UserObject otherUser;

  TabController controller;

  @override
  void initState() {
    otherUser = widget.otherUser;
    Provider.of<UserProvider>(context, listen: false).setOtherUser(otherUser);
    super.initState();
  }

  void _showReportUserDialog() async {
    CustomMethods.showCustomDialog(
        context: context,
        title: "Bu kullanıcıyı bildirmek istediğinden emin misin?",
        confirmButtonText: "Evet",
        confirmActions: () async {
          await reportUser(otherUser.uid);
          NavigationService.instance.pop();
        });
  }

  Future<void> reportUser(String userId) async {
    bool result = await FirebaseReportService.checkUserHasSameReporter(
        reportedUserId: userId, reporterId: userProvider.currentUser.uid);

    if (result) {
      CustomMethods.showSnackbar(context, "Bu kullanıcıyı zaten bildirdin.");
    } else {
      var reportReason = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => reportReasonDialog(context),
      );
      if (reportReason != null) {
        try {
          NavigationService.instance.pop();
          await FirebaseReportService.reportUser(
              authProvider.currentUser.uid, otherUser.uid, reportReason);

          CustomMethods.showSnackbar(
              context, "Kullanıcı başarıyla bildirildi.");
        } catch (e) {
          NavigationService.instance.pop();
          CustomMethods.showSnackbar(
              context, "İşlem gerçekleştirilirken hata oluştu.");
        }
      } else {
        NavigationService.instance.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "@" + provider.otherUser.username,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            IconButton(
              onPressed: () {
                createChatroom(context, provider.otherUser.uid);
              },
              icon: Icon(Icons.message),
            ),
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) async {
                  if (value == 0) {
                    await _showReportUserDialog();
                  } else if (value == 1) {
                    await _showUnblockDialog();
                  } else if (value == 2) {
                    await _showBlockDialog();
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(FontAwesome5Solid.flag,
                                size: 16, color: Colors.black),
                            SizedBox(width: 14),
                            Text("Bildir",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      userProvider.currentUser.blockedUserList
                              .contains(otherUser.uid)
                          ? PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(FontAwesome5Solid.ban,
                                      size: 16, color: Colors.black),
                                  SizedBox(width: 14),
                                  Text("Engeli Kaldır",
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            )
                          : PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(FontAwesome5Solid.ban,
                                      size: 16, color: Colors.black),
                                  SizedBox(width: 14),
                                  Text("Engelle",
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            )
                    ])
          ],
        ),
        body: provider.otherUser == null
            ? Center(
                child: spinkit,
              )
            : OtherUserProfileSubpage(otherUser));
  }

  createChatroom(BuildContext context, String userId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    NavigationService.instance.navigate(k_ROUTE_CHATROOM_PAGE,
        args: [userProvider.currentUser.uid, userProvider.otherUser]);
  }

  _showUnblockDialog() {
    CustomMethods.showCustomDialog(
        context: context,
        title: "Bu kullanıcının engelini kaldırmak istediğinden emin misin?",
        confirmButtonText: "Evet",
        confirmActions: () async {
          unblockUser();
          NavigationService.instance.pop();
        });
  }

  unblockUser() async {
    try {
      await userProvider.unblockUser(otherUser.uid);
      CustomMethods.showSnackbar(context, "Kullanıcının engelini kaldırdın.");
    } catch (e) {
      CustomMethods.showSnackbar(
          context, "Kullanıcı engellenirken bir sorun oluştu.");
    }
  }

  _showBlockDialog() {
    CustomMethods.showCustomDialog(
        context: context,
        title: "Bu kullanıcı engellemek istediğinden emin misin?",
        confirmButtonText: "Evet",
        confirmActions: () async {
          await blockUser();
          NavigationService.instance.pop();
        });
  }

  blockUser() async {
    try {
      await userProvider.blockUser(otherUser.uid);
      CustomMethods.showSnackbar(context, "Kullanıcıyı engelledin.");
    } catch (e) {
      CustomMethods.showSnackbar(
          context, "Kullanıcı engellenirken bir sorun oluştu.");
    }
  }
}

class OtherUserProfileSubpage extends StatefulWidget {
  UserObject user;

  OtherUserProfileSubpage(this.user);

  @override
  _OtherUserProfileSubpageState createState() =>
      _OtherUserProfileSubpageState();
}

class _OtherUserProfileSubpageState extends State<OtherUserProfileSubpage> {
  UserObject user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), BlendMode.dstATop),
          image: AssetImage(kBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OthersProfileHeader(),
          ),
          Expanded(
            child: OthersProfileBody(user: user),
          ),
        ],
      ),
    );
  }
}
