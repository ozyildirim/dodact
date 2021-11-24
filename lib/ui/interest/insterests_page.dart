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
  bool isLoading = false;
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
      floatingActionButton: isLoading
          // ignore: missing_required_param
          ? FloatingActionButton(
              child: CircularProgressIndicator(color: Colors.white))
          : isUpdated
              ? FloatingActionButton(
                  onPressed: updateUserInterests,
                  child: Icon(Icons.check),
                )
              : null,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('İlgi Alanları'),
      ),
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
        // child: ListView(
        //   // scrollDirection: Axis.horizontal,
        //   children: [
        //     musicSelector(),
        //     danceSelector(),
        //     theaterSelector(),
        //     visualArtSelector()
        //   ],
        // ),
        child: buildStack(),
      ),
    );
  }

  buildStack() {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: size.height * 0.55,
          child: musicSelector(),
        ),
        Positioned(
          top: size.height * 0.35,
          child: danceSelector(),
        ),
        Positioned(
          top: size.height * 0.15,
          child: visualArtSelector(),
        ),
        Positioned(
          child: theaterSelector(),
        ),
      ],
    );
  }

  List<String> musicCategories = interestCategoryList
      .where((element) => element.name == "Müzik")
      .toList()[0]
      .subCategories
      .toList();

  List<String> theaterCategories = interestCategoryList
      .where((element) => element.name == "Tiyatro")
      .toList()[0]
      .subCategories
      .toList();

  List<String> visualArtCategories = interestCategoryList
      .where((element) => element.name == "Görsel Sanatlar")
      .toList()[0]
      .subCategories
      .toList();

  List<String> danceCategories = interestCategoryList
      .where((element) => element.name == "Dans")
      .toList()[0]
      .subCategories
      .toList();

  List<String> selectedMusicValues = [];
  List<String> selectedVisualArtValues = [];
  List<String> selectedTheaterValues = [];
  List<String> selectedDanceValues = [];

  musicSelector() {
    return InkWell(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/app/interests/muzik.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Müzik Alt Kategorileri",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )),
          ),
        ),
      ),
      onTap: musicSelectorDialog,
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
    return InkWell(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/app/interests/tiyatro.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Tiyatro Alt Kategorileri",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )),
          ),
        ),
      ),
      onTap: theaterSelectorDialog,
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
    return InkWell(
      onTap: danceSelectorDialog,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/app/interests/dans.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Dans Alt Kategorileri",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
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
    return InkWell(
      onTap: visualArtSelectorDialog,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/app/interests/gorsel_sanatlar.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Görsel Sanatlar Alt Kategorileri",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
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
    showSnackbar("İlgi alanları güncellendi");
  }

  showSnackbar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
