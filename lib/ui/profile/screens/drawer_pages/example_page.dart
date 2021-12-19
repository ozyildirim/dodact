import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends BaseState<ExamplePage> {
  GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();
  List<String> selectedInterests;

  @override
  void initState() {
    super.initState();
    selectedInterests = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light,
        ), // For iOS (dark icons)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        height: dynamicHeight(1),
        width: dynamicWidth(1),
        child: buildChipField(),
      ),
    );
  }

  buildChipField() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12),
            child: Text("İlgi Alanlarını Seç",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12),
            child: Text(
                "Diğer sanatseverler ne ile ilgilendiğini görsün! Uygulama içindeki maceranı özelleştirmek için ilgilendiğin alanları seç.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: MultiSelectChipField(
                  key: formKey,
                  decoration: BoxDecoration(), chipColor: Colors.grey[200],
                  selectedChipColor: kNavbarColor,
                  selectedTextStyle: TextStyle(color: Colors.white),
                  textStyle: TextStyle(color: Colors.black),
                  // title: Text("İlgi Alanlarını Seç",
                  //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  title: Text(""),
                  headerColor: Colors.transparent,
                  searchHint: "Ara",
                  scroll: false,
                  searchable: true,
                  showHeader: true,
                  chipShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    // side: BorderSide(color: Colors.grey, width: 1),
                  ),
                  items: categoryList.map((e) {
                    return MultiSelectItem(e, e);
                  }).toList(),
                  // itemBuilder: (item, state) {
                  //   return InkWell(
                  //     onTap: () {
                  //       selectedInterests.contains(item.value)
                  //           ? selectedInterests.remove(item.value)
                  //           : selectedInterests.add(item.value);
                  //       state.didChange(selectedInterests);
                  //       formKey.currentState.validate();
                  //     },
                  //     child: Chip(
                  //       label: Text(item.label),
                  //     ),
                  //   );
                  // },
                  initialValue: selectedInterests,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
