import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsPage extends StatefulWidget {
  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState
    extends BaseState<NotificationsSettingsPage> {
  bool _isChanged = false;
  Map<String, dynamic> notificationSettings;

  @override
  void initState() {
    super.initState();
    notificationSettings = userProvider.currentUser.notificationSettings;
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("Bildirimler"),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: SwitchListTile(
                    title: Text(
                      'Beğeni Bildirimleri',
                      style: TextStyle(fontSize: kSettingsTitleSize),
                    ),
                    subtitle: Text(
                        "İçeriklerine gelen beğeniler sonucu bildirim almayı önlemek için aktive edebilirsin."),
                    value:
                        notificationSettings['allow_post_like_notifications'],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings['allow_post_like_notifications'] =
                            !notificationSettings[
                                'allow_post_like_notifications'];
                        _isChanged = true;
                      });
                    },
                  ),
                ),
                Divider(),
                Container(
                  child: SwitchListTile(
                    title: Text(
                      'Yorum Bildirimleri',
                      style: TextStyle(fontSize: kSettingsTitleSize),
                    ),
                    subtitle: Text(
                        'İçeriklerine yapılan yorumlar sonucu bildirim almayı önlemek için aktive edebilirsin.'),
                    value: notificationSettings['allow_comment_notifications'],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings['allow_comment_notifications'] =
                            !notificationSettings[
                                'allow_comment_notifications'];
                        _isChanged = true;
                      });
                    },
                  ),
                ),
                Divider(),
                Container(
                  child: SwitchListTile(
                    title: Text(
                      'Özel Mesaj Bildirimleri',
                      style: TextStyle(fontSize: kSettingsTitleSize),
                    ),
                    subtitle: Text(
                        'Sana gelen özel mesajlar için bildirim almayı önlemek için aktive edebilirsin.'),
                    value: notificationSettings[
                        'allow_private_message_notifications'],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings[
                                'allow_private_message_notifications'] =
                            !notificationSettings[
                                'allow_private_message_notifications'];
                        _isChanged = true;
                      });
                    },
                  ),
                ),
                Divider(),
                Container(
                  child: SwitchListTile(
                    title: Text(
                      'Grup İçerikleri Yorum Bildirimleri',
                      style: TextStyle(fontSize: kSettingsTitleSize),
                    ),
                    subtitle: Text(
                        'Yöneticisi olduğun grupların içeriklerine yapılan yorumlar sonucu bildirim almayı önlemek için aktive edebilirsin.'),
                    value: notificationSettings[
                        'allow_group_comment_notifications'],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings[
                                'allow_group_comment_notifications'] =
                            !notificationSettings[
                                'allow_group_comment_notifications'];
                        _isChanged = true;
                      });
                    },
                  ),
                ),
                Divider(),
                Container(
                  child: SwitchListTile(
                    title: Text(
                      'Grup Davet Bildirimleri',
                      style: TextStyle(fontSize: kSettingsTitleSize),
                    ),
                    subtitle: Text(
                        'Gruplara davet edilmen sonucu bildirim almayı önlemek için aktive edebilirsin.'),
                    value: notificationSettings[
                        'allow_group_invitation_notifications'],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings[
                                'allow_group_invitation_notifications'] =
                            !notificationSettings[
                                'allow_group_invitation_notifications'];
                        _isChanged = true;
                      });
                    },
                  ),
                ),
                Divider(),
                Container(
                  child: SwitchListTile(
                    title: Text(
                      'Grup Duyuru Bildirimleri',
                      style: TextStyle(fontSize: kSettingsTitleSize),
                    ),
                    subtitle: Text(
                        'Dahil olduğun gruplar tarafından yapılan duyurular sonucu bildirim almayı önlemek için aktive edebilirsin.'),
                    value: notificationSettings[
                        'allow_group_announcement_notifications'],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings[
                                'allow_group_announcement_notifications'] =
                            !notificationSettings[
                                'allow_group_announcement_notifications'];
                        _isChanged = true;
                      });
                    },
                  ),
                ),
                Divider(),
                Container(
                  child: SwitchListTile(
                    title: Text(
                      'Grup İçerik Bildirimleri',
                      style: TextStyle(fontSize: kSettingsTitleSize),
                    ),
                    subtitle: Text(
                        'Dahil olduğun gruplar tarafından oluşturulan içerikler sonucu bildirim almayı önlemek için aktive edebilirsin.'),
                    value:
                        notificationSettings['allow_group_post_notifications'],
                    onChanged: (value) {
                      setState(() {
                        notificationSettings['allow_group_post_notifications'] =
                            !notificationSettings[
                                'allow_group_post_notifications'];
                        _isChanged = true;
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
      CommonMethods().showLoaderDialog(context, "Değişiklikler Kaydediliyor");
      await userProvider
          .updateCurrentUser({'notificationSettings': notificationSettings});
      userProvider.currentUser.notificationSettings = notificationSettings;

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
