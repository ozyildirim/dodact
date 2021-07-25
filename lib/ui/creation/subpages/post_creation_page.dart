import 'dart:io';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
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
  final String contentType;
  final String postCategory;

  PostCreationPage({this.contentType, this.postCategory});

  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends BaseState<PostCreationPage> {
  GlobalKey<FormBuilderState> _formKey = new GlobalKey<FormBuilderState>();
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

  List<Map<String, dynamic>> categoryMap;

  @override
  void initState() {
    print("İçerik Türü: " + widget.contentType);
    print("İçerik Kategorisi: " + widget.postCategory);
    super.initState();
    _postProvider = Provider.of<PostProvider>(context, listen: false);
    _postProvider.clearNewPost();

    _postTitleController = new TextEditingController();
    _postDescriptionController = new TextEditingController();
    _postContentUrlController = new TextEditingController();

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
            _buildPrevivewPart(),
            _buildFormPart(size, context, provider),
            _buildSubmissionPart()
          ],
        ),
      ),
    );
  }

  Expanded _buildSubmissionPart() {
    return Expanded(
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
    );
  }

  Expanded _buildFormPart(
      Size size, BuildContext context, PostProvider provider) {
    return Expanded(
      flex: 3,
      child: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                controller: _postTitleController,
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                controller: _postDescriptionController,
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
            widget.contentType == "Video"
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                        //FIXME: Geçersiz youtube linki girilmesi durumunda kırmızı ekran çıkıyor, onu düzelt
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
    );
  }

  Widget _buildPrevivewPart() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
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

  //TODO: Thumbnail package ekle
  Future<bool> uploadPost() async {
    CommonMethods().showLoaderDialog(context, "İçerik yükleniyor.");
    //Implement new post features into variable.
    try {
      //TODO: GRUPLAR İÇİN DE EKLEME YAPISI OLUŞTUR.
      _postProvider.newPost.postId = "";
      _postProvider.newPost.ownerType = "User";
      _postProvider.newPost.ownerId = authProvider.currentUser.uid;
      _postProvider.newPost.postCategory = widget.postCategory;
      _postProvider.newPost.postTitle = _postTitleController.text;
      _postProvider.newPost.postDate = DateTime.now();
      _postProvider.newPost.postDescription = _postDescriptionController.text;
      _postProvider.newPost.postContentURL =
          _postContentUrlController.text != null
              ? _postContentUrlController.text
              : null;
      _postProvider.newPost..claps = 0;
      _postProvider.newPost.supportersId = [];

      if (widget.contentType == "Video") {
        _postProvider.newPost.isVideo = true;
        _postProvider.newPost.isLocatedInYoutube = true;
      } else {
        _postProvider.newPost.isVideo = false;
        _postProvider.newPost.isLocatedInYoutube = false;
      }
      _postProvider.newPost.postContentType = widget.contentType;
      _postProvider.newPost.approved = false;

      if (widget.contentType == "Video") {
        await Provider.of<PostProvider>(context, listen: false)
            .addPost(postFile: postFile)
            .then((_) {
          //loaderDialog kapansın diye pop yapıyoruz.
          NavigationService.instance.pop();
          NavigationService.instance.navigateReplacement(k_ROUTE_HOME);
        });
      } else {
        await Provider.of<PostProvider>(context, listen: false)
            .addPost()
            .then((_) {
          //loaderDialog kapansın diye pop yapıyoruz.
          NavigationService.instance.pop();
          NavigationService.instance.navigateReplacement(k_ROUTE_HOME);
        });
      }
    } catch (e) {
      NavigationService.instance.pop();
      CommonMethods()
          .showErrorDialog(context, "İçerik yüklenirken bir hata oluştu");
    } //
  }

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

  void _formSubmit() async {
    if (_formKey.currentState.saveAndValidate()) {
      await uploadPost();
    }
  }
}
