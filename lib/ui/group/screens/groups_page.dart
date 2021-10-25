import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/group/screens/filtered_group_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  String selectedCategory;
  String selectedCity;

  @override
  void initState() {
    super.initState();
    Provider.of<GroupProvider>(context, listen: false).getFilteredGroupList();
  }

  List<FormBuilderFieldOption<dynamic>> categoryOptions = [
    FormBuilderFieldOption(value: "Müzik", child: Text("Müzik")),
    FormBuilderFieldOption(value: "Tiyatro", child: Text("Tiyatro")),
    FormBuilderFieldOption(
        value: "Görsel Sanatlar", child: Text("Görsel Sanatlar")),
    FormBuilderFieldOption(value: "Dans", child: Text("Dans")),
  ];

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final groupProvider = Provider.of<GroupProvider>(context);

    final mediaQuery = MediaQuery.of(context);
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        height: mediaQuery.size.height - 56,
        child: SingleChildScrollView(
          child: FilteredGroupView(),
        ),
      ),
    );
  }

  Future<void> showFilterDialog() async {
    showDialog(context: context, builder: (ctx) => filterDialog());
  }

  Dialog filterDialog() {
    var size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.4,
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
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
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
                      NavigationService.instance.pop();
                    },
                    text: "Vazgeç",
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
        selectedCity = _formKey.currentState.value["city"];
        selectedCategory = _formKey.currentState.value["category"];
        print(selectedCategory);
        print(selectedCity);
      });
      updateGroupsByFilter(selectedCategory, selectedCity);
      NavigationService.instance.pop();
    }
  }

  void updateGroupsByFilter(String category, String city) async {
    await Provider.of<GroupProvider>(context, listen: false)
        .getFilteredGroupList(category: category, city: city);
  }
}
