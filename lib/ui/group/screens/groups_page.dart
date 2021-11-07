import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/widgets/group_card.dart';
import 'package:dodact_v1/utilities/lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  GroupProvider groupProvider;
  ScrollController scrollController;
  String selectedCategory;
  String selectedCity;
  bool isFiltered = false;

  @override
  void initState() {
    super.initState();
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    scrollController = ScrollController();

    scrollController.addListener(scrollListener);
    groupProvider.getGroupList();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
        child: Consumer<GroupProvider>(
          builder: (_, provider, child) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/app/situations/not_found.png"),
                      Text(
                        "Bu kriterlere uyan bir topluluk bulunamadı.",
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

  submitFilterDialog() {
    if (_formKey.currentState.saveAndValidate()) {
      if (_formKey.currentState.value['city'] != null)
      // ||
      //     _formKey.currentState.value['category'] != null
      {
        setState(() {
          isFiltered = true;
          selectedCity = _formKey.currentState.value["city"];
          // selectedCategory = _formKey.currentState.value["category"];
        });
        updateGroups(null, selectedCity);
        print(selectedCity);
        NavigationService.instance.pop();
      } else {
        NavigationService.instance.pop();
      }
    }
  }

  void updateGroups(String category, String city) async {
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
                              padding: const EdgeInsets.all(4.0),
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       Container(
                //         width: size.width * 0.4,
                //         child: Text(
                //           "Kategori",
                //           style: TextStyle(
                //             fontSize: 20.0,
                //             fontWeight: FontWeight.w700,
                //           ),
                //         ),
                //       ),
                //       Center(
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(24),
                //           child: Container(
                //             color: Colors.grey[200],
                //             width: size.width * 0.4,
                //             child: Padding(
                //               padding: const EdgeInsets.all(4.0),
                //               child: FormBuilderDropdown(
                //                 initialValue: selectedCategory ?? null,
                //                 name: "category",
                //                 decoration: InputDecoration(
                //                   hintText: "Kategori Seçin",
                //                   contentPadding: EdgeInsets.zero,
                //                   border: OutlineInputBorder(
                //                     borderSide: BorderSide.none,
                //                     borderRadius: BorderRadius.circular(15),
                //                   ),
                //                 ),
                //                 items: buildArtCategoryDropdownItems(),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
      },
    );
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

  buildArtCategoryDropdownItems() {
    return artCategories
        .map((category) => DropdownMenuItem(
              value: category,
              child: Center(
                child: Text(
                  category,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ))
        .toList();
  }
}
