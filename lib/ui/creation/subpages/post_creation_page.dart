import 'dart:io';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

enum Content { Goruntu, Video, Ses }
enum Category { Tiyatro, Resim, Muzik, Dans }
enum Source { Telefon, Youtube }

class PostCreationPage extends StatefulWidget {
  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends BaseState<PostCreationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Category category;
  Content content;
  Source source;

  bool isSelected = false;
  bool isLoading = false;
  bool isUploaded = false;

  File postFile;
  String youtubeLink;

  List<Widget> _samplePages;

  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  List<Map<String, dynamic>> categoryMap = [
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

  List<Map<String, dynamic>> contentMap = [
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

  List<Map<String, dynamic>> sourceMap = [
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

  @override
  void initState() {
    super.initState();

    _samplePages = [
      postCategoryPage(),
      postContentPage(),
      postSourcePage(),
      postUploadPage()
    ];
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
        body: Column(
          children: <Widget>[
            Flexible(
              child: PageView.builder(
                physics: new NeverScrollableScrollPhysics(),
                controller: _controller,
                itemCount: _samplePages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _samplePages[index % _samplePages.length];
                },
              ),
            ),
            Container(
              color: Colors.lightBlueAccent,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text('Prev'),
                    onPressed: () {
                      _controller.previousPage(
                          duration: _kDuration, curve: _kCurve);
                    },
                  ),
                  FlatButton(
                    child: Text('Next'),
                    onPressed: () {
                      if (category != null) {
                        _controller.nextPage(
                            duration: _kDuration, curve: _kCurve);
                      } else {
                        //TODO:Snackbar düzeltilecek.
                        _scaffoldKey.currentState.showSnackBar(
                          new SnackBar(
                            duration: new Duration(seconds: 1),
                            content: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // new CircularProgressIndicator(),
                                Expanded(
                                  child: new Text(
                                    "Bir kategori seçmelisiniz.",
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// //TODO: Thumbnail package ekle
//   Future<bool> uploadPost() async {
//     //TODO: Bu kısmı fonksiyon ile birlitke düzelt.
//     // await UploadService().uploadPostMedia(postID: postID, fileNameAndExtension: fileNameAndExtension, fileToUpload: fileToUpload)
//     //
//   }

  Widget postCategoryPage() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: Category.values.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> categoryItem = categoryMap[index];
          return InkWell(
            onTap: () {
              setState(() {
                category = categoryItem['category'];
              });
              _controller.nextPage(duration: _kDuration, curve: _kCurve);
            },
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  categoryItem['icon'],
                  Text(categoryItem['text']),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        });
  }

  Widget postContentPage() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: Content.values.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> contentItem = contentMap[index];
          return InkWell(
            onTap: () {
              setState(() {
                content = contentItem['content'];
              });
              _controller.nextPage(duration: _kDuration, curve: _kCurve);
            },
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  contentItem['icon'],
                  Text(contentItem['text']),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        });
  }

  Widget postSourcePage() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: Source.values.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> sourceItem = sourceMap[index];
          return InkWell(
            onTap: () {
              setState(() {
                source = sourceItem['source'];
              });
              _controller.nextPage(duration: _kDuration, curve: _kCurve);
            },
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  sourceItem['icon'],
                  Text(sourceItem['text']),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        });
  }

  Widget postUploadPage() {
    return Column(
      children: [
        Text("Önizleme"),
        Container(
          height: 250,
          width: 250,
          color: Colors.amberAccent,
        )
      ],
    );
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

  void _selectPhoto(FileType selectedType) async {
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
    } else {
      // User canceled the picker
    }
  }
}
