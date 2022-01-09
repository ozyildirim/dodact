import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends BaseState<PrivacySettingsPage> {
  bool hiddenMail;
  bool hiddenLocation;
  bool hiddenEducation;
  bool hiddenProfession;

  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    hiddenMail = userProvider.currentUser.privacySettings['hide_mail'];
    hiddenLocation = userProvider.currentUser.privacySettings['hide_location'];
    hiddenEducation =
        userProvider.currentUser.privacySettings['hide_education'];
    hiddenProfession =
        userProvider.currentUser.privacySettings['hide_profession'];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      floatingActionButton: _isChanged
          ? FloatingActionButton(
              onPressed: () {
                updateUser();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check),
                ],
              ),
            )
          : null,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Gizlilik"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
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
              Container(
                child: SwitchListTile(
                  title: Text(
                    'E-Posta Adresimi Gizle',
                    style: TextStyle(fontSize: kSettingsTitleSize),
                  ),
                  subtitle: Text(
                      "E-posta adresinin profilinde görüntülenmesini önlemek için aktive edebilirsin."),
                  value: hiddenMail,
                  onChanged: (value) {
                    setState(() {
                      hiddenMail = !hiddenMail;
                      _isChanged = true;
                    });
                  },
                ),
              ),
              Divider(),
              Container(
                child: SwitchListTile(
                  title: Text(
                    'Lokasyonumu Gizle',
                    style: TextStyle(fontSize: kSettingsTitleSize),
                  ),
                  subtitle: Text(
                      'Lokasyonun profilinde görüntülenmesini önlemek için aktive edebilirsin.'),
                  value: hiddenLocation,
                  onChanged: (value) {
                    setState(() {
                      hiddenLocation = !hiddenLocation;
                      _isChanged = true;
                    });
                  },
                ),
              ),
              Divider(),
              Container(
                child: SwitchListTile(
                  title: Text(
                    'Mesleğimi Gizle',
                    style: TextStyle(fontSize: kSettingsTitleSize),
                  ),
                  subtitle: Text(
                      'Mesleğinin profilinde görüntülenmesini önlemek için aktive edebilirsin.'),
                  value: hiddenProfession,
                  onChanged: (value) {
                    setState(() {
                      hiddenProfession = !hiddenProfession;
                      _isChanged = true;
                    });
                  },
                ),
              ),
              Divider(),
              Container(
                child: SwitchListTile(
                  title: Text(
                    'Eğitim Durumunu Gizle',
                    style: TextStyle(fontSize: kSettingsTitleSize),
                  ),
                  subtitle: Text(
                      'Eğitim durumunun profilinde görüntülenmesini önlemek için aktive edebilirsin.'),
                  value: hiddenEducation,
                  onChanged: (value) {
                    setState(() {
                      hiddenEducation = !hiddenEducation;
                      _isChanged = true;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUser() async {
    try {
      CustomMethods().showLoaderDialog(context, "Değişiklikler Kaydediliyor");
      await userProvider.updateCurrentUser({
        'privacySettings': {
          'hide_mail': hiddenMail,
          'hide_location': hiddenLocation,
          'hide_education': hiddenEducation,
          'hide_profession': hiddenProfession,
        }
      });
      userProvider.currentUser.privacySettings['hide_mail'] = hiddenMail;
      userProvider.currentUser.privacySettings['hide_location'] =
          hiddenLocation;
      userProvider.currentUser.privacySettings['hide_education'] =
          hiddenEducation;
      userProvider.currentUser.privacySettings['hide_profession'] =
          hiddenProfession;

      Get.back();
      setState(() {
        _isChanged = false;
      });
      showSnackbar("Gizlilik tercihlerin başarıyla güncellendi.");
    } catch (e) {
      showSnackbar("Değişiklikler kaydedilirken bir hata oluştu.");
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
