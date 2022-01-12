import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/application_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/screens/agreements.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class GroupApplicationPage extends StatefulWidget {
  @override
  State<GroupApplicationPage> createState() => _GroupApplicationPageState();
}

class _GroupApplicationPageState extends BaseState<GroupApplicationPage> {
  GlobalKey<FormBuilderState> creatorApplicationFormKey =
      new GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode groupNameFocus = new FocusNode();
  FocusNode groupDescriptionFocus = FocusNode();
  FocusNode groupLinkFocus = FocusNode();

  List<String> selectedCategories = [];

  FocusNode linkFocus = FocusNode();
  ApplicationProvider applicationProvider;

  @override
  initState() {
    super.initState();
    applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:
            Text("Topluluk Başvurusu", style: TextStyle(color: Colors.black)),
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
                  height: (size.height - kToolbarHeight) * 0.25,
                  child: Image.asset(
                    "assets/images/application_page/group_application.png",
                  ),
                ),
                Container(
                  height: (size.height - kToolbarHeight) * 0.75,
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
    if (creatorApplicationFormKey.currentState.saveAndValidate()) {
      var groupName = creatorApplicationFormKey.currentState.value['groupName']
          .toString()
          .trim();

      var description = creatorApplicationFormKey
          .currentState.value["description"]
          .toString()
          .trim();
      var link = creatorApplicationFormKey.currentState.value["link"]
          .toString()
          .trim();

      try {
        await applicationProvider
            .createApplication("Group", userProvider.currentUser.uid, {
          'groupName': groupName,
          "selectedInterest": selectedCategories,
          "description": description,
          "link": link,
        });

        await CustomMethods().showSuccessDialog(
          context,
          "Başvurun bizlere ulaştı, en kısa zamanda dönüş yapacağız",
        );
        Get.back();
      } catch (e) {
        print(e);
      }
    } else {}
  }

  showInfoDialog(BuildContext context, String infoDescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
    var size = MediaQuery.of(context).size;
    return FormBuilder(
      key: creatorApplicationFormKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Topluluğunuzun adı ne olsun istersiniz?",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextFieldContainer(
                width: size.width * 0.7,
                child: FormBuilderTextField(
                  focusNode: groupNameFocus,
                  name: "groupName",
                  autofocus: false,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: InputDecoration(
                      hintText: "Dodact Topluluğu",
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
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Hangi sanat dalı ile ilgileniyorsunuz?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context,
                          "Topluluğun ilgilendiği sanat dalını seçmelisiniz.");
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
                  key: Key(selectedCategories.length > 0
                      ? "${selectedCategories.length} kategori seçildi"
                      : "Topluluk İlgi Alanları"),
                  initialValue: selectedCategories.length > 0
                      ? "${selectedCategories.length} kategori seçildi"
                      : "Topluluk İlgi Alanları",
                  style: TextStyle(
                      color: selectedCategories.length > 0
                          ? Colors.black
                          : Colors.grey[600]),
                  readOnly: true,
                  name: "groupInterests",
                  decoration: InputDecoration(
                      hintText: "Topluluk İlgi Alanları",
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  // ignore: missing_return
                  validator: (value) {
                    if (selectedCategories.length == 0) {
                      return "Kategori seçmelisin.";
                    } else {}
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: Text(
                    "Topluluğunuzun hedeflerinden ve çalışmalarından bahseder misiniz?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context,
                          "Mevcut bir topluluk ise; kaç üyesi olduğundan, ne tür çalışmalar yaptığınızdan ve hedeflerinizden, yeni bir topluluk ise; hedeflerinizden ve Dodact'tan beklentilerinizi paylaşabilirsiniz.");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextFieldContainer(
                width: size.width * 0.7,
                child: FormBuilderTextField(
                  focusNode: groupDescriptionFocus,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: Text(
                    "Bugüne kadar yaptığınız çalışmalarınızı merak ediyoruz. Bizimle bir link paylaşır mısınız?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context,
                          "Topluluğunuzla ve çalışmalarınızla ilgili bir link paylaşabilir misiniz? Bu kullandığınız diğer platformlardan (youtube,instagram) linkler de olabilir.");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextFieldContainer(
                width: size.width * 0.7,
                child: FormBuilderTextField(
                  focusNode: groupLinkFocus,
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
            SizedBox(height: 15),
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.black,
              ),
              child: FormBuilderCheckbox(
                activeColor: kNavbarColor,
                name: 'termsofusegreement',
                initialValue: false,
                // subtitle: Text(""),
                title: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TermsOfUsagePage();
                    }));
                  },
                  child: RichText(
                    text: TextSpan(
                      children: const <TextSpan>[
                        TextSpan(
                          text: "Kullanım koşulları sözleşmesini ",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "okudum ve kabul ediyorum.",
                          style: TextStyle(
                            fontSize: 13,
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
                name: 'privacyagreement',
                initialValue: false,
                // subtitle: Text(""),
                title: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PrivacyPolicyPage();
                    }));
                  },
                  child: RichText(
                    text: TextSpan(
                      children: const <TextSpan>[
                        TextSpan(
                          text: "Gizlilik sözleşmesini ",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "okudum ve kabul ediyorum.",
                          style: TextStyle(
                            fontSize: 13,
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
            SizedBox(height: 15),
            buildButton(),
            SizedBox(height: 50),
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
              selectedCategories = selectedValues;
            });
          },
          items: categoryList.map((e) => MultiSelectItem(e, e)).toList(),
          initialValue: selectedCategories,
          listType: MultiSelectListType.CHIP,
          cancelText: Text("Vazgeç", style: TextStyle(color: Colors.black)),
          confirmText: Text("Tamam", style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}
