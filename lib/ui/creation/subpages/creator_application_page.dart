//Users are going to apply through this page to be post and event creator.
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/application_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class CreatorApplicationPage extends StatefulWidget {
  @override
  State<CreatorApplicationPage> createState() => _CreatorApplicationPageState();
}

class _CreatorApplicationPageState extends BaseState<CreatorApplicationPage> {
  GlobalKey<FormBuilderState> creatorApplicationFormKey =
      new GlobalKey<FormBuilderState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FocusNode interestFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  ApplicationProvider applicationProvider;

  @override
  void initState() {
    super.initState();
    applicationProvider =
        Provider.of<ApplicationProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
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
                  height: size.height * 0.3,
                ),
                Container(
                  height: size.height * 0.5,
                  width: size.width,
                  child: buildFormPart(),
                ),
                buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildButton() {
    return MaterialButton(
      onPressed: submitForm,
      child: Text(
        "Başvur",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  submitForm() async {
    if (creatorApplicationFormKey.currentState.saveAndValidate()) {
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
            .createApplication("Creator", userProvider.currentUser.uid, {
          "selectedInterest": interest,
          "description": description,
          "link": link,
        });

        CommonMethods().showSuccessDialog(
          context,
          "Başvurun bizlere ulaştı, en kısa zamanda dönüş yapacağız",
        );
        NavigationService.instance.pop();
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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "İlgili Sanat Dalı",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context, "İlgili Sanat Dalı",
                          "İçerik oluşturmayı planladığın sanat dalını seçebilir misin?");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            TextFieldContainer(
              width: size.width * 0.7,
              child: FormBuilderDropdown(
                focusNode: interestFocus,
                name: "interest",
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
            Row(
              children: [
                Text(
                  "Sanatçı Detay",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context, "Detaylı Bilgi",
                          "Bize biraz kendinden ve sanat geçmişinden bahseder misin? Aldığın eğitimler veya bu zamana kadar ortaya koymuş olduğun performanslardan bahsedebilirsin.");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            TextFieldContainer(
              width: size.width * 0.7,
              child: FormBuilderTextField(
                focusNode: descriptionFocus,
                name: "description",
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
            Row(
              children: [
                Text(
                  "Bağlantı",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      showInfoDialog(context, "Bağlantı",
                          "Yaptığın çalışmaları inceleyebileceğimiz herhangi bir link paylaşabilir misin? Bu, diğer kullandığın platformlardan (youtube,instagram) linkler de olabilir.");
                    },
                    icon: Icon(Icons.info_outline))
              ],
            ),
            TextFieldContainer(
              width: size.width * 0.7,
              child: FormBuilderTextField(
                focusNode: interestFocus,
                name: "link",
                autofocus: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
            )
          ],
        ),
      ),
    );
  }
}
