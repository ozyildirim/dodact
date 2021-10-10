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

  String instagram;
  String linkedIn;
  String dribbble;
  String soundCloud;
  String pinterest;
  String youtube;

  FocusNode youtubeFocus = new FocusNode();
  FocusNode linkedInFocus = new FocusNode();
  FocusNode dribbbleFocus = new FocusNode();
  FocusNode soundCloudFocus = new FocusNode();
  FocusNode instagramFocus = new FocusNode();
  FocusNode pinterestFocus = new FocusNode();

  @override
  void dispose() {
    youtubeFocus.dispose();
    linkedInFocus.dispose();
    dribbbleFocus.dispose();
    soundCloudFocus.dispose();
    pinterestFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    instagram = authProvider.currentUser.socialMediaLinks['instagram'];
    linkedIn = linkedIn = authProvider.currentUser.socialMediaLinks['linkedin'];
    youtube = authProvider.currentUser.socialMediaLinks['youtube'];
    dribbble = authProvider.currentUser.socialMediaLinks['dribbble'];
    soundCloud = authProvider.currentUser.socialMediaLinks['soundcloud'];
    pinterest = authProvider.currentUser.socialMediaLinks['pinterest'];
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
        title: Text("Sosyal Medya Hesapları"),
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
                  Text(
                    "Youtube",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFieldContainer(
                    width: mediaQuery.size.width * 0.9,
                    child: FormBuilderTextField(
                      name: "youtube",
                      focusNode: youtubeFocus,
                      initialValue: youtube,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.youtube),
                      ),
                      onChanged: (value) {
                        if (youtube != value) {
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
                  Text(
                    "LinkedIn",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFieldContainer(
                    width: mediaQuery.size.width * 0.9,
                    child: FormBuilderTextField(
                      name: "linkedin",
                      focusNode: linkedInFocus,
                      initialValue: linkedIn,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.linkedin),
                      ),
                      onChanged: (value) {
                        if (linkedIn != value) {
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
                  Text(
                    "Dribbble",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFieldContainer(
                    width: mediaQuery.size.width * 0.9,
                    child: FormBuilderTextField(
                      name: "dribbble",
                      initialValue: dribbble,
                      focusNode: dribbbleFocus,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.dribbble),
                      ),
                      onChanged: (value) {
                        if (dribbble != value) {
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
                  Text(
                    "Pinterest",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFieldContainer(
                    width: mediaQuery.size.width * 0.9,
                    child: FormBuilderTextField(
                      name: "pinterest",
                      initialValue: pinterest,
                      focusNode: pinterestFocus,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.pinterest),
                      ),
                      onChanged: (value) {
                        if (pinterest != value) {
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
                  Text(
                    "SoundCloud",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFieldContainer(
                    width: mediaQuery.size.width * 0.9,
                    child: FormBuilderTextField(
                      name: "soundcloud",
                      focusNode: soundCloudFocus,
                      initialValue: soundCloud,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.soundcloud),
                      ),
                      onChanged: (value) {
                        if (soundCloud != value) {
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
                  Text(
                    "Instagram Kullanıcı Adı",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextFieldContainer(
                    width: mediaQuery.size.width * 0.9,
                    child: FormBuilderTextField(
                      name: "instagram",
                      focusNode: instagramFocus,
                      initialValue: instagram,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesome5Brands.instagram),
                      ),
                      onChanged: (value) {
                        if (instagram != value) {
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
        var pinterestLink =
            formKey.currentState.value['pinterest'].toString().trim();

        CommonMethods()
            .showLoaderDialog(context, "Değişiklikler kaydediliyor.");
        await authProvider.updateCurrentUser({
          'socialMediaLinks': {
            'youtube': youtubeLink,
            'linkedin': linkedInLink,
            'dribbble': dribbbleLink,
            'soundcloud': soundCloudLink,
            'instagram': instagramUsername,
            'pinterest': pinterestLink,
          }
        }).then((value) {
          authProvider.currentUser.socialMediaLinks = {
            'youtube': youtubeLink,
            'linkedin': linkedInLink,
            'dribbble': dribbbleLink,
            'soundcloud': soundCloudLink,
            'instagram': instagramUsername,
            'pinterest': pinterestLink,
          };
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
