import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends BaseState<InterestsPage> {
  bool isUpdated = false;
  @override
  void initState() {
    super.initState();

    getSelectedValues();

    // print(userProvider.currentUser.interests);

    print("müzik seçilenler: " + selectedMusicValues.toString());
    print("görsel seçilenler: " + selectedVisualArtValues.toString());
    print("tiyatro seçilenler: " + selectedTheaterValues.toString());
    print("dans seçilenler: " + selectedDanceValues.toString());
  }

  getSelectedValues() {
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
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: isUpdated
          ? FloatingActionButton(
              onPressed: updateUserInterests,
              child: Icon(Icons.cloud_upload_rounded),
            )
          : Container(),
      appBar: AppBar(
        title: Text('İlgi Alanları'),
      ),
      body: Container(
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
      ),
    );
  }

  List<String> musicCategories = categoryList
      .where((element) => element.name == "Müzik")
      .toList()[0]
      .subCategories
      .toList();

  List<String> theaterCategories = categoryList
      .where((element) => element.name == "Tiyatro")
      .toList()[0]
      .subCategories
      .toList();

  List<String> visualArtCategories = categoryList
      .where((element) => element.name == "Görsel Sanatlar")
      .toList()[0]
      .subCategories
      .toList();

  List<String> danceCategories = categoryList
      .where((element) => element.name == "Dans")
      .toList()[0]
      .subCategories
      .toList();

  List<String> selectedMusicValues = [];
  List<String> selectedVisualArtValues = [];
  List<String> selectedTheaterValues = [];
  List<String> selectedDanceValues = [];

  musicSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.transparent,
        child: Container(
          width: dynamicWidth(0.7),
          height: dynamicHeight(0.3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage('assets/images/app/interests/muzik.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: MultiSelectDialogField(
            items: musicCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedMusicValues,
            checkColor: Colors.blue,
            buttonText: Text(
              "Müzik Alt Kategorileri",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            selectedColor: Colors.black26,
            barrierColor: Colors.transparent,
            selectedItemsTextStyle: TextStyle(color: Colors.black),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal", style: TextStyle(fontSize: 20)),
            confirmText: Text("Onayla", style: TextStyle(fontSize: 20)),
            title: Text("Müzik"),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedMusicValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          ),
        ),
      ),
    );
  }

  theaterSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.transparent,
        child: Container(
          width: dynamicWidth(0.7),
          height: dynamicHeight(0.3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage('assets/images/app/interests/tiyatro.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: MultiSelectDialogField(
            items: theaterCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedTheaterValues,
            checkColor: Colors.blue,
            buttonText: Text(
              "Tiyatro Alt Kategorileri",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            selectedColor: Colors.black26,
            // decoration: BoxDecoration(color: Colors.white),
            selectedItemsTextStyle: TextStyle(color: Colors.black),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal", style: TextStyle(fontSize: 20)),
            confirmText: Text("Onayla", style: TextStyle(fontSize: 20)),
            title: Text("Tiyatro", style: TextStyle(color: Colors.black)),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedTheaterValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          ),
        ),
      ),
    );
  }

  danceSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.transparent,
        child: Container(
          height: dynamicHeight(0.3),
          width: dynamicWidth(0.7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage('assets/images/app/interests/dans.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: MultiSelectDialogField(
            items: danceCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedDanceValues,
            checkColor: Colors.blue,
            buttonText: Text(
              "Dans Alt Kategorileri",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            selectedColor: Colors.black26,
            barrierColor: Colors.transparent,
            selectedItemsTextStyle: TextStyle(color: Colors.black),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal", style: TextStyle(fontSize: 20)),
            confirmText: Text("Onayla", style: TextStyle(fontSize: 20)),
            title: Text("Dans"),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedDanceValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          ),
        ),
      ),
    );
  }

  visualArtSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.transparent,
        child: Container(
          height: dynamicHeight(0.3),
          width: dynamicWidth(0.7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/app/interests/gorsel_sanatlar.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: MultiSelectDialogField(
            items:
                visualArtCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedVisualArtValues,
            checkColor: Colors.white,
            buttonText: Text(
              "Görsel Sanatlar Alt Kategorileri",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            selectedColor: Colors.black26,
            barrierColor: Colors.transparent,
            selectedItemsTextStyle: TextStyle(color: Colors.black),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal", style: TextStyle(fontSize: 20)),
            confirmText: Text("Onayla", style: TextStyle(fontSize: 20)),
            title: Text("Görsel Sanatlar"),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedVisualArtValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          ),
        ),
      ),
    );
  }

  updateUserInterests() async {
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
      isUpdated = false;
    });
  }
}
