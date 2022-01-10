import 'package:dodact_v1/provider/version_control_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VersionControlPage extends StatefulWidget {
  @override
  State<VersionControlPage> createState() => _VersionControlPageState();
}

class _VersionControlPageState extends State<VersionControlPage> {
  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<VersionControlProvider>(context);
    print("versiyon kontrol çalıştı");

    provider.checkAppStatus();

    return Center(child: CircularProgressIndicator());
  }
}
