import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool mailGizlilik = false;
  bool ornekAyar2 = false;
  bool ornekAyar3 = false;
  bool ornekAyar4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gizlilik Ayarları"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Mail Adresini Gizle'),
              value: mailGizlilik,
              onChanged: (value) {
                setState(() {
                  mailGizlilik = !mailGizlilik;
                });
              },
            ),
            SwitchListTile(
              title: Text('Örnek Ayar'),
              value: ornekAyar2,
              onChanged: (value) {
                setState(() {
                  ornekAyar2 = !ornekAyar2;
                });
              },
            ),
            SwitchListTile(
              title: Text('Örnek Ayar'),
              value: ornekAyar3,
              onChanged: (value) {
                setState(() {
                  ornekAyar3 = !ornekAyar3;
                });
              },
            ),
            SwitchListTile(
              title: Text('Örnek Ayar'),
              value: ornekAyar4,
              onChanged: (value) {
                setState(() {
                  ornekAyar4 = !ornekAyar4;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
