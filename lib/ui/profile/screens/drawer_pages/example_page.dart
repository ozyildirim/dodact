import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends BaseState<ExamplePage> {
  List<String> selectedInterests;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12),
          child: Text("İlgi Alanlarını Seç",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        SingleChildScrollView(
          child: MultiSelectChipField(
            decoration: BoxDecoration(),
            selectedChipColor: kNavbarColor,
            selectedTextStyle: TextStyle(color: Colors.white),
            title: Text("İlgi Alanlarını Seç",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
            initialValue: selectedInterests,
          ),
        )
      ],
    );
  }
}
