import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class UserSocialAccountsSettings extends StatefulWidget {
  @override
  _UserSocialAccountsSettingsState createState() =>
      _UserSocialAccountsSettingsState();
}

class _UserSocialAccountsSettingsState
    extends BaseState<UserSocialAccountsSettings> {
  bool isChanged = false;

  FocusNode youtubeFocus = new FocusNode();
  FocusNode linkedInFocus = new FocusNode();
  FocusNode dribbbleFocus = new FocusNode();
  FocusNode soundCloudFocus = new FocusNode();
  FocusNode instagramFocus = new FocusNode();

  TextEditingController linkedInController = new TextEditingController();
  TextEditingController youtubeController = new TextEditingController();
  TextEditingController dribbbleController = new TextEditingController();
  TextEditingController soundCloudController = new TextEditingController();
  TextEditingController instagramController = new TextEditingController();

  @override
  void dispose() {
    youtubeFocus.dispose();
    linkedInFocus.dispose();
    dribbbleFocus.dispose();
    soundCloudFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    linkedInController =
        TextEditingController(text: authProvider.currentUser.linkedInLink);
    youtubeController =
        TextEditingController(text: authProvider.currentUser.youtubeLink);
    dribbbleController =
        TextEditingController(text: authProvider.currentUser.dribbbleLink);
    soundCloudController =
        TextEditingController(text: authProvider.currentUser.soundcloudLink);
    instagramController =
        TextEditingController(text: authProvider.currentUser.instagramUsername);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      floatingActionButton: isChanged
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
        title: Text("Sosyal Medya Hesap Ayarları"),
      ),
      body: Container(
        height: dynamicHeight(1),
        width: dynamicWidth(1),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(kBackgroundImage),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white70,
                  child: Text(
                    "Youtube",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFieldContainer(
                  width: mediaQuery.size.width * 0.9,
                  child: TextField(
                    focusNode: youtubeFocus,
                    controller: youtubeController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(FontAwesome5Brands.youtube),
                    ),
                    onChanged: (_) {
                      setState(() {
                        isChanged = true;
                      });
                    },
                  ),
                ),
                Container(
                  color: Colors.white70,
                  child: Text(
                    "LinkedIn",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFieldContainer(
                  width: mediaQuery.size.width * 0.9,
                  child: TextField(
                    focusNode: linkedInFocus,
                    controller: linkedInController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(FontAwesome5Brands.linkedin),
                    ),
                    onChanged: (_) {
                      setState(() {
                        isChanged = true;
                      });
                    },
                  ),
                ),
                Container(
                  color: Colors.white70,
                  child: Text(
                    "Dribbble",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFieldContainer(
                  width: mediaQuery.size.width * 0.9,
                  child: TextField(
                    focusNode: dribbbleFocus,
                    controller: dribbbleController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(FontAwesome5Brands.dribbble),
                    ),
                    onChanged: (_) {
                      setState(() {
                        isChanged = true;
                      });
                    },
                  ),
                ),
                Container(
                  color: Colors.white70,
                  child: Text(
                    "SoundCloud",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFieldContainer(
                  width: mediaQuery.size.width * 0.9,
                  child: TextField(
                    focusNode: soundCloudFocus,
                    controller: soundCloudController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(FontAwesome5Brands.soundcloud),
                    ),
                    onChanged: (_) {
                      setState(() {
                        isChanged = true;
                      });
                    },
                  ),
                ),
                Container(
                  color: Colors.white70,
                  child: Text(
                    "Instagram Kullanıcı Adı",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextFieldContainer(
                  width: mediaQuery.size.width * 0.9,
                  child: TextField(
                    focusNode: instagramFocus,
                    controller: instagramController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(FontAwesome5Brands.instagram),
                    ),
                    onChanged: (_) {
                      setState(() {
                        isChanged = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateUser() async {
    try {
      CommonMethods().showLoaderDialog(context, "Değişiklikler kaydediliyor.");
      await authProvider.updateCurrentUser({
        'youtubeLink': youtubeController.text,
        'dribbbleLink': dribbbleController.text,
        'linkedInLink': linkedInController.text,
        'soundcloudLink': soundCloudController.text,
      });
      NavigationService.instance.pop();
      setState(() {
        isChanged = false;
      });
    } catch (e) {
      CommonMethods().showErrorDialog(
          context, "Değişiklikler kaydedilirken bir hata oluştu");
    }
  }
}
