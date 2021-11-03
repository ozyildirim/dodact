import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';

import 'package:dodact_v1/ui/event/widgets/parallax_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends BaseState<EventsPage> {
  ScrollController scrollController;
  EventProvider eventProvider;

  bool isFiltered = false;
  String selectedCategory;
  String selectedCity;
  String selectedType;

  @override
  void initState() {
    super.initState();
    eventProvider = Provider.of<EventProvider>(context, listen: false);
    scrollController = ScrollController();

    scrollController.addListener(scrollListener);
    eventProvider.getEventList();
  }

  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (!isFiltered) {
        eventProvider.getEventList();
      } else {
        eventProvider.getFilteredEventList(
            reset: false,
            category: selectedCategory,
            city: selectedCity,
            type: selectedType);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: kToolbarHeight),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            showFilterDialog();
          },
          child: Icon(
            Icons.filter_list_rounded,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<EventProvider>(
          builder: (_, provider, child) {
            if (isFiltered) {
              if (provider.filteredEventsSnapshot.isNotEmpty) {
                return ListView.builder(
                    controller: scrollController,
                    itemCount: provider.filteredEvents.length,
                    itemBuilder: (context, index) {
                      var event = provider.filteredEvents[index];
                      return Container(
                          height: size.height * 0.3,
                          child: ParallaxEvent(event: event));
                    });
              } else {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/app/situations/not_found.png"),
                      Text(
                        "Bu kriterlere uyan bir etkinlik bulunamadı.",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: kToolbarHeight,
                      )
                    ],
                  ),
                );
              }
            } else {
              if (provider.eventsSnapshot.isNotEmpty) {
                return ListView.builder(
                    controller: scrollController,
                    itemCount: provider.events.length,
                    itemBuilder: (context, index) {
                      var event = provider.events[index];
                      return Container(
                          height: size.height * 0.3,
                          child: ParallaxEvent(event: event));
                      ;
                    });
              } else {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/app/situations/not_found.png"),
                      Text(
                        "Bu kriterlere uyan bir etkinlik bulunamadı.",
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: kToolbarHeight,
                      )
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  List<EventModel> _sortEvents(List<EventModel> events) {
    events.sort((a, b) {
      var firstEventDate = a.eventStartDate;
      var secondEventDate = b.eventStartDate;
      return firstEventDate.compareTo(secondEventDate);
    });

    return events;
  }

  void updateEvents(String category, String city, String type) async {
    try {
      await Provider.of<EventProvider>(context, listen: false)
          .getFilteredEventList(
        reset: true,
        category: category,
        city: city,
        type: type,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> showFilterDialog() async {
    showDialog(context: context, builder: (ctx) => filterDialog());
  }

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Dialog filterDialog() {
    var size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.6,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Filtre",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Şehir"),
                    Container(
                      width: size.width * 0.6,
                      child: FormBuilderDropdown(
                          initialValue: selectedCity ?? null,
                          name: "city",
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          items: cities.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            );
                          }).toList()),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kategori"),
                    Container(
                      width: size.width * 0.6,
                      child: FormBuilderChoiceChip(
                        padding: EdgeInsets.all(5),
                        initialValue: selectedCategory ?? null,
                        name: "category",
                        options: categoryOptions,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        "Tür",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: size.width * 0.6,
                      child: FormBuilderChoiceChip(
                        initialValue: selectedType ?? null,
                        name: "type",
                        options: typeOptions,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GFButton(
                    color: Colors.orange[700],
                    shape: GFButtonShape.pills,
                    onPressed: () {
                      submitFilterDialog();
                    },
                    text: "Tamam",
                    textStyle: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Raleway"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GFButton(
                    color: Colors.orange[700],
                    shape: GFButtonShape.pills,
                    onPressed: () {
                      if (isFiltered) {
                        setState(() {
                          isFiltered = false;
                          eventProvider.getEventList();
                          _formKey.currentState.reset();
                          selectedCategory = null;
                          selectedCity = null;
                          selectedType = null;
                        });
                      }
                      NavigationService.instance.pop();
                    },
                    text: "Temizle",
                    textStyle: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Raleway"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  submitFilterDialog() {
    if (_formKey.currentState.saveAndValidate()) {
      setState(() {
        isFiltered = true;
        selectedCity = _formKey.currentState.value["city"];
        selectedCategory = _formKey.currentState.value["category"];
        selectedType = _formKey.currentState.value["type"];
      });
      print("$selectedCity  $selectedCategory $selectedType");
      updateEvents(selectedCategory, selectedCity, selectedType);
      NavigationService.instance.pop();
    }
  }

  List<FormBuilderFieldOption<dynamic>> categoryOptions = [
    FormBuilderFieldOption(value: "Müzik", child: Text("Müzik")),
    FormBuilderFieldOption(value: "Tiyatro", child: Text("Tiyatro")),
    FormBuilderFieldOption(
        value: "Görsel Sanatlar", child: Text("Görsel Sanatlar")),
    FormBuilderFieldOption(value: "Dans", child: Text("Dans")),
  ];

  List<FormBuilderFieldOption<dynamic>> typeOptions = [
    FormBuilderFieldOption(
        value: "Açık Hava Etkinliği", child: Text("Açık Hava Etkinliği")),
    FormBuilderFieldOption(
        value: "Kapalı Mekan Etkinliği", child: Text("Kapalı Mekan Etkinliği")),
    FormBuilderFieldOption(value: "Workshop", child: Text("Workshop")),
    FormBuilderFieldOption(value: "Online", child: Text("Online")),
  ];
}
