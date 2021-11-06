import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            //TODO: Buunu düzenle
            'İnternet bağlantınız yok :(',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
