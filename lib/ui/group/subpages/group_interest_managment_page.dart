import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class GroupInterestManagementPage extends StatefulWidget {
  @override
  _GroupInterestManagementPageState createState() =>
      _GroupInterestManagementPageState();
}

class _GroupInterestManagementPageState
    extends State<GroupInterestManagementPage> {
  GroupProvider groupProvider;
  GroupModel group;
  bool isUpdated = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    group = groupProvider.group;
    getSelectedValues();
  }

  getSelectedValues() {
    setState(() {
      if (group.interests != null) {
        if (group.interests.isNotEmpty) {
          selectedVisualArtValues = group.interests
              .where((element) => element['title'] == "Görsel Sanatlar")
              .toList()[0]['selectedSubcategories']
              .cast<String>();

          selectedDanceValues = group.interests
              .where((element) => element['title'] == "Dans")
              .toList()[0]['selectedSubcategories']
              .cast<String>();

          selectedMusicValues = group.interests
              .where((element) => element['title'] == "Müzik")
              .toList()[0]['selectedSubcategories']
              .cast<String>();

          selectedTheaterValues = group.interests
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: isLoading
          // ignore: missing_required_param
          ? FloatingActionButton(
              child: CircularProgressIndicator(color: Colors.white))
          : isUpdated
              ? FloatingActionButton(
                  onPressed: updateGroupInterests,
                  child: Icon(Icons.check),
                )
              : null,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Topluluk İlgi Alanları'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
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
            theaterSelector(),
            musicSelector(),
            danceSelector(),
            visualArtSelector()
          ],
        ),
      ),
    );
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
            cancelText: Text("İptal", style: TextStyle(fontSize: 20)),
            confirmText: Text("Onayla", style: TextStyle(fontSize: 20)),
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
          );
        });
  }

  void updateGroupInterests() async {
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

    await groupProvider.updateGroup(group.groupId, {'interests': interests});
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
