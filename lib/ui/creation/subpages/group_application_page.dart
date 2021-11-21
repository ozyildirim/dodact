import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/application_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/screens/agreements.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  FocusNode interestFocus = FocusNode();
  FocusNode groupTypeCheckboxFocus = FocusNode();
  FocusNode groupLinkFocus = FocusNode();

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
                  height: size.height * 0.2,
                  // child:
                  //     Image.asset('assets/images/application_page/woman.png'),
                  child: SvgPicture.asset(
                      "assets/images/application_page/group_application.svg",
                      semanticsLabel: 'A red up arrow'),
                ),
                Container(
                  height: size.height * 0.60,
                  width: size.width,
                  child: buildFormPart(),
                ),
                // Expanded(child: buildFormPart()),
                buildButton(),
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
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  submitForm() async {
    if (creatorApplicationFormKey.currentState.saveAndValidate()) {
      var groupName = creatorApplicationFormKey.currentState.value['groupName']
          .toString()
          .trim();
      var interest = creatorApplicationFormKey.currentState.value["interest"]
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
          "selectedInterest": interest,
          "description": description,
          "link": link,
        });

        await CommonMethods().showSuccessDialog(
          context,
          "Başvurun bizlere ulaştı, en kısa zamanda dönüş yapacağız",
        );
        NavigationService.instance.pop();
      } catch (e) {
        print(e);
      }
    } else {}
  }

  showInfoDialog(BuildContext context, String title, String infoDescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(infoDescription),
          actions: <Widget>[
            FlatButton(
              child: Text("Tamam"),
              onPressed: () {
                NavigationService.instance.pop();
              },
            ),
          ],
        );
      },
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
                "Oluşturmak İstediğin Topluluğun Adı",
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
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Topluluğunuzun Faaliyet Gösterdiği Alan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context, "Faaliyet Gösterilen Sanat Dalı",
                          "Topluluk olarak üzerine çalıştığınız sanat dalını seçmelisin.");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextFieldContainer(
                width: size.width * 0.7,
                child: FormBuilderDropdown(
                  focusNode: interestFocus,
                  name: "interest",
                  autofocus: false,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: interestCategoryList
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(e.name),
                          value: e.name,
                        ),
                      )
                      .toList(),
                  decoration: InputDecoration(
                      hintText: "Sanat Dalı",
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
            Row(
              children: [
                Text(
                  "Topluluk Hakkında Detaylı Bilgi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context, "Detaylı Bilgi",
                          "Bize biraz topluluğundan ve sanat geçmişinden bahseder misin? Kaç üyesi olduğunu, ne sıklıkla faaliyet gösterdiğinizi de belirtebilirsin.");
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
            Row(
              children: [
                Text(
                  "Bağlantı",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context, "Bağlantı",
                          "Topluluğunuzu ve çalışmalarınızı inceleyebileceğimiz herhangi bir link paylaşabilir misin? Bu, diğer kullandığın platformlardan (youtube,instagram) linkler de olabilir.");
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "okudum ve kabul ediyorum.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "okudum ve kabul ediyorum.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                validator: FormBuilderValidators.equal(context, true,
                    errorText: "Sözleşmeyi kabul etmelisin."),
              ),
            )
          ],
        ),
      ),
    );
  }
}