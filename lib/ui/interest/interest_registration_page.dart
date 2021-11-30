import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class InterestRegistrationPage extends StatefulWidget {
  @override
  _InterestRegistrationPageState createState() =>
      _InterestRegistrationPageState();
}

class _InterestRegistrationPageState
    extends BaseState<InterestRegistrationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool isUpdated = false;
  @override
  void initState() {
    super.initState();

    arrangeSelectedValues();

    // print(userProvider.currentUser.interests);

    // print("müzik seçilenler: " + selectedMusicValues.toString());
    // print("görsel seçilenler: " + selectedVisualArtValues.toString());
    // print("tiyatro seçilenler: " + selectedTheaterValues.toString());
    // print("dans seçilenler: " + selectedDanceValues.toString());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showInformationDialog();
    });
  }

  arrangeSelectedValues() {
    setState(() {
      if (userProvider.currentUser.interests != null) {
        if (userProvider.currentUser.interests.isNotEmpty) {
          selectedVisualArtValues = userProvider.currentUser.interests
              .where((element) => element['title'] == "Görsel Sanatlar")
              .toList()[0]['selectedSubcategories']
              .cast<String>();

          selectedDanceValues = userProvider.currentUser.interests
              .where((element) => element['title'] == "Dans")
              .toList()[0]['selectedSubcategories']
              .cast<String>();

          selectedMusicValues = userProvider.currentUser.interests
              .where((element) => element['title'] == "Müzik")
              .toList()[0]['selectedSubcategories']
              .cast<String>();

          selectedTheaterValues = userProvider.currentUser.interests
              .where((element) => element['title'] == "Tiyatro")
              .toList()[0]['selectedSubcategories']
              .cast<String>();
        } else {
          selectedVisualArtValues = [];
          selectedDanceValues = [];
          selectedMusicValues = [];
          selectedTheaterValues = [];
        }
      } else {
        selectedVisualArtValues = [];
        selectedDanceValues = [];
        selectedMusicValues = [];
        selectedTheaterValues = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // showInformationDialog();
    return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("İlgi Alanları"),
              actions: [
                IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.info),
                    onPressed: showInformationDialog),
              ],
            ),
            key: _scaffoldKey,
            floatingActionButton: isUpdated != false
                ? isLoading != false
                    ? FloatingActionButton(
                        onPressed: null,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : FloatingActionButton(
                        onPressed: submitInterests,
                        child: Icon(Icons.check),
                      )
                : null,
            body: Container(
              height: dynamicHeight(1),
              width: dynamicWidth(1),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.dstATop),
                  image: AssetImage(kBackgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              // child: choiceWidget(),
              child: ListView(
                // scrollDirection: Axis.horizontal,
                children: [
                  musicSelector(),
                  danceSelector(),
                  theaterSelector(),
                  visualArtSelector()
                ],
              ),
              // child: buildStack(),
            ),
          ),
        ));
  }

  // buildStack() {
  //   var size = MediaQuery.of(context).size;
  //   return Stack(
  //     children: [
  //       Positioned(
  //         top: size.height * 0.55,
  //         child: musicSelector(),
  //       ),
  //       Positioned(
  //         top: size.height * 0.35,
  //         child: danceSelector(),
  //       ),
  //       Positioned(
  //         top: size.height * 0.15,
  //         child: visualArtSelector(),
  //       ),
  //       Positioned(
  //         child: theaterSelector(),
  //       ),
  //     ],
  //   );
  // }

  List<String> musicCategories = [
    'Enstrümantal',
    'Klasik',
    'Elektronik',
    'Halk',
    'Jazz',
    'Pop',
    'Rock'
  ];
  List<String> theaterCategories = [
    'Operet',
    'Skeç',
    'Opera',
    'Fars',
    'Melodram',
    'Feeri',
    'Pandomim',
    'Drama',
    'Komedi'
  ];
  List<String> danceCategories = [
    'Bale',
    'Ça-ça',
    'Halk Oyunları',
    'Hip Hop',
    'Salsa',
    'Modern Dans',
    'Samba',
    'Zumba',
    'Zeybek',
    'Oryantal',
    'Roman',
    'Tango'
  ];
  List<String> visualArtCategories = [
    'Seramik',
    'Heykel',
    'Fotoğrafçılık',
    'Graffiti',
    'Karikatür',
    'İllustrasyon',
    'Manga',
    'Anime',
    'Animasyon',
    'Portre',
    'Çini',
    'Karakalem',
    'Ebru'
  ];

  List<String> selectedMusicValues = [];
  List<String> selectedVisualArtValues = [];
  List<String> selectedTheaterValues = [];
  List<String> selectedDanceValues = [];

  musicSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/app/interests/muzik.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      "Müzik Alt Kategorileri",
                      style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ),
        ),
        onTap: musicSelectorDialog,
      ),
    );
  }

  musicSelectorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return MultiSelectDialog(
            items: musicCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedMusicValues,
            checkColor: Colors.blue,
            // chipDisplay: MultiSelectChipDisplay.none(),
            selectedColor: kNavbarColor,
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            confirmText: Text("Onayla",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            title: Text("Müzik Alt Kategorileri"),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedMusicValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          );
        });
  }

  theaterSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/app/interests/tiyatro.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(
                    child: Text("Tiyatro Alt Kategorileri",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                )),
          ),
        ),
        onTap: theaterSelectorDialog,
      ),
    );
  }

  theaterSelectorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return MultiSelectDialog(
            items: theaterCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedTheaterValues,
            checkColor: Colors.blue,
            selectedColor: kNavbarColor,
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            confirmText: Text("Onayla",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            title: Text("Tiyatro", style: TextStyle(color: Colors.black)),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedTheaterValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          );
        });
  }

  danceSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: danceSelectorDialog,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/app/interests/dans.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(
                    child: Text("Dans Alt Kategorileri",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  danceSelectorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return MultiSelectDialog(
            items: danceCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedDanceValues,
            checkColor: Colors.blue,
            selectedColor: kNavbarColor,
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            confirmText: Text("Onayla",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            title: Text("Dans"),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedDanceValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          );
        });
  }

  visualArtSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: visualArtSelectorDialog,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 10,
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/app/interests/gorsel_sanatlar.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.045,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.5),
                  child: Center(
                    child: Text("Görsel Sanatlar Alt Kategorileri",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  visualArtSelectorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return MultiSelectDialog(
            items:
                visualArtCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedVisualArtValues,
            checkColor: Colors.white,
            selectedColor: kNavbarColor,
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            confirmText: Text("Onayla",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            title: Text("Görsel Sanatlar"),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedVisualArtValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          );
        });
  }

  updateUserInterests() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> interests = [
      {'title': 'Müzik', 'selectedSubcategories': selectedMusicValues},
      {'title': 'Tiyatro', 'selectedSubcategories': selectedTheaterValues},
      {'title': 'Dans', 'selectedSubcategories': selectedDanceValues},
      {
        'title': 'Görsel Sanatlar',
        'selectedSubcategories': selectedVisualArtValues
      }
    ];

    await userProvider.updateCurrentUserInterests(interests);
    setState(() {
      isLoading = false;
      isUpdated = false;
    });
  }

  void submitInterests() async {
    try {
      await updateUserInterests();

      navigateLanding();
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        duration: new Duration(seconds: 2),
        content: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new CircularProgressIndicator(),
            Expanded(
              child: new Text(
                "Bir hata meydana geldi.",
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ));
    }
  }

  void navigateLanding() {
    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
  }

  showInformationDialog() {
    String text =
        "Dodact içerisindeki maceranı şekillendirmek ve diğer sanatseverlerin seni daha iyi tanıyabilmesini sağlamak için ilgi alanlarını belirtebilirsin!";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("İlgi Alanları")),
          content: Text(text, style: TextStyle(fontSize: 18)),
          actions: [
            FlatButton(
              child: Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    // return AlertDialog(
    //   title: Text("Bilgilendirme"),
    //   content: Text(text),
    //   actions: [
    //     FlatButton(
    //       child: Text("Kapat"),
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //   ],
    // );
  }
}
