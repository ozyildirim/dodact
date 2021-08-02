import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends BaseState<PrivacySettingsPage> {
  bool _hiddenMail;
  bool _hiddenLocation;
  bool _hiddenNameSurname;

  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _hiddenMail = authProvider.currentUser.hiddenMail;
    _hiddenLocation = authProvider.currentUser.hiddenLocation;
    _hiddenNameSurname = authProvider.currentUser.hiddenNameSurname;
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
        child: Column(
          children: [
            SwitchListTile(
              title: Text('E-Posta Adresimi Gizle'),
              subtitle: Text(
                  "E-posta adresinizin profilinizde görüntülenmesini önlemek için aktive edin."),
              value: _hiddenMail,
              onChanged: (value) {
                setState(() {
                  _hiddenMail = !_hiddenMail;
                  _isChanged = true;
                });
              },
            ),
            SwitchListTile(
              title: Text('Lokasyonumu Gizle'),
              subtitle: Text(
                  'Lokasyonunuzun profilinizde görüntülenmesini önlemek için aktive edin.'),
              value: _hiddenLocation,
              onChanged: (value) {
                setState(() {
                  _hiddenLocation = !_hiddenLocation;
                  _isChanged = true;
                });
              },
            ),
            SwitchListTile(
              title: Text('Ad - Soyad Gizle'),
              subtitle: Text(
                  "Ad - Soyad bilgilerinizin profilinizde görüntülenmesini önlemek için aktive edin."),
              value: _hiddenNameSurname,
              onChanged: (value) {
                setState(() {
                  _hiddenNameSurname = !_hiddenNameSurname;
                  _isChanged = true;
                });
              },
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
    );
  }

  Future<void> updateUser() async {
    try {
      CommonMethods().showLoaderDialog(context, "Değişiklikler kaydediliyor.");
      await authProvider.updateCurrentUser({
        'hiddenMail': _hiddenMail,
        'hiddenLocation': _hiddenLocation,
        'hiddenNameSurname': _hiddenNameSurname,
      });
      authProvider.currentUser.hiddenMail = _hiddenMail;
      authProvider.currentUser.hiddenLocation = _hiddenLocation;
      authProvider.currentUser.hiddenNameSurname = _hiddenNameSurname;

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
