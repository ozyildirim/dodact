import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';

import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/interest_model.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InterestType {
  String id;
  String name;
  String coverPhotoUrl;
  List<String> subCategories;

  InterestType(
      {String id,
      String name,
      String coverPhotoUrl,
      List<String> subCategories}) {
    this.id = id;
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
  bool isSelected = false;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  String selectedTheaterCategories;
  String selectedMusicCategories;
  String selectedDanceCategories;
  String selectedVisualCategories;

  getUserInterests() async {
    await authProvider.getUserInterests();

    authProvider.currentUser.interests.map((e) {
      if (e.interestCategory == 'Tiyatro') {
        selectedTheaterCategories = e.interestSubcategory;
      } else if (e.interestCategory == "Müzik") {
        selectedMusicCategories = e.interestSubcategory;
      } else if (e.interestCategory == "Dans") {
        selectedDanceCategories = e.interestSubcategory;
      } else if (e.interestCategory == "Görsel Sanatlar") {
        selectedVisualCategories = e.interestSubcategory;
      }
    });
  }

  List<InterestType> categoryList = [
    new InterestType(
        id: "0",
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
        id: "1",
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
        id: "2",
        name: "Dans",
        coverPhotoUrl: "assets/images/app/interests/dans.jpeg",
        subCategories: ["Dans1", "Dans2", "Dans3", "Dans4", "Dans5"]),
    new InterestType(
        id: "3",
        name: "Görsel Sanatlar",
        coverPhotoUrl: "assets/images/app/interests/resim.jpeg",
        subCategories: [
          "Graffiti",
          "Illustrasyon",
          "Portre",
          "Anıt Heykeller",
          "Karikatür",
          "İllustrasyon",
          "Manga",
          "Animasyon",
          "Çizgi Roman",
          "Anime",
        ])
  ];

  @override
  void initState() {
    super.initState();
    getUserInterests();
  }

  @override
  Widget build(BuildContext context) {
    print(
      authProvider.currentUser.interests.map(
        (e) => print(e.interestCategory),
      ),
    );
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: FormBuilder(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text("İlgi Alanları"),
            automaticallyImplyLeading: false,
            actionsIconTheme: IconThemeData(color: Colors.black),
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 8,
            actions: [
              IconButton(icon: Icon(Icons.info_outline), onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    _navigateToLandingPage();
                  })
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () async {
              _formKey.currentState.save();
              if (_formKey.currentState.validate()) {
                print(_formKey.currentState.value);
                await updateInterests();
              }
            },
          ),
          body: Column(
            children: [
              Container(
                height: dynamicHeight(0.8),
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    var category = categoryList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: ExpansionCard(
                          initiallyExpanded: false,
                          onExpansionChanged: (value) {
                            if (value == false) {
                              _formKey.currentState.save();
                              if (_formKey.currentState.validate()) {
                                print(_formKey.currentState.value);
                              }
                            }
                          },
                          background: Image.asset(
                            category.coverPhotoUrl,
                          ),
                          title: Container(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          children: [buildChoiceContainer(category)],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child: Column(
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FormBuilderFilterChip(
                      spacing: 6,
                      padding: EdgeInsets.all(8),
                      backgroundColor: Colors.amberAccent,
                      labelStyle: TextStyle(fontSize: 16),
                      name: interest.name,
                      initialValue: buildPreselectedChipOptions(interest),
                      options: buildChipOptions(interest),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  buildPreselectedChipOptions(InterestType interest) {
    List<String> options = [];

    // print("preselected:" +
    //     authProvider.currentUser.interests[0].interestSubcategory);
    // var subCategory =
    //     authProvider.currentUser.interests[0].interestSubcategory.split(',');
    // for (var e in subCategory) {
    //   print("tiyatro element:" + e);
    // }

    switch (interest.name) {
      case "Tiyatro":
        // for (var interestModel in authProvider.currentUser.interests) {
        //   if (interestModel.interestCategory == "Tiyatro") {
        //     var subCategories = interestModel.interestSubcategory.split(',');
        //     for (var subCategory in subCategories) {
        //       options.add(
        //         FormBuilderFieldOption(
        //           value: subCategory,
        //           child: Text(subCategory),
        //         ),
        //       );
        //     }
        //   }
        // }
        var categories = selectedTheaterCategories?.split(',') ?? [];
        options = categories;
        return options;
      case "Müzik":
        // for (var interestModel in authProvider.currentUser.interests) {
        //   if (interestModel.interestCategory == "Müzik") {
        //     var subCategories = interestModel.interestSubcategory.split(',');
        //     for (var subCategory in subCategories) {
        //       options.add(
        //         FormBuilderFieldOption(
        //           value: subCategory,
        //           child: Text(subCategory),
        //         ),
        //       );
        //     }
        //   }
        // }
        var categories = selectedMusicCategories?.split(',') ?? [];
        options = categories;
        return options;
      case "Dans":
        // for (var interestModel in authProvider.currentUser.interests) {
        //   if (interestModel.interestCategory == "Dans") {
        //     var subCategories = interestModel.interestSubcategory.split(',');
        //     for (var subCategory in subCategories) {
        //       options.add(
        //         FormBuilderFieldOption(
        //           value: subCategory,
        //           child: Text(subCategory),
        //         ),
        //       );
        //     }
        //   }
        // }
        var categories = selectedDanceCategories?.split(',') ?? [];
        options = categories;
        return options;
      case "Görsel Sanatlar":
        // for (var interestModel in authProvider.currentUser.interests) {
        //   if (interestModel.interestCategory == "Görsel Sanatlar") {
        //     var subCategories = interestModel.interestSubcategory.split(',');
        //     for (var subCategory in subCategories) {
        //       options.add(
        //         FormBuilderFieldOption(
        //           value: subCategory,
        //           child: Text(subCategory),
        //         ),
        //       );
        //     }
        //   }
        // }
        var categories = selectedVisualCategories?.split(',') ?? [];
        options = categories;
        return options;
      default:
        return [];
        break;
    }
  }

  void _navigateToLandingPage() {
    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
  }

  Future<void> updateInterests() async {
    try {
      CommonMethods().showLoaderDialog(context, "Hemen hallediyoruz.");
      selectedTheaterCategories =
          _formKey.currentState.value['Tiyatro'].toString();
      print("Tiyatro:" + selectedTheaterCategories ?? "Yok");
      selectedMusicCategories = _formKey.currentState.value['Müzik'].toString();
      print("Müzik:" + selectedMusicCategories ?? "Yok");
      selectedDanceCategories = _formKey.currentState.value['Dans'].toString();
      print("Dans:" + selectedDanceCategories ?? "Yok");
      selectedVisualCategories =
          _formKey.currentState.value['Görsel Sanatlar'].toString();
      print("Görsel:" + selectedVisualCategories ?? "Yok");

      List<InterestModel> selectedInterestsList = [
        InterestModel(
            interestId: "0",
            interestCategory: "Tiyatro",
            interestSubcategory: selectedTheaterCategories),
        InterestModel(
            interestId: "1",
            interestCategory: "Müzik",
            interestSubcategory: selectedMusicCategories),
        InterestModel(
            interestId: "2",
            interestCategory: "Dans",
            interestSubcategory: selectedDanceCategories),
        InterestModel(
            interestId: "3",
            interestCategory: "Görsel Sanatlar",
            interestSubcategory: selectedVisualCategories),
      ];

      await authProvider.updateUserInterests(selectedInterestsList);
    } catch (e) {
      CommonMethods().showErrorDialog(
          context, "İlgi alanı güncellemesi sırasında hata oluştu.");
    } finally {
      CommonMethods().hideDialog();
    }
  }
}
