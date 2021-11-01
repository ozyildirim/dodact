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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: isUpdated
          ? FloatingActionButton(
              onPressed: updateGroupInterests,
              child: Icon(Icons.cloud_upload_rounded),
            )
          : Container(),
      appBar: AppBar(
        title: Text('Topluluk İlgi Alanları'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
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

  musicSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Card(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('assets/images/app/interests/muzik.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.topLeft,
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
            selectedColor: Colors.black26,
            selectedItemsTextStyle: TextStyle(color: Colors.black),
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
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('assets/images/app/interests/tiyatro.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
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
          );
        });
  }

  danceSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: danceSelectorDialog,
        child: Card(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage('assets/images/app/interests/dans.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
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
            selectedColor: Colors.black26,
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
          );
        });
  }

  visualArtSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: visualArtSelectorDialog,
        child: Card(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/app/interests/gorsel_sanatlar.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
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
            selectedColor: Colors.black26,
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
          );
        });
  }

  void updateGroupInterests() async {
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
      isUpdated = false;
    });
  }
}
