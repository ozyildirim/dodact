import 'dart:io';

//TODO: Upload fonksiyonları yazılacak

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/components/button/gf_button.dart';

enum Content { Fotograf, Video, Ses }
enum Category { Tiyatro, Resim, Muzik, Dans }
enum Source { Telefon, Youtube }

class PostCreationPage extends StatefulWidget {
  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends BaseState<PostCreationPage> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  FocusNode categoryFocusNode = FocusNode();
  FocusNode contentTypeFocusNode = FocusNode();
  FocusNode sourceFocusNode = FocusNode();

  Content content;
  Category category;
  Source source;

  bool isSelected = false;
  bool isLoading = false;
  bool isUploaded = false;

  @override
  void initState() {
    categoryFocusNode = FocusNode();
    contentTypeFocusNode = FocusNode();
    sourceFocusNode = FocusNode();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    categoryFocusNode.dispose();
    contentTypeFocusNode.dispose();
    sourceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: FormBuilder(
              key: _formKey,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilderChoiceChip(
                          onChanged: (value) {
                            setState(() {
                              category = value;
                              content = null;
                              source = null;
                            });
                          },
                          focusNode: categoryFocusNode,
                          name: 'category_chip',
                          spacing: 5,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText:
                                  "Hangi alanda içerik oluşturmak istiyorsunuz?",
                              labelStyle: TextStyle(fontSize: 25)),
                          options: [
                            FormBuilderFieldOption(
                              value: Category.Muzik,
                              child: Text("Müzik"),
                            ),
                            FormBuilderFieldOption(
                              value: Category.Tiyatro,
                              child: Text("Tiyatro"),
                            ),
                            FormBuilderFieldOption(
                              value: Category.Dans,
                              child: Text("Dans"),
                            ),
                            FormBuilderFieldOption(
                              value: Category.Resim,
                              child: Text("Resim"),
                            ),
                          ]),
                    ),
                    category != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderChoiceChip(
                                onChanged: (value) {
                                  setState(() {
                                    content = value;
                                    source =
                                        null; //butonların kaybolması için yapıldı
                                  });
                                },
                                focusNode: categoryFocusNode,
                                name: 'content_type_chip',
                                spacing: 5,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText:
                                        "Ne tür içerik oluşturacaksınız?",
                                    labelStyle: TextStyle(fontSize: 25)),
                                options: [
                                  FormBuilderFieldOption(
                                    value: Content.Video,
                                    child: Text("Video"),
                                  ),
                                  FormBuilderFieldOption(
                                    value: Content.Fotograf,
                                    child: Text("Fotoğraf"),
                                  ),
                                  FormBuilderFieldOption(
                                    value: Content.Ses,
                                    child: Text("Ses"),
                                  ),
                                ]),
                          )
                        : Container(),
                    content == Content.Video
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderChoiceChip(
                                onChanged: (value) {
                                  setState(() {
                                    source = value;
                                  });
                                },
                                focusNode: sourceFocusNode,
                                name: 'source_chip',
                                spacing: 5,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText:
                                        "Hangi kaynaktan video yükleyeceksiniz?",
                                    labelStyle: TextStyle(fontSize: 25)),
                                options: [
                                  FormBuilderFieldOption(
                                    value: Source.Telefon,
                                    child: Text("Telefonumdan"),
                                  ),
                                  FormBuilderFieldOption(
                                    value: Source.Youtube,
                                    child: Text("Youtube"),
                                  ),
                                ]),
                          )
                        : Container(),
                    isSelected == true
                        ? Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(color: Colors.pinkAccent),
                            child: Center(child: Text("asd")),
                          )
                        : Container(),
                    content == Content.Fotograf
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GFButton(
                              onPressed: () async {
                                _selectPhoto();
                              },
                              child: Text("Fotoğraf Seç"),
                            ),
                          )
                        : Container(),
                    content == Content.Ses
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GFButton(
                              onPressed: () async {
                                _selectAudio();
                              },
                              child: Text("Ses Dosyası Seç"),
                            ),
                          )
                        : Container(),
                    source == Source.Telefon
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GFButton(
                              onPressed: () async {
                                _selectVideo();
                              },
                              child: Text("Video Seç"),
                            ),
                          )
                        : Container(),
                    isLoading == true
                        ? Container(
                            child: Center(
                              child: spinkit,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            )));
  }

  void pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        onFileLoading: (FilePickerStatus status) {
      if (status == FilePickerStatus.picking) {
        setState(() {
          isLoading == true;
        });
      } else {
        setState(() {
          isLoading == false;
        });
      }
    });

    if (result != null) {
      File file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }

  void _selectPhoto() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        onFileLoading: (FilePickerStatus status) {
          if (status == FilePickerStatus.picking) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });

    if (result != null) {
      File file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }

  void _selectVideo() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.video,
        onFileLoading: (FilePickerStatus status) {
          if (status == FilePickerStatus.picking) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });

    if (result != null) {
      File file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }

  void _selectAudio() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.audio,
        onFileLoading: (FilePickerStatus status) {
          if (status == FilePickerStatus.picking) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        });

    if (result != null) {
      File file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }
}
