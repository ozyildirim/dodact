import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/creation/widgets/audio_player_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_metadata/youtube_metadata.dart';

enum Content { Goruntu, Video, Ses }
enum Category { Tiyatro, Resim, Muzik, Dans }
enum Source { Telefon, Youtube }

class PostCreationPage extends StatefulWidget {
  final String postType;
  final String postCategory;
  final String groupId;

  PostCreationPage({this.postType, this.postCategory, this.groupId});

  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends BaseState<PostCreationPage> {
  GlobalKey<FormBuilderState> postCreationFormKey =
      new GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PostProvider postProvider;
  var logger = Logger();

  bool isSelected = false;
  bool isLoading = false;
  bool isUploaded = false;

  bool isAvailableYoutubeLink = false;

  TextEditingController postTitleController;
  TextEditingController postDescriptionController;
  TextEditingController postContentUrlController;

  FocusNode postTitleFocus = new FocusNode();
  FocusNode postDescriptionFocus = new FocusNode();
  FocusNode postContentUrlFocus = new FocusNode();

  File postFile;
  FileImage imageThumbnail;

  String youtubeLink;

  @override
  void initState() {
    print("İçerik Türü: " + widget.postType);
    print("İçerik Kategorisi: " + widget.postCategory);

    super.initState();

    postProvider = Provider.of<PostProvider>(context, listen: false);

    postTitleController = new TextEditingController();
    postDescriptionController = new TextEditingController();
    postContentUrlController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    // postTitleFocus.dispose();
    // postDescriptionFocus.dispose();
    // postContentUrlFocus.dispose();
    // checkboxFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            formSubmit();
          }),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildPrevivewPart(),
                  SizedBox(height: size.height * 0.05),
                  buildFormPart(size, context, provider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPrevivewPart() {
    var size = MediaQuery.of(context).size;
    var child;

    if (widget.postType == "Video") {
      // if (isAvailableYoutubeLink) {
      //   return Container(
      //     height: size.height * 0.25,
      //     width: size.width * 0.6,
      //     child: buildVideoPreviewPart(),
      //   );
      // } else {
      //   return Container();
      // }
      return Container();
    } else if (widget.postType == "Ses") {
      child = buildSoundPreviewPart();
      return Container(
        height: size.height * 0.25,
        width: size.width * 0.8,
        child: child,
      );
    } else if (widget.postType == "Görüntü") {
      child = buildImagePreviewPart();
    }

    return Container(
      height: size.height * 0.25,
      width: size.width * 0.6,
      child: child,
    );
  }

  buildImagePreviewPart() {
    var size = MediaQuery.of(context).size;

    if (postFile != null) {
      return Stack(children: [
        Center(
          child: InkWell(
            onTap: imagePreviewDialog,
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: SizedBox(
                height: size.height * 0.25,
                width: size.width * 0.5,
                child: Image(
                  image: FileImage(postFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                iconSize: 20,
                onPressed: () async {
                  await _selectFile(FileType.image);
                },
                icon: Icon(
                  FontAwesome5Solid.images,
                  color: Colors.grey,
                ),
              )),
        ),
      ]);
    } else {
      return Container(
          height: size.height * 0.25,
          width: size.width * 0.5,
          child: Center(
            child: InkWell(
              onTap: () async {
                await _selectFile(FileType.image);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.add_a_photo, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Fotoğraf seç")
                ],
              ),
            ),
          ));
    }
  }

  buildSoundPreviewPart() {
    var size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: size.height * 0.25,
        width: size.width * 0.6,
        child: Center(
          child: postFile == null
              ? InkWell(
                  onTap: () async {
                    await _selectFile(FileType.audio);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.multitrack_audio_sharp,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Ses dosyası seç")
                    ],
                  ),
                )
              : Stack(
                  children: [
                    AudioPlayerWidget(
                      contentURL: postFile.path,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            iconSize: 20,
                            onPressed: () {
                              setState(() {
                                postFile = null;
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                          )),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  buildVideoPreviewPart() {
    var size = MediaQuery.of(context).size;

    if (isAvailableYoutubeLink == true) {
      var thumbnailUrl = CommonMethods.createThumbnailURL(true, youtubeLink);

      return Center(
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: InkWell(
            onTap: imagePreviewDialog,
            child: SizedBox(
              height: size.height * 0.25,
              width: size.width * 0.5,
              child: Image(
                image: NetworkImage(thumbnailUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }

    // return Container();
  }

  imagePreviewDialog() {
    var size = MediaQuery.of(context).size;
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: size.width * 0.8,
              // height: size.height * 0.5,
              child: Image.file(postFile),
            ),
          );
        });
  }

  buildFormPart(Size size, BuildContext context, PostProvider provider) {
    return Container(
      width: size.width * 0.8,
      child: FormBuilder(
        key: postCreationFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text("İçerik Başlığı",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 4),
              TextFieldContainer(
                width: size.width * 0.8,
                child: FormBuilderTextField(
                  textInputAction: TextInputAction.next,
                  focusNode: postTitleFocus,
                  controller: postTitleController,
                  name: "postTitle",
                  autofocus: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                      hintText: "İçerik Başlığı",
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        context,
                        errorText: "Bu alan boş bırakılamaz.",
                      ),
                      (value) {
                        return ProfanityChecker.profanityValidator(value);
                      },
                      FormBuilderValidators.minLength(context, 10,
                          errorText: "İçerik adı en az 10 harften oluşmalı.",
                          allowEmpty: false)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("İçerik Açıklaması",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  TextFieldContainer(
                    width: size.width * 0.8,
                    child: FormBuilderTextField(
                      textInputAction: TextInputAction.next,
                      focusNode: postDescriptionFocus,
                      controller: postDescriptionController,
                      name: "postDescription",
                      maxLines: 3,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                          hintText: "İçerik Açıklaması",
                          border: InputBorder.none,
                          errorStyle: Theme.of(context)
                              .inputDecorationTheme
                              .errorStyle),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(
                            context,
                            errorText: "Bu alan boş bırakılamaz.",
                          ),
                          (value) {
                            return ProfanityChecker.profanityValidator(value);
                          },
                          FormBuilderValidators.minLength(context, 20,
                              errorText:
                                  "Biraz daha detay verilmeli (En az 20 harf).",
                              allowEmpty: false)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              widget.postType == "Video"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Youtube Video Linki",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        TextFieldContainer(
                          width: size.width * 0.8,
                          child: FormBuilderTextField(
                            textInputAction: TextInputAction.done,
                            focusNode: postContentUrlFocus,
                            name: "youtubeLink",
                            maxLines: 1,
                            autofocus: false,
                            keyboardType: TextInputType.text,
                            cursorColor: kPrimaryColor,
                            controller: postContentUrlController,
                            onEditingComplete: () async {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {
                              setState(() {
                                isAvailableYoutubeLink = false;
                                checkYoutubeLink(value);
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "www.youtube.com/dodactcom",
                                border: InputBorder.none,
                                errorStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .errorStyle),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(
                                  context,
                                  errorText: "Bu alan boş bırakılamaz.",
                                ),
                                (value) {
                                  return ProfanityChecker.profanityValidator(
                                      value);
                                },
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  showSnackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          message,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  //TODO: Thumbnail package ekle
  Future<bool> uploadPost() async {
    CommonMethods().showLoaderDialog(context, "İçerik Yükleniyor");
    //Implement new post features into variable.
    try {
      PostModel newPost = new PostModel(
        visible: true,
        isLocatedInYoutube: widget.postType == "Video" ? true : false,
        isVideo: widget.postType == "Video" ? true : false,
        postContentType: widget.postType,
        ownerType: widget.groupId != null ? "Group" : "User",
        postId: "",
        ownerId: widget.groupId != null
            ? widget.groupId
            : authProvider.currentUser.uid,
        postCategory: widget.postCategory,
        postTitle: postTitleController.text,
        postDate: DateTime.now(),
        postDescription: postDescriptionController.text,
        postContentURL: postContentUrlController.text ?? null,
        dodCounter: 0,
      );

      newPost.searchKeywords = createSearchKeywords(newPost);

      await Provider.of<PostProvider>(context, listen: false)
          .addPost(postFile: postFile, post: newPost)
          .then(
        (_) async {
          //loaderDialog kapansın diye pop yapıyoruz.

          await showPostShareSuccessDialog(
              context, "Tebrikler! İçeriğin başarıyla yayınlandı.");
          NavigationService.instance.navigateToReset(k_ROUTE_HOME);
        },
      );
    } catch (e) {
      NavigationService.instance.pop();
      CommonMethods()
          .showErrorDialog(context, "İçerik yüklenirken bir hata oluştu");
    } //
  }

  List<String> createSearchKeywords(PostModel post) {
    List<String> searchKeywords = [];

    var title = post.postTitle;
    var splittedTitle = title.split(" ");
    splittedTitle.forEach((word) {
      searchKeywords.add(word.toLowerCase());
    });

    for (int i = 1; i <= title.length; i++) {
      searchKeywords.add(title.substring(0, i).toLowerCase());
    }
    return searchKeywords;
  }

  Future<void> _selectFile(FileType selectedType) async {
    bool isAudio = false;
    List<String> allowedTypes;

    if (selectedType == FileType.audio) {
      isAudio = true;
      allowedTypes = ["m4a", "mp3", "flac", "wav", "wma", "aac"];
    } else {}

    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: selectedType == FileType.audio ? FileType.custom : selectedType,
        allowedExtensions: selectedType == FileType.audio ? allowedTypes : null,
        allowCompression: true,
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
      if (selectedType == FileType.image) {
        cropImage(file);
      } else {
        setState(() {
          postFile = file;
          isLoading = false;
        });
      }

      print("Content picked");
    } else {
      print("User closed the picker");
    }
  }

  Future<void> formSubmit() async {
    if (widget.postType == "Video") {
      await checkYoutubeLink(
          postCreationFormKey.currentState.value["youtubeLink"]);
      if (isAvailableYoutubeLink) {
        if (postCreationFormKey.currentState.saveAndValidate()) {
          try {
            await uploadPost();
          } catch (e) {
            logger.e("Form submit edilirken hata oluştu: " + e.toString());
          }
        } else {
          print("Geçersiz youtube linki.");
        }
      }
    } else if (widget.postType == "Görüntü") {
      if (postCreationFormKey.currentState.saveAndValidate()) {
        try {
          if (checkPostHasImages()) {
            await uploadPost();
          } else {
            showSnackBar("Bir görüntü seçmelisin");
          }
        } catch (e) {
          logger.e("Form submit edilirken hata oluştu: " + e.toString());
        }
      }
    } else if (widget.postType == "Ses") {
      if (postCreationFormKey.currentState.saveAndValidate()) {
        try {
          if (checkPostHasSoundFile()) {
            await uploadPost();
          } else {
            showSnackBar("Bir ses dosyası seçmelisin");
          }
        } catch (e) {
          logger.e("Form submit edilirken hata oluştu: " + e.toString());
        }
      }
    }
  }

  Future<bool> checkYoutubeLink(String link) async {
    try {
      MetaDataModel metaData = await YoutubeMetaData.getData(link);
      print(metaData.title);
      setState(() {
        isAvailableYoutubeLink = true;
        youtubeLink = link;
      });
    } catch (e) {
      postCreationFormKey.currentState.invalidateField(
          name: "youtubeLink", errorText: "Geçersiz youtube linki");
      setState(() {
        youtubeLink = null;
      });
      print(e);
    }
  }

  bool checkPostHasImages() {
    if (postFile != null) {
      return true;
    }
    return false;
  }

  bool checkPostHasSoundFile() {
    if (postFile != null) {
      return true;
    }
    return false;
  }

  Future showPostShareSuccessDialog(
      BuildContext context, String message) async {
    await CoolAlert.show(
        context: context,
        barrierDismissible: false,
        type: CoolAlertType.success,
        text: message,
        showCancelBtn: true,
        cancelBtnText: "Paylaş",
        confirmBtnColor: Colors.green,
        onCancelBtnTap: () async {
          await sharePostStatusCard();
        },
        confirmBtnText: "Tamam",
        title: "İşlem Başarılı");
  }

  Future sharePostStatusCard() async {
    await Share.share(
        'Hey! Ben Dodact ile sanatımı ve kendimi yeniden keşfediyorum! Sen de bu platforma katılmak istemez misin? https://www.dodact.com');
  }

  Future<Null> cropImage(File file) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Özelleştir',
            toolbarColor: Color(0xff194d25),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Özelleştir',
        ));
    if (croppedFile != null) {
      setState(() {
        postFile = croppedFile;
      });
    }
  }
}
