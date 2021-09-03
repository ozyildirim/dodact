import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class UserSocialAccountsSettings extends StatefulWidget {
  @override
  _UserSocialAccountsSettingsState createState() =>
      _UserSocialAccountsSettingsState();
}

class _UserSocialAccountsSettingsState
    extends BaseState<UserSocialAccountsSettings> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  bool isChanged = false;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  FocusNode youtubeFocus = new FocusNode();
  FocusNode linkedInFocus = new FocusNode();
  FocusNode dribbbleFocus = new FocusNode();
  FocusNode soundCloudFocus = new FocusNode();
  FocusNode instagramFocus = new FocusNode();

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
            child: FormBuilder(
              key: formKey,
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
                    child: FormBuilderTextField(
                      name: "youtube",
                      focusNode: youtubeFocus,
                      initialValue: authProvider.currentUser.youtubeLink ?? "",
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.youtube),
                      ),
                      onChanged: (_) {
                        setState(() {
                          isChanged = true;
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(value);
                        },
                      ]),
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
                    child: FormBuilderTextField(
                      name: "linkedin",
                      focusNode: linkedInFocus,
                      initialValue: authProvider.currentUser.linkedInLink ?? "",
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.linkedin),
                      ),
                      onChanged: (_) {
                        setState(() {
                          isChanged = true;
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(value);
                        },
                      ]),
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
                    child: FormBuilderTextField(
                      name: "dribbble",
                      initialValue: authProvider.currentUser.dribbbleLink ?? "",
                      focusNode: dribbbleFocus,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.dribbble),
                      ),
                      onChanged: (_) {
                        setState(() {
                          isChanged = true;
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(value);
                        },
                      ]),
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
                    child: FormBuilderTextField(
                      name: "soundcloud",
                      focusNode: soundCloudFocus,
                      initialValue:
                          authProvider.currentUser.soundcloudLink ?? "",
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.soundcloud),
                      ),
                      onChanged: (_) {
                        setState(() {
                          isChanged = true;
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(value);
                        },
                      ]),
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
                    child: FormBuilderTextField(
                      name: "instagram",
                      focusNode: instagramFocus,
                      initialValue:
                          authProvider.currentUser.instagramUsername ?? "",
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.instagram),
                      ),
                      onChanged: (_) {
                        setState(() {
                          isChanged = true;
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(value);
                        },
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateUser() async {
    try {
      if (formKey.currentState.saveAndValidate()) {
        CommonMethods()
            .showLoaderDialog(context, "Değişiklikler kaydediliyor.");
        await authProvider.updateCurrentUser({
          'youtubeLink': formKey.currentState.value['youtubeLink'],
          'dribbbleLink': formKey.currentState.value['dribbble'],
          'linkedInLink': formKey.currentState.value['linkedInLink'],
          'soundcloudLink': formKey.currentState.value['soundCloudLink'],
        });
        NavigationService.instance.pop();
        setState(() {
          isChanged = false;
        });
      } else {
        CommonMethods().showErrorDialog(context, "Argo içerikli giriş mevcut!");
        setState(() {
          autoValidateMode = AutovalidateMode.always;
        });
      }
    } catch (e) {
      CommonMethods().showErrorDialog(
          context, "Değişiklikler kaydedilirken bir hata oluştu");
    }
  }
}
