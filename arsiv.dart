import 'package:flutter/material.dart';

Container MetalicCard() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        // Add one stop for each color. Stops should increase from 0 to 1
        stops: [0.1, 0.3, 0.9],
        colors: [
          Color(0xFF71767E).withOpacity(0.5),
          Color(0xFFAAB1BD).withOpacity(0.45),
          Color(0xFF202226).withOpacity(0.56),
        ],
      ),
    ),
    child: PageView(
      scrollDirection: Axis.horizontal,
      // controller: _controller,
      children: [
        Center(
          child: Container(),
        ),
        Center(
          child: Container(),
        ),
        Center(
          child: Container(),
        ),
      ],
    ),
  );
}
