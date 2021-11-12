import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/base/base_state.dart';
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
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu kullanıcıyı bildirmek istediğinden emin misin?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await reportUser(otherUser.uid);
          NavigationService.instance.pop();
        });
  }

  Future<void> reportUser(String userId) async {
    var reportReason = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => reportReasonDialog(context),
    );
    if (reportReason != null) {
      CommonMethods()
          .showLoaderDialog(context, "İşleminiz gerçekleştiriliyor.");
      await FirebaseReportService()
          .reportUser(authProvider.currentUser.uid, otherUser.uid, reportReason)
          .then((value) {
        CommonMethods().showInfoDialog(context, "İşlem Başarılı", "");
        NavigationService.instance.pop();
        NavigationService.instance.pop();
      }).catchError((value) {
        CommonMethods()
            .showErrorDialog(context, "İşlem gerçekleştirilirken hata oluştu.");
        NavigationService.instance.pop();
      });
    } else {
      NavigationService.instance.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                            leading: Icon(FontAwesome5Solid.flag),
                            title: Text("Bildir"),
                            onTap: () async {
                              await _showReportUserDialog();
                            }),
                      ),
                    ])
          ],
        ),
        body: provider.otherUser == null
            ? Center(
                child: spinkit,
              )
            : OtherUserProfileSubpage(otherUser));
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
