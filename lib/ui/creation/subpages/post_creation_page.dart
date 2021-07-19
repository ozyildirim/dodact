import 'dart:io';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

enum Content { Goruntu, Video, Ses }
enum Category { Tiyatro, Resim, Muzik, Dans }
enum Source { Telefon, Youtube }

class PostCreationPage extends StatefulWidget {
  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends BaseState<PostCreationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool isSelected = false;
  bool isLoading = false;
  bool isUploaded = false;

  List<Step> get steps => [
        new Step(
          title: const Text('Sanat Dalı'),
          //subtitle: const Text('Enter your name'),
          isActive: true,
          //state: StepState.error,
          state: StepState.indexed,
          content: PostCategoryPart(),
        ),
        new Step(
          title: const Text('İçerik Türü'),
          //subtitle: const Text('Subtitle'),
          isActive: true,
          //state: StepState.editing,
          state: StepState.indexed,
          content: PostContentPart(),
        ),
        new Step(
          title: const Text('Kaynak'),
          // subtitle: const Text('Subtitle'),
          isActive: true,
          state: StepState.indexed,
          // state: StepState.disabled,
          content: PostSourcePart(),
        ),
      ];
  int currStep = 0;

  static var _focusNode = new FocusNode();

  File postFile;
  String youtubeLink;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8,
        title: Text("İçerik"),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: new Container(
        child: new Form(
          key: _formKey,
          child: new ListView(children: <Widget>[
            new Stepper(
              steps: steps,
              type: StepperType.vertical,
              currentStep: this.currStep,
              onStepContinue: () {
                setState(() {
                  if (currStep < steps.length - 1) {
                    currStep = currStep + 1;
                  } else {
                    currStep = 0;
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (currStep > 0) {
                    currStep = currStep - 1;
                  } else {
                    currStep = 0;
                  }
                });
              },
              onStepTapped: (step) {
                setState(() {
                  currStep = step;
                });
              },
            ),
          ]),
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

class PostContentPart extends StatefulWidget {
  @override
  _PostContentPartState createState() => _PostContentPartState();
}

class _PostContentPartState extends State<PostContentPart> {
  Content content;
  List<Map<String, dynamic>> contentMap;

  int _choiceIndex;

  @override
  void initState() {
    super.initState();
    contentMap = [
      {
        'content': Content.Goruntu,
        'text': "Görüntü",
        'icon': Icon(FontAwesome5Solid.camera)
      },
      {
        'content': Content.Video,
        'text': "Video",
        'icon': Icon(FontAwesome5Solid.file_video)
      },
      {
        'content': Content.Ses,
        'text': "Ses",
        'icon': Icon(FontAwesome5Solid.file_audio)
      },
    ];

    _choiceIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context, listen: false);
    print("Content built.");
    print(provider.newPost.toString());
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contentMap.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
                onSelected: (value) {
                  provider.newPost.postContentType = contentMap[index]['text'];
                  provider.newPost.isVideo =
                      contentMap[index]['content'] == Content.Video
                          ? true
                          : false;
                  setState(() {
                    _choiceIndex = value ? index : 0;
                  });
                },
                avatar: contentMap[index]['icon'],
                label: Text(contentMap[index]["text"]),
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
