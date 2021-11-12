import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';

class AnnouncementPart extends StatefulWidget {
  @override
  _AnnouncementPartState createState() => _AnnouncementPartState();
}

class _AnnouncementPartState extends State<AnnouncementPart> {
  List<String> imageList = [
    "assets/images/soylesi3.png",
    "assets/images/soylesi3.png",
    "assets/images/soylesi3.png",
  ];

  @override
  Widget build(BuildContext context) {
    return GFCarousel(
      autoPlay: true,
      activeIndicator: Colors.black,
      passiveIndicator: Colors.grey,
      items: imageList.map(
        (url) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Image.asset(url, fit: BoxFit.cover, width: 1000.0),
            ),
          );
        },
      ).toList(),
      onPageChanged: (index) {
        setState(() {});
      },
    );
  }
}
