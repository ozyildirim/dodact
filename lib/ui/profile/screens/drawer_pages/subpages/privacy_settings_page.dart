import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends BaseState<PrivacySettingsPage> {
  bool hiddenMail;
  bool hiddenLocation;

  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    hiddenMail = userProvider.currentUser.privacySettings['hide_mail'];
    hiddenLocation = userProvider.currentUser.privacySettings['hide_location'];
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
                  Icon(Icons.save),
                ],
              ),
            )
          : null,
      appBar: AppBar(
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

              // SwitchListTile(
              //   title: Text('Salih"e kız bul'),
              //   value: ornekAyar4,
              //   onChanged: (value) {
              //     setState(() {
              //       ornekAyar4 = !ornekAyar4;
              //     });
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUser() async {
    try {
      CommonMethods().showLoaderDialog(context, "Değişiklikler kaydediliyor.");
      await userProvider.updateCurrentUser({
        'privacySettings': {
          'hide_mail': hiddenMail,
          'hide_location': hiddenLocation,
        }
      });
      userProvider.currentUser.privacySettings['hide_mail'] = hiddenMail;
      userProvider.currentUser.privacySettings['hide_location'] =
          hiddenLocation;

      NavigationService.instance.pop();
      setState(() {
        _isChanged = false;
      });
    } catch (e) {
      CommonMethods().showErrorDialog(
          context, "Değişiklikler kaydedilirken bir hata oluştu");
    }
  }
}
