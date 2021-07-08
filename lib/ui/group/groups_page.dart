import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/group/widgets/filtered_group_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  void initState() {
    super.initState();
  }

  String selectedCategory = "Müzik";
  String selectedCity = "İstanbul";
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final groupProvider = Provider.of<GroupProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height - 56,
          color: Color(0xFFF1F0F2),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildFilterBar(),
              ),
              FilteredGroupView()
            ],
          ),
        ),
      )),
    );
  }

  Container _buildFilterBar() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20),
          GestureDetector(
            child: filterCardContainer(selectedCity),
            onTap: () {
              _showCityPicker();
            },
          ),
          GestureDetector(
            child: filterCardContainer(selectedCategory),
            onTap: () {
              _showCategoryPicker();
            },
          ),
        ],
      ),
    );
  }

  Future _showCategoryPicker() {
    return showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 120,
        child: Center(
            child: HorizontalCardPager(
          initialPage: 1,
          onPageChanged: (page) {
            setState(() {
              selectedCategory = categoryItemValues[page.toInt()];
            });
            updateGroupsByFilter(selectedCategory, selectedCity);
          },
          onSelectedItem: (page) {
            setState(() {
              selectedCategory = categoryItemValues[page];

              updateGroupsByFilter(selectedCategory, selectedCity);
            });
          },
          items: categoryItems,
        )),
      ),
    );
  }

  Container filterCardContainer(String interest) {
    return Container(
      width: 140,
      height: 60,
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
          ),
        ),
      ),
    );
  }

  List<String> categoryItemValues = ["Tümü", "Müzik", "Tiyatro", "Dans"];
  List<CardItem> categoryItems = [
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
      iconData: FontAwesome5Solid.star,
    ),
  ];

  //TODO: kategori ile birlikte şehir bilgisini de sorgulatarak gruplar getirilmeli, bunu servise ekle.

  void updateGroupsByCategory(String category) async {
    if (category == "Tümü") {
      await Provider.of<GroupProvider>(context, listen: false).getGroupList();
    } else {
      await Provider.of<GroupProvider>(context, listen: false)
          .getGroupListByCategory(category);
    }
  }

  void updateGroupsByFilter(String category, String city) async {
    if (category == "Tümü" && city == "Tüm Şehirler") {
      await Provider.of<GroupProvider>(context, listen: false)
          .getFilteredGroupList(showAllCategories: true, wholeCountry: true);
    } else if (category == "Tümü" && city != "Tüm Şehirler") {
      await Provider.of<GroupProvider>(context, listen: false)
          .getFilteredGroupList(
              city: selectedCity, showAllCategories: true, wholeCountry: false);
    } else if (category != "Tümü" && city == "Tüm Şehirler") {
      await Provider.of<GroupProvider>(context, listen: false)
          .getFilteredGroupList(
              category: category, wholeCountry: true, showAllCategories: false);
    } else {
      await Provider.of<GroupProvider>(context, listen: false)
          .getFilteredGroupList(
              category: category,
              city: city,
              showAllCategories: false,
              wholeCountry: false);
    }
  }

  Future<String> _showCityPicker() {
    return showMaterialScrollPicker<String>(
      context: context,
      title: 'Pick Your State',
      items: cities,
      selectedItem: selectedCity,
      onChanged: (value) {
        setState(() => selectedCity = value);
        updateGroupsByFilter(selectedCategory, selectedCity);
      },
    );
  }
}
