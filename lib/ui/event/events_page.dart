import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/event/filtered_events_page.dart';
import 'package:dodact_v1/ui/event/widgets/parallax_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends BaseState<EventsPage> {
  bool isFiltered = false;
  String selectedCategory;
  int selectedCategoryIndex = 0;
  String selectedCity;
  String selectedType;
  int selectedTypeIndex = 0;

  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false).getAllEventsList();
    super.initState();

    selectedCategory = "Tümü";
    selectedCity = "İstanbul";
    selectedType = "Açık Hava Etkinliği";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => _refreshEvents(),
          child: Container(
              height: dynamicHeight(1),
              width: double.infinity,
              child: Column(
                children: [
                  _buildFilterBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: FilteredEventView(),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Container _buildFilterBar() {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: filterCardContainer(selectedCity, Icon(Icons.location_on)),
            onTap: () {
              _showCityPicker();
            },
          ),
          GestureDetector(
            child: filterCardContainer(selectedCategory, Icon(Icons.category)),
            onTap: () {
              _showCategoryPicker();
            },
          ),
          GestureDetector(
            child: filterCardContainer(selectedType, Icon(Icons.category)),
            onTap: () {
              _showTypePicker();
            },
          ),
        ],
      ),
    );
  }

  Future<String> _showCityPicker() {
    return showMaterialScrollPicker<String>(
      context: context,
      title: 'Lokasyon Seçiniz',
      items: cities,
      selectedItem: selectedCity,
      onChanged: (value) {
        setState(() => selectedCity = value);
        updateEventsByFilter(selectedCategory, selectedCity, selectedType);
      },
    );
  }

  Container filterCardContainer(String interest, Icon icon) {
    return Container(
      width: dynamicWidth(0.3),
      height: dynamicHeight(0.2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Flexible(
                child: Container(
                  child: Text(
                    interest,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
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
          initialPage: selectedCategoryIndex,
          onPageChanged: (page) {
            setState(() {
              selectedCategoryIndex = page.toInt();
              selectedCategory = categoryItemValues[page.toInt()];
            });
            updateEventsByFilter(selectedCategory, selectedCity, selectedType);
          },
          onSelectedItem: (page) {
            setState(() {
              selectedCategoryIndex = page.toInt();
              selectedCategory = categoryItemValues[page];

              updateEventsByFilter(
                  selectedCategory, selectedCity, selectedType);
            });
          },
          items: categoryItems,
        )),
      ),
    );
  }

  Future _showTypePicker() {
    return showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 120,
        child: Center(
            child: HorizontalCardPager(
          initialPage: selectedTypeIndex,
          onPageChanged: (page) {
            setState(() {
              selectedTypeIndex = page.toInt();
              selectedType = typeItemValues[page.toInt()];
            });
            updateEventsByFilter(selectedCategory, selectedCity, selectedType);
          },
          onSelectedItem: (page) {
            setState(() {
              selectedTypeIndex = page.toInt();
              selectedType = typeItemValues[page];

              updateEventsByFilter(
                  selectedCategory, selectedCity, selectedType);
            });
          },
          items: typeItems,
        )),
      ),
    );
  }

  void updateEventsByFilter(String category, String city, String type) async {
    if (category == "Tümü" && city == "Belirtilmemiş" && type == "Tümü") {
      await Provider.of<EventProvider>(context, listen: false)
          .getFilteredEventList(
              showAllCategories: true, wholeCountry: true, showAllTypes: true);
    } else if (category == "Tümü" &&
        city == "Belirtilmemiş" &&
        type != "Tümü") {
      await Provider.of<EventProvider>(context, listen: false)
          .getFilteredEventList(
              city: city,
              type: type,
              showAllCategories: true,
              wholeCountry: false,
              showAllTypes: false);
    } else if (category == "Tümü" &&
        city != "Belirtilmemiş" &&
        type == "Tümü") {
      await Provider.of<EventProvider>(context, listen: false)
          .getFilteredEventList(
              city: city,
              wholeCountry: true,
              showAllTypes: true,
              showAllCategories: false);
    } else if (category == "Tümü" &&
        city != "Belirtilmemiş" &&
        type != "Tümü") {
      await Provider.of<EventProvider>(context, listen: false)
          .getFilteredEventList(
              city: city,
              type: type,
              wholeCountry: false,
              showAllTypes: false,
              showAllCategories: true);
    } else if (category != "Tümü" &&
        city == "Belirtilmemiş" &&
        type == "Tümü") {
      await Provider.of<EventProvider>(context, listen: false)
          .getFilteredEventList(
              category: category,
              wholeCountry: true,
              showAllTypes: true,
              showAllCategories: false);
    } else if (category != "Tümü" &&
        city == "Belirtilmemiş" &&
        type != "Tümü") {
      await Provider.of<EventProvider>(context, listen: false)
          .getFilteredEventList(
              city: city,
              category: category,
              wholeCountry: true,
              showAllTypes: false,
              showAllCategories: false);
    } else {
      await Provider.of<EventProvider>(context, listen: false)
          .getFilteredEventList(
              category: category,
              city: city,
              type: type,
              showAllCategories: false,
              showAllTypes: false,
              wholeCountry: false);
    }
  }

  List<String> categoryItemValues = ["Tümü", "Müzik", "Tiyatro", "Dans"];
  List<String> typeItemValues = [
    "Tümü",
    "Açık Hava Etkinliği",
    "Kapalı Mekan Etkinliği",
    "Workshop"
  ];

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

  List<CardItem> typeItems = [
    IconTitleCardItem(
      text: "Tümü",
      iconData: Icons.all_inclusive,
    ),
    IconTitleCardItem(
      text: "Açık Hava Etkinliği",
      iconData: Icons.music_note,
    ),
    IconTitleCardItem(
      text: "Kapalı Mekan Etkinliği",
      iconData: Icons.theater_comedy,
    ),
    IconTitleCardItem(
      text: "Workshop",
      iconData: FontAwesome5Solid.star,
    ),
  ];

  Future<void> _refreshEvents() async {
    await Provider.of<EventProvider>(context, listen: false).getAllEventsList();
  }
}
