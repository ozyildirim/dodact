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

    print("sahne sanatları seçilenler: " +
        selectedPerformingArtValues.toString());
    print("yüzey sanatları seçilenler: " + selectedSurfaceArtValues.toString());
    print("hacim sanatları seçilenler: " + selectedVolumeArtValues.toString());
    print("ses sanatları seçilenler: " + selectedVocalArtValues.toString());
  }

  getSelectedValues() {
    setState(() {
      if (userProvider.currentUser.interests != null) {
        if (userProvider.currentUser.interests.isNotEmpty) {
          selectedSurfaceArtValues = userProvider.currentUser.interests
              .where((element) => element['title'] == "Yüzey Sanatları")
              .toList()[0]['selectedSubcategories']
              .cast<String>();

          selectedVocalArtValues = userProvider.currentUser.interests
              .where((element) => element['title'] == "Ses Sanatları")
              .toList()[0]['selectedSubcategories']
              .cast<String>();

          selectedPerformingArtValues = userProvider.currentUser.interests
              .where((element) => element['title'] == "Sahne Sanatları")
              .toList()[0]['selectedSubcategories']
              .cast<String>();

          selectedVolumeArtValues = userProvider.currentUser.interests
              .where((element) => element['title'] == "Hacim Sanatları")
              .toList()[0]['selectedSubcategories']
              .cast<String>();
        } else {
          selectedSurfaceArtValues = [];
          selectedVocalArtValues = [];
          selectedPerformingArtValues = [];
          selectedVolumeArtValues = [];
        }
      } else {
        selectedSurfaceArtValues = [];
        selectedVocalArtValues = [];
        selectedPerformingArtValues = [];
        selectedVolumeArtValues = [];
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
        child: ListView(
          // scrollDirection: Axis.horizontal,
          children: [
            performingArtsSelector(),
            vocalArtsSelector(),
            surfaceArtsSelector(),
            volumeArtsSelector()
          ],
        ),
        // child: buildStack(),
      ),
    );
  }

  List<String> performingArtsCategories = interestCategoryList
      .where((element) => element.name == "Sahne Sanatları")
      .toList()[0]
      .subCategories
      .toList();

  List<String> surfaceArtsCategories = interestCategoryList
      .where((element) => element.name == "Yüzey Sanatları")
      .toList()[0]
      .subCategories
      .toList();

  List<String> volumeArtsCategories = interestCategoryList
      .where((element) => element.name == "Hacim Sanatları")
      .toList()[0]
      .subCategories
      .toList();

  List<String> vocalArtsCategories = interestCategoryList
      .where((element) => element.name == "Ses Sanatları")
      .toList()[0]
      .subCategories
      .toList();

  List<String> selectedPerformingArtValues = [];
  List<String> selectedSurfaceArtValues = [];
  List<String> selectedVolumeArtValues = [];
  List<String> selectedVocalArtValues = [];

  performingArtsSelector() {
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
                    child: Text("Sahne Sanatları",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                )),
          ),
        ),
        onTap: performingArtsSelectorDialog,
      ),
    );
  }

  performingArtsSelectorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return MultiSelectDialog(
            items: performingArtsCategories
                .map((e) => MultiSelectItem(e, e))
                .toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedPerformingArtValues,
            checkColor: Colors.blue,
            // chipDisplay: MultiSelectChipDisplay.none(),
            selectedColor: kNavbarColor,
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            confirmText: Text("Onayla",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            title: Text("Sahne Sanatları"),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedPerformingArtValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          );
        });
  }

  surfaceArtsSelector() {
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
                    child: Text("Yüzey Sanatları",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                )),
          ),
        ),
        onTap: surfaceArtsSelectorDialog,
      ),
    );
  }

  surfaceArtsSelectorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return MultiSelectDialog(
            items: surfaceArtsCategories
                .map((e) => MultiSelectItem(e, e))
                .toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedSurfaceArtValues,
            checkColor: Colors.blue,
            selectedColor: kNavbarColor,
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            confirmText: Text("Onayla",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            title:
                Text("Yüzey Sanatları", style: TextStyle(color: Colors.black)),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedSurfaceArtValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          );
        });
  }

  vocalArtsSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: vocalArtsSelectorDialog,
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
                    child: Text("Ses Sanatları",
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

  vocalArtsSelectorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return MultiSelectDialog(
            items:
                vocalArtsCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedVocalArtValues,
            checkColor: Colors.blue,
            selectedColor: kNavbarColor,
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            confirmText: Text("Onayla",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            title: Text("Ses Sanatları"),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedVocalArtValues = values;
              setState(() {
                isUpdated = true;
              });
            },
          );
        });
  }

  volumeArtsSelector() {
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
                image:
                    AssetImage('assets/images/app/interests/volume_arts.jpg'),
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
                    child: Text("Hacim Sanatları",
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
                volumeArtsCategories.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            initialValue: selectedVolumeArtValues,
            checkColor: Colors.white,
            selectedColor: kNavbarColor,
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            itemsTextStyle: TextStyle(color: Colors.black),
            cancelText: Text("İptal",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            confirmText: Text("Onayla",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            title: Text("Hacim Sanatları"),
            searchable: true,
            searchHint: "Ara",
            onConfirm: (values) {
              selectedVolumeArtValues = values;
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
      {
        'title': 'Sahne Sanatları',
        'selectedSubcategories': selectedPerformingArtValues
      },
      {
        'title': 'Hacim Sanatları',
        'selectedSubcategories': selectedVolumeArtValues
      },
      {
        'title': 'Ses Sanatları',
        'selectedSubcategories': selectedVocalArtValues
      },
      {
        'title': 'Yüzey Sanatları',
        'selectedSubcategories': selectedSurfaceArtValues
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
