import 'dart:io';

import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

enum Content { Goruntu, Video, Ses }
enum Category { Tiyatro, Resim, Muzik, Dans }
enum Source { Telefon, Youtube }

class PostCreationPage extends StatefulWidget {
  String contentType;

  PostCreationPage({this.contentType});

  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends BaseState<PostCreationPage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  PostProvider _postProvider;

  bool isSelected = false;
  bool isLoading = false;
  bool isUploaded = false;

  TextEditingController _postTitleController;
  TextEditingController _postDescriptionController;
  TextEditingController _postContentUrlController;

  FocusNode _postTitleFocus = new FocusNode();
  FocusNode _postDescriptionFocus = new FocusNode();
  FocusNode _postContentUrlFocus = new FocusNode();

  File postFile;
  String youtubeLink;

  @override
  void initState() {
    print(widget.contentType);
    super.initState();
    _postProvider = Provider.of<PostProvider>(context, listen: false);
    _postProvider.clearNewPost();

    //Implement new post features into variable.
    _postProvider.newPost.postContentType = widget.contentType;

    if (widget.contentType == "Video") {
      _postProvider.newPost.isVideo = true;
      _postProvider.newPost.isLocatedInYoutube = true;
    }

    _postTitleController = new TextEditingController();
    _postDescriptionController = new TextEditingController();
    _postContentUrlController = new TextEditingController();
  }

  @override
  void dispose() {
    _postTitleFocus.dispose();
    _postDescriptionFocus.dispose();
    _postContentUrlFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8,
        title: Text("İçerik"),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(children: [
              Container(
                  color: Colors.blueAccent,
                  height: 200,
                  width: double.infinity),
              _buildPrevivewPart(),
            ]),
            Expanded(
              flex: 3,
              child: FormBuilder(
                key: _formKey,
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: const Offset(
                              1.0,
                              1.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                          ),
                        ],
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FormBuilderTextField(
                        textInputAction: TextInputAction.next,
                        focusNode: _postTitleFocus,
                        name: "postTitle",
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.people_alt_sharp,
                            color: kPrimaryColor,
                          ),
                          hintText: "İçerik Başlığı",
                          hintStyle: TextStyle(fontFamily: kFontFamily),
                          border: InputBorder.none,
                        ),
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context)],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: const Offset(
                              1.0,
                              1.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                          ),
                        ],
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FormBuilderTextField(
                        textInputAction: TextInputAction.next,
                        focusNode: _postDescriptionFocus,
                        name: "postDescription",
                        maxLines: 3,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.people_alt_sharp,
                            color: kPrimaryColor,
                          ),
                          hintText: "İçerik Açıklaması",
                          hintStyle: TextStyle(fontFamily: kFontFamily),
                          border: InputBorder.none,
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                      ),
                    ),
                    provider.newPost.postContentType == "Video"
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: const Offset(
                                    1.0,
                                    1.0,
                                  ),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.5,
                                ),
                              ],
                              color: kPrimaryLightColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FormBuilderTextField(
                              textInputAction: TextInputAction.next,
                              focusNode: _postContentUrlFocus,
                              name: "youtubeLink",
                              maxLines: 1,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              cursorColor: kPrimaryColor,
                              controller: _postContentUrlController,
                              onEditingComplete: () {
                                setState(() {
                                  youtubeLink = _postContentUrlController.text;
                                });
                              },
                              decoration: InputDecoration(
                                icon: Icon(
                                  FontAwesome5Brands.youtube,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Youtube Linki",
                                hintStyle: TextStyle(fontFamily: kFontFamily),
                                border: InputBorder.none,
                              ),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    _formSubmit();
                  },
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 25,
                      child: Icon(
                        Icons.navigate_next,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPrevivewPart() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        height: 250,
        width: 250,
        decoration: youtubeLink != null
            ? BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    CommonMethods.createThumbnailURL(true, youtubeLink),
                  ),
                ),
              )
            : null,
        child: youtubeLink != null
            ? Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    FontAwesome5Brands.youtube,
                    color: Colors.red,
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesome5Solid.upload),
                    ),
                    Text("İçerik Seç")
                  ],
                ),
              ),
      ),
    );
  }

  // //TODO: Thumbnail package ekle
  //   Future<bool> uploadPost() async {
  //     String categoryString = "";
  //     for (var categoryItem in categoryMap) {
  //       if (categoryItem["category"] == category) {
  //         categoryString = categoryItem["text"];
  //         break;
  //       }
  //     }

  //     try {
  //       newPost.postId = "";
  //       newPost.userOrGroup = true;
  //       newPost.ownerId = authProvider.currentUser.uid;
  //       newPost.postCategory = categoryString;
  //       newPost.postTitle = _postTitleController.text;
  //       newPost.postDescription = _postDescriptionController.text;
  //       newPost.postContentURL = _postContentUrlController.text != null
  //           ? _postContentUrlController.text
  //           : null;
  //       newPost.claps = 0;
  //       newPost.isVideo = content == Content.Video ? true : false;
  //       newPost.isLocatedInYoutube = source == Source.Youtube ? true : false;

  //       await Provider.of<PostProvider>(context, listen: false)
  //           .addPost(post: newPost, postFile: postFile);
  //     } catch (e) {} //
  //   }

  void _selectFile(FileType selectedType) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: selectedType,
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
      setState(() {
        isSelected = true;
        postFile = file;
      });
      print("Content picked");
    } else {
      print("User closed the picker");
    }
  }

  void _formSubmit() {}
}

