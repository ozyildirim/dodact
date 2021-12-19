import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
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
        title: Text('Example'),
      ),
      body: Container(
        height: dynamicHeight(1),
        width: dynamicWidth(1),
        child: MultiSelectDialog(
          items: categoryList.map((e) {
            return MultiSelectItem(e, e);
          }).toList(),
          initialValue: selectedInterests,
        ),
      ),
    );
  }
}
