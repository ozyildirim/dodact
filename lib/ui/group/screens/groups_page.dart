import 'package:dodact_v1/config/constants/theme_constants.dart';

import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/widgets/group_card.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  GroupProvider groupProvider;
  ScrollController scrollController;
  List<String> selectedCategory = [];
  String selectedCity;
  bool isFiltered = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    scrollController = ScrollController();

    scrollController.addListener(scrollListener);

    if (groupProvider.groupsSnapshot.isEmpty) {
      groupProvider.getGroupList();
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
        groupProvider.getGroupList();
      } else {
        groupProvider.getFilteredGroupList(
          reset: false,
          category: selectedCategory,
          city: selectedCity,
        );
      }
    }
  }

  Future<void> refreshGroupsPage() {
    setState(() {
      isLoading = true;
    });
    return Future(() async {
      if (isFiltered) {
        groupProvider.filteredGroupsSnapshot.clear();
        await groupProvider.getFilteredGroupList(
          reset: true,
          category: selectedCategory,
          city: selectedCity,
        );
        setState(() {
          isLoading = false;
        });
      } else {
        groupProvider.groupsSnapshot.clear();
        groupProvider.getGroupList();
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var provider = Provider.of<GroupProvider>(context);
    if (isLoading) {
      return Center(child: spinkit);
    } else {
      return RefreshIndicator(
        color: kNavbarColor,
        onRefresh: refreshGroupsPage,
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: kToolbarHeight),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                showFilterBottomSheet();
              },
              child: Icon(
                Icons.filter_list_rounded,
                color: Colors.black,
              ),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: AssetImage(kBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            height: size.height - 56,
            child: buildBody(provider),
          ),
        ),
      );
    }
  }

  submitFilterDialog() {
    if (_formKey.currentState.saveAndValidate()) {
      if (_formKey.currentState.value['city'] != null ||
          selectedCategory.isNotEmpty) {
        setState(() {
          isFiltered = true;
          selectedCity = _formKey.currentState.value["city"];
        });
        updateGroups(selectedCategory, selectedCity);
        print(selectedCity);
        Get.back();
      } else {
        isFiltered = false;
        groupProvider.getGroupList();
        _formKey.currentState.reset();
        selectedCategory = [];
        selectedCity = null;
        Get.back();
      }
    }
  }

  void updateGroups(List<String> category, String city) async {
    try {
      await Provider.of<GroupProvider>(context, listen: false)
          .getFilteredGroupList(reset: true, category: category, city: city);
    } catch (e) {
      print(e);
    }
  }

  showFilterBottomSheet() {
    var size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, state) {
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
                        topRight: const Radius.circular(10.0))),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                  groupProvider.getGroupList();
                                  _formKey.currentState.reset();
                                  selectedCategory = null;
                                  selectedCity = null;
                                });
                              }
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
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
                setState(() {
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
                  child: Text(
                e,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              )),
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

  buildBody(GroupProvider provider) {
    if (isFiltered) {
      if (provider.filteredGroupsSnapshot.isNotEmpty) {
        return ListView.builder(
          controller: scrollController,
          itemCount: provider.filteredGroups.length,
          itemBuilder: (context, index) {
            var group = provider.filteredGroups[index];
            return GroupCard(group: group);
          },
        );
      } else {
        return Container(
          child: Center(
            child: Text(
              "Bu kriterlere uyan bir topluluk bulunamadı",
              style: TextStyle(fontSize: kPageCenteredTextSize),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } else {
      if (provider.groupsSnapshot.isNotEmpty) {
        return ListView.builder(
            controller: scrollController,
            itemCount: provider.groups.length,
            itemBuilder: (context, index) {
              var group = provider.groups[index];
              return GroupCard(group: group);
            });
      } else {
        return Container(
          child: Center(
            child: Text(
              "Bu kriterlere uyan bir topluluk bulunamadı",
              style: TextStyle(fontSize: kPageCenteredTextSize),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }
}
