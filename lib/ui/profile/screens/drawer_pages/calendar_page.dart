import 'package:flutter/material.dart';

class UserCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Takvimim"),
    //   ),
    //   body: Container(
    //     height: mediaQuery.size.height,
    //     width: mediaQuery.size.width,
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         fit: BoxFit.cover,
    //         image: AssetImage(kBackgroundImage),
    //       ),
    //     ),
    //     child: Container(
    //       color: Colors.amberAccent,
    //       height: 300,
    //       width: mediaQuery.size.width,
    //       child: TableCalendar(
    //         currentDay: DateTime.now(),
    //         firstDay: DateTime.utc(2010, 10, 16),
    //         lastDay: DateTime.utc(2030, 3, 14),
    //         focusedDay: DateTime.now(),
    //       ),
    //     ),
    //   ),
    // );
  }
}
