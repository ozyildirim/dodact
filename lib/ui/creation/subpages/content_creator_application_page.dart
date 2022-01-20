//Users are going to apply through this page to be post and event creator.
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/application_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/screens/agreements.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:dodact_v1/utilities/lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ContentCreatorApplicationPage extends StatefulWidget {
  @override
  State<ContentCreatorApplicationPage> createState() =>
      _ContentCreatorApplicationPageState();
}

class _ContentCreatorApplicationPageState
    extends BaseState<ContentCreatorApplicationPage> {
  GlobalKey<FormBuilderState> contentCreatorApplicationFormKey =
      new GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode interestFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode firstQuestionFocus = FocusNode();
  FocusNode linkFocus = FocusNode();
  FocusNode kvkkCheckboxFocus = FocusNode();
  FocusNode artistLabelDropdownFocus = FocusNode();
  FocusNode copyrightCheckboxFocus = FocusNode();

  List<String> selectedInterests = [];

  ApplicationProvider applicationProvider;

  @override
  void initState() {
    super.initState();
    applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
  }

  @override
  void dispose() {
    interestFocus.dispose();
    descriptionFocus.dispose();
    linkFocus.dispose();
    firstQuestionFocus.dispose();
    artistLabelDropdownFocus.dispose();
    kvkkCheckboxFocus.dispose();
    copyrightCheckboxFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          height: size.height - kToolbarHeight,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: (size.height - kToolbarHeight) * 0.2,
                  // child:
                  //     Image.asset('assets/images/application_page/woman.png'),
                  child: Image.asset(
                    "assets/images/application_page/content_application.png",
                  ),
                ),
                Container(
                  height: (size.height - kToolbarHeight) * 0.8,
                  width: size.width,
                  child: buildFormPart(),
                ),
                // Expanded(child: buildFormPart()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildButton() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.05,
      child: MaterialButton(
        onPressed: submitForm,
        child: Text(
          "Başvur",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        color: kNavbarColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  submitForm() async {
    if (contentCreatorApplicationFormKey.currentState.saveAndValidate()) {
      var description = contentCreatorApplicationFormKey
          .currentState.value["description"]
          .toString()
          .trim();

      var firstQuestion = contentCreatorApplicationFormKey
          .currentState.value["firstQuestion"]
          .toString()
          .trim();

      var link = contentCreatorApplicationFormKey.currentState.value["link"]
          .toString()
          .trim();

      var label =
          contentCreatorApplicationFormKey.currentState.value["artistLabel"];

      try {
        await CustomMethods()
            .showLoaderDialog(context, "İşlemini Gerçekleştiriyoruz");

        await applicationProvider.createApplication(
            "Content_Creator", userProvider.currentUser.uid, {
          "selectedInterest": selectedInterests,
          "description": description,
          "firstQuestion": firstQuestion,
          "link": link,
          "label": label,
        });

        CustomMethods().hideDialog();

        await CustomMethods().showSuccessDialog(
          context,
          "Başvurun bizlere ulaştı, en kısa zamanda dönüş yapacağız",
        );
        Get.back();
      } catch (e) {
        CustomMethods().hideDialog();
        CustomMethods.showSnackbar(context, "Bir hata oluştu");
      }
    } else {}
  }

  showInfoDialog(BuildContext context, String infoDescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(title),
          content: Text(
            infoDescription,
            textAlign: TextAlign.center,
          ),
          contentTextStyle: TextStyle(fontSize: 18, color: Colors.black),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            FlatButton(
              child: Text("Tamam"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  buildFormPart() {
    artistLabels.sort((a, b) => a.compareTo(b));
    var size = MediaQuery.of(context).size;
    return FormBuilder(
      key: contentCreatorApplicationFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "Hangi sanat dalıyla ilgili içerik oluşturmak istersin?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context,
                          "Aktif olduğun, takip etmekten hoşlandığın ve paylaşım yapabileceğin sanat dalını seçmelisin.");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextFieldContainer(
                width: size.width * 0.7,
                child: FormBuilderTextField(
                  onTap: openCategoryDialog,
                  key: Key(selectedInterests.length > 0
                      ? "${selectedInterests.length} kategori seçildi"
                      : "Kategoiler"),
                  initialValue: selectedInterests.length > 0
                      ? "${selectedInterests.length} kategori seçildi"
                      : "Kategoriler",
                  style: TextStyle(
                      color: selectedInterests.length > 0
                          ? Colors.black
                          : Colors.grey[600]),
                  readOnly: true,
                  name: "interests",
                  decoration: InputDecoration(
                      hintText: "İlgi Alanları",
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  // ignore: missing_return
                  validator: (value) {
                    if (selectedInterests.length == 0) {
                      return "Kategori seçmelisin.";
                    } else {}
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Flexible(
                  child: Text(
                    "İlgilendiğin sanat dalında örnek aldığın bir sanatçı var ise bahseder misin?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context,
                          "Dilersen bize biraz kendinden ve sanat geçmişinden bahsedebilirsin.");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextFieldContainer(
                width: size.width * 0.7,
                child: FormBuilderTextField(
                  focusNode: descriptionFocus,
                  name: "description",
                  autofocus: false,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: "",
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        context,
                        errorText: "Bu alan boş bırakılamaz.",
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Hayatında sanatın yeri nedir? Düşüncelerini paylaşır mısın?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextFieldContainer(
                width: size.width * 0.7,
                child: FormBuilderTextField(
                  focusNode: firstQuestionFocus,
                  name: "firstQuestion",
                  autofocus: false,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: "",
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        context,
                        errorText: "Bu alan boş bırakılamaz.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Flexible(
                  child: Text(
                    "Şimdiye kadar ki çalışmalarını merak ediyoruz. Bizimle bir link paylaşır mısın?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context,
                          "Yaptığın çalışmalarla ilgili diğer kullandığın platformlardan (youtube,instagram) linkler de olabilir.");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextFieldContainer(
                width: size.width * 0.7,
                child: FormBuilderTextField(
                  focusNode: linkFocus,
                  name: "link",
                  autofocus: false,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      hintText: "www.dodact.com",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        context,
                        errorText: "Bu alan boş bırakılamaz.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Flexible(
                  child: Text(
                    "Profilinde hangisinin görünmesini istersin?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context,
                          "Yukarıda belirtmiş olduğun bilgilerle alakalı olarak profilinde gözükmesini istediğin tanımı seçebilirsin.");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextFieldContainer(
                width: size.width * 0.7,
                child: FormBuilderDropdown(
                  focusNode: artistLabelDropdownFocus,
                  name: "artistLabel",
                  items: artistLabels
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  autofocus: false,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: InputDecoration(
                      hintText: "",
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(
                        context,
                        errorText: "Bu alan boş bırakılamaz.",
                      )
                    ],
                  ),
                ),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.black,
              ),
              child: FormBuilderCheckbox(
                activeColor: kNavbarColor,
                name: 'copyright',
                initialValue: false,
                focusNode: copyrightCheckboxFocus,
                // subtitle: Text(""),
                title: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CopyrightPage();
                    }));
                  },
                  child: RichText(
                    text: TextSpan(
                      children: const <TextSpan>[
                        TextSpan(
                          text: "Telif hakları sözleşmesini ",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "okudum ve kabul ediyorum.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero, border: InputBorder.none),
                contentPadding: EdgeInsets.zero,
                validator: FormBuilderValidators.equal(context, true,
                    errorText: "Sözleşmeyi kabul etmelisin."),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.black,
              ),
              child: FormBuilderCheckbox(
                activeColor: kNavbarColor,
                focusNode: kvkkCheckboxFocus,
                name: 'kvkk',
                initialValue: false,
                // subtitle: Text(""),
                title: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return KvkkPage();
                    }));
                  },
                  child: RichText(
                    text: TextSpan(
                      children: const <TextSpan>[
                        TextSpan(
                          text: "KVKK sözleşmesini ",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "okudum ve kabul ediyorum.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero, border: InputBorder.none),
                contentPadding: EdgeInsets.zero,
                validator: FormBuilderValidators.equal(context, true,
                    errorText: "Sözleşmeyi kabul etmelisin."),
              ),
            ),
            buildButton(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  openCategoryDialog() async {
    categoryList.sort((a, b) => a.compareTo(b));

    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          selectedColor: kNavbarColor,
          searchHint: "Ara",
          title: Text("Kategori Seç"),
          selectedItemsTextStyle: TextStyle(color: Colors.white),
          onConfirm: (selectedValues) async {
            setState(() {
              selectedInterests = selectedValues;
            });
          },
          items: categoryList.map((e) => MultiSelectItem(e, e)).toList(),
          initialValue: selectedInterests,
          listType: MultiSelectListType.CHIP,
          cancelText: Text("Vazgeç", style: TextStyle(color: Colors.black)),
          confirmText: Text("Tamam", style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}
