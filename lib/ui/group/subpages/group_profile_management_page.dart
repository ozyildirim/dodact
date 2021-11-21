import 'dart:io';

import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GroupProfileManagementPage extends StatefulWidget {
  @override
  State<GroupProfileManagementPage> createState() =>
      _GroupProfileManagementPageState();
}

class _GroupProfileManagementPageState
    extends BaseState<GroupProfileManagementPage> {
  Logger logger = Logger();
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  GroupProvider groupProvider;
  PickedFile groupProfilePicture;
  GroupModel group;

  bool isChanged = false;

  FocusNode groupNameFocus = new FocusNode();
  FocusNode groupDescriptionFocus = new FocusNode();

  initState() {
    super.initState();
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    group = groupProvider.group;
  }

  dispose() {
    groupNameFocus.dispose();
    groupDescriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GroupProvider>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: isChanged
          ? FloatingActionButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                updateGroup();
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
        title: Text('Profil Yönetimi'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    profilePicturePart(),
                    Text("Topluluk Adı",
                        style: TextStyle(fontSize: kSettingsTitleSize)),
                    TextFieldContainer(
                      width: size.width * 0.9,
                      child: FormBuilderTextField(
                        name: "groupName",
                        initialValue: group.groupName,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (group.groupName != value) {
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
                          FormBuilderValidators.required(context,
                              errorText: "Bu alan boş bırakılamaz"),
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          }
                        ]),
                      ),
                    ),
                    Row(
                      children: [
                        Text("Topluluk Tanıtım Yazısı",
                            style: TextStyle(fontSize: kSettingsTitleSize)),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.help, size: 16),
                        )
                      ],
                    ),
                    TextFieldContainer(
                      width: size.width * 0.9,
                      child: FormBuilderTextField(
                        name: "groupSubtitle",
                        initialValue: group.groupSubtitle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (group.groupDescription != value) {
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
                          FormBuilderValidators.required(context,
                              errorText: "Bu alan boş bırakılamaz"),
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          }
                        ]),
                      ),
                    ),
                    Text(
                      "Lokasyon",
                      style: TextStyle(fontSize: kSettingsTitleSize),
                    ),
                    TextFieldContainer(
                      width: size.width * 0.9,
                      child: FormBuilderDropdown(
                        name: "location",
                        initialValue: group.groupLocation,
                        items: cities
                            .map((city) => DropdownMenuItem(
                                  value: city,
                                  child: Text('$city'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (group.groupLocation != value) {
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
                          FormBuilderValidators.required(context,
                              errorText: "Bu alan boş bırakılamaz"),
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          }
                        ]),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.location_city),
                        ),
                      ),
                    ),
                    Text("Topluluk Açıklaması",
                        style: TextStyle(fontSize: kSettingsTitleSize)),
                    TextFieldContainer(
                      width: size.width * 0.9,
                      child: FormBuilderTextField(
                        minLines: 2,
                        maxLines: 5,
                        name: "groupDescription",
                        initialValue: group.groupDescription,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (group.groupName != value) {
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
                          FormBuilderValidators.required(context,
                              errorText: "Bu alan boş bırakılamaz"),
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          }
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profilePicturePart() {
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
                groupProvider.group.groupProfilePicture,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 160,
            child: InkWell(
              onTap: () {
                takePhotoFromGallery();
              },
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

  void takePhotoFromGallery() async {
    var newImage =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (newImage != null) {
      await updateProfilePhoto(newImage);
      NavigationService.instance.pop();
    } else {
      print("Kullanıcı fotoğraf seçmekten vazgeçti.");
    }
  }

  void updateProfilePhoto(PickedFile file) async {
    CommonMethods().showLoaderDialog(context, "Fotoğrafın Değiştiriliyor.");

    try {
      var url = await UploadService().uploadGroupProfilePhoto(
          groupID: groupProvider.group.groupId, fileToUpload: File(file.path));

      await groupProvider.updateGroup(
          groupProvider.group.groupId, {'groupProfilePicture': url});
    } catch (e) {
      logger.e(e);
    }
  }

  void updateGroup() async {
    if (formKey.currentState.saveAndValidate()) {
      try {
        CommonMethods().showLoaderDialog(context, "Değişiklikler Kaydediliyor");
        await groupProvider.updateGroup(group.groupId, {
          'groupName':
              formKey.currentState.value['groupName'].toString().trim(),
          'groupSubtitle':
              formKey.currentState.value['groupSubtitle'].toString().trim(),
          'groupLocation': formKey.currentState.value['location'].toString(),
          'groupDescription':
              formKey.currentState.value['groupDescription'].toString().trim(),
        });
        NavigationService.instance.pop();
        setState(() {
          isChanged = false;
        });
      } catch (e) {
        CommonMethods().showErrorDialog(
            context, "Değişiklikler kaydedilirken bir hata oluştu");
      }
    } else {}
  }
}
