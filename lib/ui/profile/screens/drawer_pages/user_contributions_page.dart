import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/contribution_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserContributionsPage extends StatefulWidget {
  @override
  _UserContributionsPageState createState() => _UserContributionsPageState();
}

class _UserContributionsPageState extends BaseState<UserContributionsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ContributionProvider>(context, listen: false)
        .getUserContributions(authProvider.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContributionProvider>(context);

    createAvatar(String company) {
      switch (company) {
        case "DODACT":
          return kDodactLogo;
          break;

        case "TEMA":
          return kTemaLogo;
          break;

        default:
          break;
      }
    }

    buildListView() {
      return ListView.builder(
        itemCount: provider.contributions.length,
        itemBuilder: (context, index) {
          var item = provider.contributions[index];
          print(item);
          return GFListTile(
            avatar: GFAvatar(
              backgroundImage: AssetImage(
                createAvatar(item.contributedCompany),
              ),
            ),
            title: Text(
              item.contributedCompany,
              style: TextStyle(fontSize: 20),
            ),
            subTitleText: DateFormat('dd/MM/yy').format(item.creationDate),
          );
        },
      );
    }

    buildBody() {
      if (provider.contributions == null) {
        return Center(
          child: spinkit,
        );
      } else {
        if (provider.contributions.isEmpty) {
          return Center(
            child: Container(
              child: Text(
                "Henüz bir yardım bulunmamakta. \n\nSen de içerik ve etkinlik oluşturarak kurumlara/topluluklara yardım edebilirsin!",
                style: TextStyle(fontSize: kPageCenteredTextSize),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return buildListView();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Yardımlarım"),
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
}
