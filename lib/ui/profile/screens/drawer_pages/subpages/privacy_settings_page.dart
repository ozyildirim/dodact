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
  bool hiddenNameSurname;

  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    hiddenMail = authProvider.currentUser.hiddenMail;
    hiddenLocation = authProvider.currentUser.hiddenLocation;
    hiddenNameSurname = authProvider.currentUser.hiddenNameSurname;
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
        title: Text("Gizlilik Ayarları"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(kBackgroundImage),
            ),
          ),
          child: Column(
            children: [
              Container(
                color: Colors.white70,
                child: SwitchListTile(
                  title: Text(
                    'E-Posta Adresimi Gizle',
                    style: TextStyle(fontSize: kSettingsTitleSize),
                  ),
                  subtitle: Text(
                      "E-posta adresinizin profilinizde görüntülenmesini önlemek için aktive edin."),
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
                color: Colors.white70,
                child: SwitchListTile(
                  title: Text(
                    'Lokasyonumu Gizle',
                    style: TextStyle(fontSize: kSettingsTitleSize),
                  ),
                  subtitle: Text(
                      'Lokasyonunuzun profilinizde görüntülenmesini önlemek için aktive edin.'),
                  value: hiddenLocation,
                  onChanged: (value) {
                    setState(() {
                      hiddenLocation = !hiddenLocation;
                      _isChanged = true;
                    });
                  },
                ),
              ),
              Container(
                color: Colors.white70,
                child: SwitchListTile(
                  title: Text(
                    'Ad - Soyad Gizle',
                    style: TextStyle(fontSize: kSettingsTitleSize),
                  ),
                  subtitle: Text(
                      "Ad - Soyad bilgilerinizin profilinizde görüntülenmesini önlemek için aktive edin."),
                  value: hiddenNameSurname,
                  onChanged: (value) {
                    setState(() {
                      hiddenNameSurname = !hiddenNameSurname;
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
      await authProvider.updateCurrentUser({
        'hiddenMail': hiddenMail,
        'hiddenLocation': hiddenLocation,
        'hiddenNameSurname': hiddenNameSurname,
      });
      authProvider.currentUser.hiddenMail = hiddenMail;
      authProvider.currentUser.hiddenLocation = hiddenLocation;
      authProvider.currentUser.hiddenNameSurname = hiddenNameSurname;

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
