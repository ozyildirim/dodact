import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/utilities/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:logger/logger.dart';

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

  String instagramUsername;
  String linkedIn;
  String twitter;
  String dribbble;
  String soundCloud;

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

    instagramUsername = authProvider.currentUser.instagramUsername != null
        ? authProvider.currentUser.instagramUsername
        : "";
    linkedIn = authProvider.currentUser.linkedInLink != null
        ? authProvider.currentUser.linkedInLink
        : "";
    twitter = authProvider.currentUser.twitterUsername != null
        ? authProvider.currentUser.twitterUsername
        : "";
    dribbble = authProvider.currentUser.dribbbleLink != null
        ? authProvider.currentUser.dribbbleLink
        : "";
    soundCloud = authProvider.currentUser.soundcloudLink != null
        ? authProvider.currentUser.soundcloudLink
        : "";
  }

  @override
  Widget build(BuildContext context) {
    Logger().i("Instagram: ${authProvider.currentUser.instagramUsername}");
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
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormBuilder(
              autovalidateMode: autoValidateMode,
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
                      onChanged: (value) {
                        if (authProvider.currentUser.youtubeLink != value) {
                          setState(() {
                            isChanged = true;
                          });
                        } else {
                          setState(() {
                            isChanged = false;
                          });
                        }
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(
                              value.trim());
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
                      onChanged: (value) {
                        if (authProvider.currentUser.linkedInLink != value) {
                          setState(() {
                            isChanged = true;
                          });
                        } else {
                          setState(() {
                            isChanged = false;
                          });
                        }
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(
                              value.trim());
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
                      onChanged: (value) {
                        if (authProvider.currentUser.dribbbleLink != value) {
                          setState(() {
                            isChanged = true;
                          });
                        } else {
                          setState(() {
                            isChanged = false;
                          });
                        }
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(
                              value.trim());
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
                      onChanged: (value) {
                        if (authProvider.currentUser.soundcloudLink != value) {
                          setState(() {
                            isChanged = true;
                          });
                        } else {
                          setState(() {
                            isChanged = false;
                          });
                        }
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(
                              value.trim());
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
                      initialValue: instagramUsername,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.instagram),
                      ),
                      onChanged: (value) {
                        if (authProvider.currentUser.instagramUsername !=
                            value) {
                          setState(() {
                            isChanged = true;
                          });
                        } else {
                          setState(() {
                            isChanged = false;
                          });
                        }
                      },
                      validator: FormBuilderValidators.compose([
                        (value) {
                          return ProfanityChecker.profanityValidator(
                              value.trim());
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
        var youtubeLink =
            formKey.currentState.value['youtube'].toString().trim();
        var linkedInLink =
            formKey.currentState.value['linkedin'].toString().trim();
        var dribbbleLink =
            formKey.currentState.value['dribbble'].toString().trim();
        var soundCloudLink =
            formKey.currentState.value['soundcloud'].toString().trim();
        var instagramUsername =
            formKey.currentState.value['instagram'].toString().trim();

        CommonMethods()
            .showLoaderDialog(context, "Değişiklikler kaydediliyor.");
        await authProvider.updateCurrentUser({
          'youtubeLink': youtubeLink,
          'dribbbleLink': dribbbleLink,
          'linkedInLink': linkedInLink,
          'soundcloudLink': soundCloudLink,
          'instagramUsername': instagramUsername,
        }).then((value) {
          authProvider.currentUser.youtubeLink = youtubeLink;
          authProvider.currentUser.dribbbleLink = dribbbleLink;
          authProvider.currentUser.linkedInLink = linkedInLink;
          authProvider.currentUser.soundcloudLink = soundCloudLink;
          authProvider.currentUser.instagramUsername = instagramUsername;
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
