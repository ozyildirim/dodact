import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InterestType {
  String name;
  String coverPhotoUrl;
  List<String> subCategories;

  InterestType(
      {String name, String coverPhotoUrl, List<String> subCategories}) {
    this.name = name;
    this.coverPhotoUrl = coverPhotoUrl;
    this.subCategories = subCategories;
  }
}

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends BaseState<InterestsPage> {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  bool isSelected = false;

  List<String> selectedTheaterCategories;

  List<String> selectedMusicCategories;

  List<String> selectedDanceCategories;

  List<String> selectedVisualCategories;

  List<InterestType> categoryList = [
    new InterestType(
        name: "Tiyatro",
        coverPhotoUrl: "assets/images/app/interests/tiyatro.jpeg",
        subCategories: [
          "Doğaçlama",
          "Tülüat",
          "Yazılı Metin",
          "Radyo Tiyatrosu",
          "Pandomim"
        ]),
    new InterestType(
        name: "Müzik",
        coverPhotoUrl: "assets/images/app/interests/muzik.jpeg",
        subCategories: [
          "Müzik",
          "Kültür",
          "Müzikal",
          "Müzikalizm",
          "Müzikal Dünyası"
        ]),
    new InterestType(
        name: "Dans",
        coverPhotoUrl: "assets/images/app/interests/dans.jpeg",
        subCategories: ["Dans", "Dans", "Dans", "Dans", "Dans"]),
    new InterestType(
        name: "Görsel Sanatlar",
        coverPhotoUrl: "assets/images/app/interests/resim.jpeg",
        subCategories: [
          "Jang",
          "Peyzaj",
          "Duvar Boyama",
          "Illustrasyon",
          "Soyut",
          "Natürmort",
          "Figüratif",
          "Nü (Çıplak)",
          "Portre",
          "Slayt",
          "Duvar Boyama",
          "Rölyef",
          "Büst",
          "Anıt Heykeller",
          "Gravür",
          "Serigrafi",
          "Taş Baskı",
          "Ağaç Baskı",
          "Karikatür",
          "İllustrasyon",
          "Manga",
          "Animasyon",
          "Çizgi Film",
          "Çizgi Roman",
          "Anime",
        ])
  ];

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: FormBuilder(
        key: formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await updateIntereset();
              }),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actionsIconTheme: IconThemeData(color: Colors.black),
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 8,
            actions: [
              IconButton(icon: Icon(Icons.info_outline), onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    _navigateToLanding();
                  })
            ],
          ),
          body: Container(
            height: dynamicHeight(0.3),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                var category = categoryList[index];
                print("$index + ${category.name}");
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () async {
                      await showInterestDialog(category);
                    },
                    child: Card(
                      child: Image.asset(
                        category.coverPhotoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<Widget> showInterestDialog(InterestType interest) async {
    var mediaQuery = MediaQuery.of(context);

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        content: buildChoiceContainer(interest),
      ),
    );
  }

  buildChoiceContainer(InterestType interest) {
    var chosenList;

    switch (interest.name) {
      case "Tiyatro":
        chosenList = selectedTheaterCategories;
        break;
      case "Müzik":
        chosenList = selectedMusicCategories;
        break;
      case "Dans":
        chosenList = selectedDanceCategories;
        break;
      case "Görsel Sanatlar":
        chosenList = selectedVisualCategories;
        break;
      default:
        break;
    }

    return Container(
      height: dynamicHeight(0.6),
      child: Column(
        children: [
          Text("Alt Kategoriler", style: TextStyle(fontSize: 22)),
          Container(
            height: dynamicHeight(0.5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FormBuilderFilterChip(
                    spacing: 6,
                    padding: EdgeInsets.all(8),
                    backgroundColor: Colors.amberAccent,
                    labelStyle: TextStyle(fontSize: 16),
                    name: "chips",
                    options: buildChipOptions(interest),
                  ),
                ],
              ),
            ),
          ),
          Align(
            child: FloatingActionButton(
              onPressed: () {
                formKey.currentState.save();
                print(formKey.currentState.value);
              },
              child: Icon(Icons.add),
            ),
            alignment: Alignment.bottomRight,
          )
        ],
      ),
    );
  }

  buildChipOptions(InterestType interest) {
    List<FormBuilderFieldOption> options = [];

    for (var subCategory in interest.subCategories) {
      options.add(
        FormBuilderFieldOption(
          value: subCategory,
          child: Text(subCategory),
        ),
      );
    }

    return options;
  }

  void _navigateToLanding() async {}

  void updateIntereset() {
    if (formKey.currentState.validate()) {
      var interests = formKey.currentState.value["isim"].toString();
      print(interests);
    }
  }
}
