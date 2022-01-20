import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/application_model.dart';
import 'package:dodact_v1/provider/application_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class UserApplicationHistoryPage extends StatefulWidget {
  @override
  State<UserApplicationHistoryPage> createState() =>
      _UserApplicationHistoryPageState();
}

class _UserApplicationHistoryPageState
    extends BaseState<UserApplicationHistoryPage> {
  @override
  Widget build(BuildContext context) {
    // var applicationProvider = Provider.of<ApplicationProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Başvuru Geçmişi'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        height: size.height,
        width: double.infinity,
        child: buildApplicationList(),
      ),
    );
  }

  buildApplicationList() {
    var applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    return FutureBuilder(
        future: applicationProvider
            .getUserApplications(userProvider.currentUser.uid),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: spinkit);
          } else if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(
                child: Text('Başvurun bulunmuyor',
                    style: TextStyle(fontSize: kPageCenteredTextSize)),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    ApplicationModel applicationItem = snapshot.data[index];
                    return buildListTile(applicationItem);
                  });
            }
          } else {
            return Center(
              child: Text(
                'Bir hata oluştu',
                style: TextStyle(fontSize: kPageCenteredTextSize),
              ),
            );
          }
        });
  }

  buildListTile(ApplicationModel applicationItem) {
    var type = applicationItem.applicationType == 'Content_Creator'
        ? 'İçerik Üretici Başvurusu'
        : applicationItem.applicationType == 'Event_Creator'
            ? 'Etkinlik Üretici Başvurusu'
            : applicationItem.applicationType == 'Group'
                ? 'Topluluk Başvurusu'
                : applicationItem.applicationType == 'Streamer'
                    ? "Yayıncı Başvurusu"
                    : "";

    var status = applicationItem.status == 'PENDING'
        ? 'Beklemede'
        : applicationItem.status == 'REJECTED'
            ? 'Reddedildi'
            : applicationItem.status == 'APPROVED'
                ? 'Onaylandı'
                : '';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(type),
        subtitle: Text(status),
        trailing: applicationItem.status == "PENDING"
            ? TextButton(
                onPressed: () {
                  deleteUserApplication(applicationItem.applicationId);
                },
                child: Text("İptal", style: TextStyle(color: Colors.black)),
              )
            : applicationItem.status == "REJECTED"
                ? IconButton(
                    color: Colors.red,
                    onPressed: () {
                      showStatusInfo(applicationItem, status);
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.red,
                    ),
                  )
                : applicationItem.status == "APPROVED"
                    // ignore: missing_required_param
                    ? IconButton(
                        color: Colors.green,
                        icon: Icon(
                          Icons.done_outlined,
                          color: Colors.green,
                        ),
                      )
                    : null,
      ),
    );
  }

  showStatusInfo(ApplicationModel application, String status) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Başvuru Durumu'),
            content: Text(application.rejectionReason),
            actions: <Widget>[
              FlatButton(
                child: Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  deleteUserApplication(String applicationId) async {
    var applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
    try {
      await applicationProvider.cancelApplication(
          userProvider.currentUser.uid, applicationId);

      setState(() {});
      showSnackbar('Başvurun iptal edildi');
    } catch (e) {
      showSnackbar('Bir hata oluştu');
    }
  }

  showSnackbar(String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 4,
    );
  }
}
