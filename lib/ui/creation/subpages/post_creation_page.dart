import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/creation/creation_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
  PostProvider postProvider;

  bool isSelected = false;
  bool isLoading = false;
  bool isUploaded = false;
  bool isHelpChecked = false;

  bool isAdWatched = false;
  bool isRewardedAdReady = false;

  String chosenCompany;

  RewardedAd rewardedAd;

  TextEditingController postTitleController;
  TextEditingController postDescriptionController;
  TextEditingController postContentUrlController;

  FocusNode postTitleFocus = new FocusNode();
  FocusNode postDescriptionFocus = new FocusNode();
  FocusNode postContentUrlFocus = new FocusNode();
  FocusNode checkboxFocus = new FocusNode();

  File postFile;
  FileImage imageThumbnail;
  String youtubeLink;

  List<Map<String, dynamic>> categoryMap;

  @override
  void initState() {
    prepareAd();
    print("İçerik Türü: " + widget.contentType);
    print("İçerik Kategorisi: " + widget.postCategory);
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);

    postTitleController = new TextEditingController();
    postDescriptionController = new TextEditingController();
    postContentUrlController = new TextEditingController();

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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _formSubmit();
          }),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8,
        title: Text("İçerik Oluştur"),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: dynamicHeight(1),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildPrevivewPart(),
                _buildFormPart(size, context, provider),
              ],
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            children: [
              Text("İçerik Başlığı",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
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
                  focusNode: postTitleFocus,
                  controller: postTitleController,
                  name: "postTitle",
                  autofocus: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.people_alt_sharp,
                        color: kPrimaryColor,
                      ),
                      hintText: "İçerik Başlığı",
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context,
                          errorText: "Bu alan boş bırakılamaz.")
                    ],
                  ),
                ),
              ),
              SizedBox(height: 6),
              Text("İçerik Açıklaması",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
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
                  focusNode: postDescriptionFocus,
                  controller: postDescriptionController,
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
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context,
                          errorText: "Bu alan boş bırakılamaz.")
                    ],
                  ),
                ),
              ),
              widget.contentType == "Video"
                  ? Container(
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
                        focusNode: postContentUrlFocus,
                        name: "youtubeLink",
                        maxLines: 1,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        cursorColor: kPrimaryColor,
                        controller: postContentUrlController,
                        onEditingComplete: () async {
                          setState(() {
                            youtubeLink = postContentUrlController.text;
                          });
                        },
                        decoration: InputDecoration(
                            icon: Icon(
                              FontAwesome5Brands.youtube,
                              color: kPrimaryColor,
                            ),
                            //FIXME: Geçersiz youtube linki girilmesi durumunda kırmızı ekran çıkıyor, onu düzelt
                            hintText: "Youtube Linki",
                            border: InputBorder.none,
                            errorStyle: Theme.of(context)
                                .inputDecorationTheme
                                .errorStyle),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: "Bu alan boş bırakılamaz."),
                        ]),
                      ),
                    )
                  : Container(),
              TextFieldContainer(
                child: FormBuilderCheckbox(
                  focusNode: checkboxFocus,
                  name: "donation",
                  initialValue: isHelpChecked,
                  title: Text(
                    "Bu paylaşımım ile kurumlara yardım etmek istiyorum",
                  ),
                  onChanged: (value) async {
                    if (value == true) {
                      await makeContribution();

                      if (chosenCompany != null) {
                        setState(() {
                          isHelpChecked = value;
                        });
                      }
                    } else {
                      setState(() {
                        isHelpChecked = value;
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrevivewPart() {
    if (widget.contentType == "Video") {
      return Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
                image: youtubeLink != null
                    ? DecorationImage(
                        image: NetworkImage(CommonMethods.createThumbnailURL(
                            true, youtubeLink)),
                        fit: BoxFit.cover,
                      )
                    : null),
            child: youtubeLink != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Icon(FontAwesome5Brands.youtube, color: red),
                    ),
                  )
                : null,
          ),
        ),
      );
    } else if (widget.contentType == "Görüntü") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 250,
          width: 250,
          decoration: postFile != null
              ? BoxDecoration(
                  image: DecorationImage(
                  image: FileImage(postFile),
                ))
              : null,
          child: postFile != null
              ? null
              : IconButton(
                  icon: Icon(
                    FontAwesome5Solid.camera,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await _selectFile(FileType.image);
                  }),
        ),
      );
    } else if (widget.contentType == "Ses") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 250,
          width: 250,
          child: Center(
            child: postFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(FontAwesome5Regular.file_audio),
                        onPressed: () async {
                          await _selectFile(FileType.audio);
                        },
                      ),
                      Text("Ses dosyası seçin")
                    ],
                  )
                : Text(postFile.path),
          ),
        ),
      );
    }
  }

  Future<void> makeContribution() async {
    final SimpleDialog contributionCategoryDialog = SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text('Hangi kuruma yardım etmek istiyorsunuz?'),
      children: [
        SimpleDialogItem(
          icon: FontAwesome5Solid.image,
          color: Colors.orange,
          text: 'TEMA',
          onPressed: () {
            Navigator.pop(context, "TEMA");
          },
        ),
        SimpleDialogItem(
          icon: FontAwesome5Solid.video,
          color: Colors.green,
          text: 'DODACT',
          onPressed: () {
            Navigator.pop(context, "DODACT");
          },
        ),
      ],
    );

    var contributionDialog = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => contributionCategoryDialog,
    );

    if (contributionDialog != null) {
      print(contributionDialog);
      chosenCompany = contributionDialog;
    }
  }

  Future prepareAd() async {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                isRewardedAdReady = false;
              });
              prepareAd();
            },
          );

          setState(() {
            isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
          setState(() {
            isRewardedAdReady = false;
          });
        },
      ),
    );
  }

  //TODO: Thumbnail package ekle
  Future<bool> uploadPost() async {
    CommonMethods().showLoaderDialog(context, "İçerik yükleniyor.");
    //Implement new post features into variable.
    try {
      //TODO: GRUPLAR İÇİN DE EKLEME YAPISI OLUŞTUR.

      //Bağış yapılacak ise
      if (chosenCompany != null) {
        Logger().i("Şirket seçildi");
        await rewardedAd.show(
            onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
          isAdWatched = true;
          Logger().i("Reklam ödülü verildi");
        }).then((value) async {
          Logger().i("Reklam izlendi");
          PostModel newPost = new PostModel(
            approved: false,
            isLocatedInYoutube: widget.contentType == "Video" ? true : false,
            isVideo: widget.contentType == "Video" ? true : false,
            postContentType: widget.contentType,
            ownerType: "User",
            postId: "",
            ownerId: authProvider.currentUser.uid,
            postCategory: widget.postCategory,
            postTitle: postTitleController.text,
            postDate: DateTime.now(),
            postDescription: postDescriptionController.text,
            postContentURL: postContentUrlController.text ?? null,
            dodCounter: 0,
            chosenCompany: chosenCompany,
            isUsedForHelp: true,
            supportersId: [],
          );

          await Provider.of<PostProvider>(context, listen: false)
              .addPost(postFile: postFile, post: newPost)
              .then(
            (_) async {
              //loaderDialog kapansın diye pop yapıyoruz.

              await showPostShareSuccessDialog(context,
                  "Tebrikler! İçeriğin bize ulaştı, en kısa zamanda yayınlayacağız.");
              NavigationService.instance.navigateToReset(k_ROUTE_HOME);
            },
          );
        });
      } else {
        //Bağış yapılmayacak ise
        PostModel newPost = new PostModel(
          approved: false,
          isLocatedInYoutube: widget.contentType == "Video" ? true : false,
          isVideo: widget.contentType == "Video" ? true : false,
          postContentType: widget.contentType,
          ownerType: "User",
          postId: "",
          ownerId: authProvider.currentUser.uid,
          postCategory: widget.postCategory,
          postTitle: postTitleController.text,
          postDate: DateTime.now(),
          postDescription: postDescriptionController.text,
          postContentURL: postContentUrlController.text ?? null,
          dodCounter: 0,
          chosenCompany: "",
          isUsedForHelp: false,
          supportersId: [],
        );

        await Provider.of<PostProvider>(context, listen: false)
            .addPost(postFile: postFile, post: newPost)
            .then(
          (_) async {
            //loaderDialog kapansın diye pop yapıyoruz.
            NavigationService.instance.pop();
            await showPostShareSuccessDialog(context,
                "Tebrikler! İçeriğin bize ulaştı, en kısa zamanda yayınlayacağız.");
            NavigationService.instance.navigateToReset(k_ROUTE_HOME);
          },
        );
      }
    } catch (e) {
      NavigationService.instance.pop();
      CommonMethods()
          .showErrorDialog(context, "İçerik yüklenirken bir hata oluştu");
    } //
  }

  Future<void> _selectFile(FileType selectedType) async {
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

  Future<void> _formSubmit() async {
    if (_formKey.currentState.saveAndValidate()) {
      await uploadPost();
    }
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
    if (chosenCompany != null && chosenCompany != '') {
      await Share.share(
          'Hey! Ben Dodact ile sanatımı yeniden keşfederken aynı zamanda ${chosenCompany} için maddi bir değer yaratmış oldum! Sen de bu platforma katılmak istemez misin? https://www.dodact.com');
    } else {
      await Share.share(
          'Hey! Ben Dodact ile sanatımı ve kendimi yeniden keşfediyorum! Sen de bu platforma katılmak istemez misin? https://www.dodact.com');
    }
  }
}
