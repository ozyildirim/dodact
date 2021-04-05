import 'package:flutter/material.dart';

class UserOptionsPage extends StatefulWidget {
  @override
  _UserOptionsPageState createState() => _UserOptionsPageState();
}

class _UserOptionsPageState extends State<UserOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