class PostCategoryPart extends StatefulWidget {
  @override
  _PostCategoryPartState createState() => _PostCategoryPartState();
}

class _PostCategoryPartState extends State<PostCategoryPart> {
  Category category;
  List<Map<String, dynamic>> categoryMap;
  int _choiceIndex;

  @override
  void initState() {
    categoryMap = [
      {
        'category': Category.Tiyatro,
        'text': "Tiyatro",
        'icon': Icon(FontAwesome5Solid.theater_masks)
      },
      {
        'category': Category.Resim,
        'text': "Resim",
        'icon': Icon(FontAwesome5Solid.image)
      },
      {
        'category': Category.Muzik,
        'text': "Müzik",
        'icon': Icon(FontAwesome5Solid.music)
      },
      {
        'category': Category.Dans,
        'text': "Dans",
        'icon': Icon(FontAwesome5Solid.skating)
      }
    ];
    super.initState();
    _choiceIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    print("Category built.");
    final provider = Provider.of<PostProvider>(context, listen: false);
    print(provider.newPost.toString());
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryMap.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
                onSelected: (selected) {
                  provider.newPost.postCategory = categoryMap[index]['text'];
                  setState(() {
                    _choiceIndex = selected ? index : 0;
                  });
                },
                avatar: categoryMap[index]['icon'],
                label: Text(categoryMap[index]["text"]),
                selected: _choiceIndex == index,
                selectedColor: Theme.of(context).accentColor),
          );
        },
      ),
    );
  }
}

class PostSourcePart extends StatefulWidget {
  @override
  _PostSourcePartState createState() => _PostSourcePartState();
}

class _PostSourcePartState extends State<PostSourcePart> {
  Source source;
  List<Map<String, dynamic>> sourceMap;

  int _choiceIndex;

  @override
  void initState() {
    super.initState();
    sourceMap = [
      {
        'source': Source.Telefon,
        'text': "Telefon Hafızası",
        'icon': Icon(Icons.storage)
      },
      {
        'source': Source.Youtube,
        'text': "Youtube",
        'icon': Icon(FontAwesome5Brands.youtube)
      },
    ];
    _choiceIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    print("Source built.");

    //Yüklenecek içerik video ise sourceMap içerisinden "telefon hafızası" seçeneğini çıkarıyoruz.

    return Selector<PostProvider, PostModel>(
      selector: (_, provider) => provider.newPost,
      builder: (_, object, __) {
        if (object.postContentType == "Video") {
          sourceMap.remove(
            {
              'source': Source.Telefon,
              'text': "Telefon Hafızası",
              'icon': Icon(Icons.storage)
            },
          );
        }
        return Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sourceMap.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChoiceChip(
                    onSelected: (bool value) {
                      if (sourceMap[index]['source'] == Source.Youtube) {
                        object.isLocatedInYoutube = true;
                      } else {
                        object.isLocatedInYoutube = false;
                      }
                      setState(() {
                        _choiceIndex = value ? index : 0;
                      });
                    },
                    avatar: sourceMap[index]['icon'],
                    label: Text(sourceMap[index]["text"]),
                    selected: _choiceIndex == index,
                    selectedColor: Theme.of(context).accentColor),
              );
            },
          ),
        );
      },
    );
  }
}
