import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/cities.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/ui/event/filtered_events_page.dart';
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
  bool isFiltered = false;
  String selectedCategory;
  String selectedCity;
  String selectedType;

  @override
  void initState() {
    Provider.of<EventProvider>(context, listen: false).getAllEventsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: RefreshIndicator(
          onRefresh: () => _refreshEvents(),
          child: Container(
            height: dynamicHeight(1),
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: FilteredEventView(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container filterCardContainer(Widget text, Widget icon,
      {double width, double height}) {
    return Container(
      width: width,
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: text),
              Container(
                width: dynamicWidth(0.1),
                child: icon,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateEventsByFilter(String category, String city, String type) async {
    await Provider.of<EventProvider>(context, listen: false)
        .getFilteredEventList(category: category, city: city, type: type);
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

  Future<void> _refreshEvents() async {
    updateEventsByFilter(selectedCategory, selectedCity, selectedType);
  }

  Future<void> showFilterDialog() async {
    showDialog(context: context, builder: (ctx) => FilterDialog());
  }

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Dialog FilterDialog() {
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
        selectedType = _formKey.currentState.value["type"];
      });
      updateEventsByFilter(selectedCategory, selectedCity, selectedType);
      NavigationService.instance.pop();
    }
  }
}
