import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PostEditPage extends StatefulWidget {
  final PostModel post;

  PostEditPage({this.post});
  @override
  _PostEditPageState createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  PostModel post;
  GlobalKey<FormBuilderState> postCreationFormKey =
      new GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PostProvider postProvider;
  bool isAvailableYoutubeLink = false;
  String youtubeLink;
  TextEditingController postTitleController;
  TextEditingController postDescriptionController;
  List<String> postCategories;

  var logger = Logger();

  FocusNode postTitleFocus = new FocusNode();
  FocusNode postDescriptionFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    post = widget.post;
    postProvider = Provider.of<PostProvider>(context, listen: false);

    postTitleController = new TextEditingController();
    postDescriptionController = new TextEditingController();
    postCategories = post.postCategories;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            formSubmit();
          }),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Gönderi Düzenle"),
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
                  Colors.black.withOpacity(1), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildFormPart(size, context, postProvider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildFormPart(Size size, BuildContext context, PostProvider provider) {
    return Center(
      child: Container(
        width: size.width * 0.8,
        child: FormBuilder(
          key: postCreationFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.05),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    color: Colors.white60,
                    child: Text("Gönderi Başlığı",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 4),
                TextFieldContainer(
                  width: size.width * 0.8,
                  child: FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    focusNode: postTitleFocus,
                    name: "postTitle",
                    autofocus: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: kPrimaryColor,
                    initialValue: post.postTitle,
                    decoration: InputDecoration(
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white60,
                      child: Text("Gönderi Açıklaması",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 4),
                    TextFieldContainer(
                      width: size.width * 0.8,
                      child: FormBuilderTextField(
                        // textInputAction: TextInputAction.next,
                        focusNode: postDescriptionFocus,
                        initialValue: post.postDescription,
                        name: "postDescription",
                        maxLines: null,
                        autofocus: false,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
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
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("İçerik Kategorisi",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        TextFieldContainer(
                          width: size.width * 0.8,
                          child: FormBuilderTextField(
                            name: "postCategories",
                            onTap: openCategoryDialog,
                            key: Key(post.postCategories.length > 0
                                ? "${postCategories.length} kategori seçildi"
                                : "İçerik Kategorisi"),
                            initialValue: post.postCategories.length > 0
                                ? "${postCategories.length} kategori seçildi"
                                : "İçerik Kategorisi",
                            style: TextStyle(
                                color: post.postCategories.length > 0
                                    ? Colors.black
                                    : Colors.grey[600]),
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            // ignore: missing_return
                            validator: (value) {
                              if (postCategories.length == 0) {
                                return "Kategori seçmelisin.";
                              } else {}
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openCategoryDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          selectedColor: kNavbarColor,
          searchHint: "Ara",
          title: Text("Kategori Seç"),
          selectedItemsTextStyle: TextStyle(color: Colors.white),
          onConfirm: (selectedValues) async {
            if (selectedValues.length > 0) {
              setState(() {
                postCategories = selectedValues;
              });
            }
          },
          items: categoryList.map((e) => MultiSelectItem(e, e)).toList(),
          initialValue: postCategories,
          listType: MultiSelectListType.CHIP,
          cancelText: Text("Vazgeç", style: TextStyle(color: Colors.black)),
          confirmText: Text("Tamam", style: TextStyle(color: Colors.black)),
        );
      },
    );
  }

  showSnackBar(String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 4,
    );
  }

  List<String> createSearchKeywords(String postTitle) {
    List<String> searchKeywords = [];

    var title = postTitle;
    var splittedTitle = title.split(" ");
    splittedTitle.forEach((word) {
      searchKeywords.add(word.toLowerCase());
    });

    for (int i = 1; i <= title.length; i++) {
      searchKeywords.add(title.substring(0, i).toLowerCase());
    }
    return searchKeywords;
  }

  Future<void> formSubmit() async {
    if (postCreationFormKey.currentState.saveAndValidate()) {
      try {
        updatePost();
      } catch (e) {
        logger.e("message" + e.toString());
      }
    } else {}
  }

  updatePost() async {
    try {
      CustomMethods().showLoaderDialog(context, "Gönderi Güncelleniyor");
      var postTitle = postCreationFormKey.currentState.value["postTitle"];
      var postDescription =
          postCreationFormKey.currentState.value["postDescription"];

      List<String> searchKeywords;

      if (postTitle != post.postTitle) {
        searchKeywords = createSearchKeywords(postTitle);
      } else {
        searchKeywords = post.searchKeywords;
      }

      postProvider.update(post.postId, {
        'postTitle': postTitle,
        'postDescription': postDescription,
        'searchKeywords': searchKeywords,
        'postCategories': postCategories,
      }).then((value) async {
        await showPostEditSuccessDialog(
            context, "Gönderin başarıyla güncellendi.");
        Get.offAllNamed(k_ROUTE_HOME);
      });
    } catch (e) {
      logger.e("PostEditPage error: $e");
    }
  }

  Future showPostEditSuccessDialog(BuildContext context, String message) async {
    await CoolAlert.show(
        context: context,
        barrierDismissible: false,
        type: CoolAlertType.success,
        text: message,
        showCancelBtn: false,
        confirmBtnColor: kNavbarColor,
        confirmBtnText: "Tamam",
        title: "İşlem Başarılı");
  }
}
