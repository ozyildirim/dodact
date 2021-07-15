import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/ui/common_widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends BaseState<ProfileSettingsPage> {
  TextEditingController _emailController;
  TextEditingController _nameSurnameController;
  String nameSurname;

  @override
  void initState() {
    super.initState();
    nameSurname = authProvider.currentUser.nameSurname != null
        ? authProvider.currentUser.nameSurname
        : "Belirtilmemiş";
    _emailController =
        TextEditingController(text: authProvider.currentUser.email);

    _nameSurnameController = TextEditingController(text: nameSurname);

    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Profil Ayarları",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profilePicturePart(),
            Text("E-posta Adresin"),
            TextFieldContainer(
              width: mediaQuery.size.width * 0.6,
              child: TextField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            Text("Ad - Soyad"),
            TextFieldContainer(
              width: mediaQuery.size.width * 0.6,
              child: TextField(
                controller: _nameSurnameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilePicturePart() {
    return Container(
      height: 250,
      width: double.infinity,
      child: Center(
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 200,
              height: 200,
              child: Image.network(
                authProvider.currentUser.profilePictureURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 160,
            child: InkWell(
              onTap: () {},
              child: GFBadge(
                size: 60,
                child: Icon(FontAwesome5Solid.camera,
                    color: Colors.white, size: 20),
                shape: GFBadgeShape.circle,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
