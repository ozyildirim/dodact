import 'package:dodact_v1/model/group_model.dart';
import 'package:flutter/material.dart';

class GroupDetailPage extends StatefulWidget {
  final GroupModel groupModel;

  const GroupDetailPage({Key key, this.groupModel}) : super(key: key);

  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: Container(
              child: Center(child: Text(widget.groupModel.groupName)),
            )));
  }
}
