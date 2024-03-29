import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/event/widgets/parallax_events.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:dodact_v1/utilities/lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends BaseState<EventsPage> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> _categoryDialogKey =
      GlobalKey<FormBuilderState>();

  ScrollController scrollController;
  EventProvider eventProvider;
  bool isLoading = false;

  bool isFiltered = false;
  List<String> selectedCategory = [];
  String selectedCity;
  String selectedType;

  @override
  void initState() {
    super.initState();
    eventProvider = Provider.of<EventProvider>(context, listen: false);
    scrollController = ScrollController();

    scrollController.addListener(scrollListener);

    if (eventProvider.eventsSnapshot.isEmpty) {
      eventProvider.getEventList();
    }
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
            categories: selectedCategory,
            city: selectedCity,
            type: selectedType);
      }
    }
  }

  Future<void> refreshEventsPage() {
    setState(() {
      isLoading = true;
    });
    return Future(() async {
      if (isFiltered) {
        eventProvider.filteredEventsSnapshot.clear();
        await eventProvider.getFilteredEventList(
            reset: true,
            categories: selectedCategory,
            city: selectedCity,
            type: selectedType);
        setState(() {
          isLoading = false;
        });
      } else {
        eventProvider.eventsSnapshot.clear();
        eventProvider.getEventList();
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<EventProvider>(context);
    if (isLoading) {
      return Center(child: spinkit);
    } else {
      return RefreshIndicator(
        onRefresh: refreshEventsPage,
        color: kNavbarColor,
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: kToolbarHeight),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                // showFilterDialog();
                showFilterBottomSheet();
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
            child: buildBody(provider),
          ),
        ),
      );
    }
  }

  buildBody(EventProvider provider) {
    var size = MediaQuery.of(context).size;
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
      } else if (provider.filteredEventsSnapshot.isEmpty) {
        return Container(
          height: size.height,
          child: Center(
            child: Text(
              "Bu kriterlere uyan bir etkinlik bulunamadı",
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        return Center(
          child: spinkit,
        );
      }
    } else {
      if (provider.eventsSnapshot.isNotEmpty) {
        return ListView.builder(
            controller: scrollController,
            itemCount: provider.events.length,
            itemBuilder: (context, index) {
              var event = provider.events[index];
              if (event.eventImages.isNotEmpty && event.eventImages != null) {
                return Container(
                    height: size.height * 0.3,
                    child: ParallaxEvent(event: event));
              } else {
                return Container();
              }
            });
      } else {
        return Container(
          height: size.height,
          child: Center(
            child: Text(
              "Bu kriterlere uyan bir etkinlik bulunamadı",
              style: TextStyle(fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  void updateEvents(List<String> categories, String city, String type) async {
    try {
      await Provider.of<EventProvider>(context, listen: false)
          .getFilteredEventList(
        reset: true,
        categories: categories,
        city: city,
        type: type,
      );
    } catch (e) {
      print(e);
    }
  }

  submitFilterDialog() {
    if (_formKey.currentState.saveAndValidate()) {
      if (_formKey.currentState.value["city"] != null ||
          _formKey.currentState.value["type"] != null ||
          selectedCategory.isNotEmpty) {
        setState(() {
          isFiltered = true;
          selectedCity = _formKey.currentState.value["city"];

          selectedType = _formKey.currentState.value["type"];
        });
        print("$selectedCity  $selectedCategory $selectedType");
        updateEvents(selectedCategory, selectedCity, selectedType);
        NavigationService.instance.pop();
      } else {
        setState(() {
          isFiltered = false;
          eventProvider.getEventList();
          _formKey.currentState.reset();
          selectedCategory = [];
          selectedCity = null;
          selectedType = null;
        });
        NavigationService.instance.pop();
      }
    }
  }

  showFilterBottomSheet() {
    var size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (context, state) {
          return FormBuilder(
            key: _formKey,
            child: new Container(
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 5.0,
                bottom: 5.0,
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                ),
              ),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    title: const Text(
                      'Filtre',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: size.width * 0.4,
                          child: Text(
                            "Şehir",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              color: Colors.grey[200],
                              width: size.width * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, left: 16, right: 4),
                                child: FormBuilderDropdown(
                                    isExpanded: true,
                                    initialValue: selectedCity ?? null,
                                    name: "city",
                                    decoration: InputDecoration(
                                      hintText: "Şehir Seçin",
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    items: buildCityDropdownItems()),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: size.width * 0.4,
                          child: Text(
                            "Kategori",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              color: Colors.grey[200],
                              width: size.width * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, left: 16, right: 4),
                                child: FormBuilderTextField(
                                  readOnly: true,
                                  initialValue: selectedCategory != null
                                      ? "${selectedCategory.length.toString()} Kategori Seçildi"
                                      : null,
                                  key: Key(selectedCategory != null
                                      ? "${selectedCategory.length.toString()} Kategori Seçildi"
                                      : null),
                                  name: "category",
                                  onTap: () {
                                    openCategoryDialog(state);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Kategori Seçin",
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (selectedCategory.length > 10) {
                                      return "En fazla 10 kategori seçebilirsiniz";
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: size.width * 0.4,
                          child: Text(
                            "Tür",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              color: Colors.grey[200],
                              width: size.width * 0.4,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, left: 16, right: 4),
                                child: FormBuilderDropdown(
                                  initialValue: selectedType ?? null,
                                  name: "type",
                                  decoration: InputDecoration(
                                    hintText: "Tür Seçin",
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  items: buildEventTypeDropdownItems(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Divider(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: new ListTile(
                          title: const Text(
                            'Uygula',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () async {
                            submitFilterDialog();
                          },
                        ),
                      ),
                      Container(
                        width: size.width * 0.4,
                        child: new ListTile(
                          title: const Text(
                            'Temizle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () async {
                            if (isFiltered) {
                              setState(() {
                                isFiltered = false;
                                eventProvider.getEventList();
                                _formKey.currentState.reset();
                                selectedCategory = [];
                                selectedCity = null;
                                selectedType = null;
                              });
                            }
                            NavigationService.instance.pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  openCategoryDialog(StateSetter updateState) async {
    categoryList.sort((a, b) => a.compareTo(b));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectDialog(
            initialValue: selectedCategory,
            selectedColor: kNavbarColor,
            selectedItemsTextStyle: TextStyle(color: Colors.white),
            items: categoryList.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            searchable: true,
            title: Text("Kategoriler"),
            onSelectionChanged: (list) {
              if (list.length > 10) {
                CustomMethods.showSnackbar(
                    context, "En fazla 10 kategori seçebilirsiniz.");
              }
            },
            confirmText: Text("Tamam", style: TextStyle(color: Colors.black)),
            cancelText: Text("İptal", style: TextStyle(color: Colors.black)),
            onConfirm: (list) {
              if (list.length > 0) {
                print(list);
                updateState(() {
                  selectedCategory = list;
                });
              } else {
                updateState(() {
                  selectedCategory = [];
                });
              }
            },
          );
        });
  }

  buildCityDropdownItems() {
    return cities
        .map((e) => DropdownMenuItem(
              alignment: AlignmentDirectional.centerStart,
              value: e,
              child: Center(
                  child: Text(e,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis)),
            ))
        .toList();
  }

  // buildArtCategoryDropdownItems() {
  //   return interestCategoryList
  //       .map((category) => DropdownMenuItem(
  //             value: category.name,
  //             child: Center(
  //               child: Text(
  //                 category.name,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //           ))
  //       .toList();
  // }

  buildEventTypeDropdownItems() {
    return eventTypes
        .map((type) => DropdownMenuItem(
              value: type,
              child: Center(
                child: Text(
                  type,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ))
        .toList();
  }
}
