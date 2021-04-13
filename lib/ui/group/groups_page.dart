import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/group/widgets/filtered_groups.dart';
import 'package:dodact_v1/ui/group/widgets/random_groups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_scroll_picker.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends BaseState<GroupsPage> {
  GroupProvider _groupProvider;
  int tappedIndex;

  String selectedCategory = "Tümü";
  String selectedCity = "Eskişehir";

  final List<Widget> _pageBody = [FilteredGroups(), RandomGroups()];

  @override
  void initState() {
    super.initState();
    tappedIndex = 0;
    _groupProvider = getProvider<GroupProvider>();
    _groupProvider.getGroupList(isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(child: Consumer<GroupProvider>(
          builder: (_, provider, child) {
            if (provider.groupList != null) {
              if (provider.groupList.isNotEmpty) {
                List<GroupModel> groups = provider.groupList;
                print(provider.groupList.length);
                return Container(
                  height: dynamicHeight(1),
                  color: Color(0xFFF1F0F2),
                  child: Column(
                    children: [
                      customAppBar(),
                      filterBar(),
                      _pageBody[tappedIndex]
                    ],
                  ),
                );
              } else {
                return Center(
                  child: spinkit,
                );
              }
            } else {
              return Center(child: spinkit);
            }
          },
        )),
      ),
    );
  }

  Container customAppBar() {
    return Container(
      decoration: BoxDecoration(
          color: kCustomAppBarColor,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          )),
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          menuButtons('ARA', 0),
          menuButtons('KEŞFET', 1),
          menuButtons('YAKINDA', 2),
        ],
      ),
    );
  }

  RaisedButton menuButtons(String menuName, int menuIndex) {
    // ignore: deprecated_member_use
    return RaisedButton(
        color: tappedIndex == menuIndex ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40.0)),
        onPressed: () {
          setState(() {
            tappedIndex = menuIndex;
          });
        },
        child: Text(
          menuName,
          style: TextStyle(
            color: tappedIndex == menuIndex ? Colors.black : Colors.grey,
          ),
        ));
  }

  Container filterBar() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20),
          GestureDetector(
            child: filterCardContainer(selectedCity),
            onTap: () {
              showMaterialScrollPicker(
                context: context,
                title: "Şehir Seçin",
                showDivider: false,
                items: cities,
                values: cities,
                selectedValue: cities[0],
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                    print(selectedCity);
                  });
                },
                confirmText: "TAMAM",
                cancelText: "VAZGEÇ",
                headerColor: Colors.brown,
                onCancelled: () => print("Scroll Picker cancelled"),
                onConfirmed: () => print("Scroll Picker confirmed"),
              );
            },
          ),
          GestureDetector(
            child: filterCardContainer(selectedCategory),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => Container(
                  height: 120,
                  child: Center(
                      child: HorizontalCardPager(
                    initialPage: 0,
                    onPageChanged: (page) {
                      setState(() {
                        selectedCategory = itemValues[page.toInt()];
                        print(selectedCategory);
                        updateGroupsByCategory(selectedCategory);
                      });
                    },
                    onSelectedItem: (page) {
                      setState(() {
                        selectedCategory = itemValues[page];
                        print(selectedCategory);
                        updateGroupsByCategory(selectedCategory);
                      });
                    },
                    items: items,
                  )),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Container filterCardContainer(String interest) {
    return Container(
        width: 120,
        height: 40,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.location_on),
                Text(interest),
              ],
            ))));
  }

  List<CardItem> items = [
    IconTitleCardItem(
      text: "Tümü",
      iconData: Icons.all_inclusive,
    ),
    IconTitleCardItem(
      text: "Müzik",
      iconData: Icons.music_note,
    ),
    IconTitleCardItem(
      text: "Tiyatro",
      iconData: Icons.theater_comedy,
    ),
    IconTitleCardItem(
      text: "Dans",
      iconData: FontAwesome5Solid.star_of_david,
    ),
  ];

  List<String> itemValues = ["Tümü", "Müzik", "Tiyatro", "Dans"];

  //TODO: kategori ile birlikte şehir bilgisini de sorgulatarak gruplar getirilmeli, bunu servise ekle.

  void updateGroupsByCategory(String category) async {
    if (category == "Tümü") {
      await _groupProvider.getGroupList();
      setState(() {});
    } else {
      await _groupProvider.getGroupsByCategory(category);
      setState(() {});
    }
  }
}
