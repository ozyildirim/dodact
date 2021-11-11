import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';

class AnnouncementPart extends StatefulWidget {
  @override
  _AnnouncementPartState createState() => _AnnouncementPartState();
}

class _AnnouncementPartState extends State<AnnouncementPart> {
  List<String> imageList = [
    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/dodact_duyuru%2Fsoylesi.png?alt=media&token=eed28f61-1e52-4c73-986c-eae29a1cd20b",
    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/dodact_duyuru%2Fsoylesi.png?alt=media&token=eed28f61-1e52-4c73-986c-eae29a1cd20b",
    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/dodact_duyuru%2Fsoylesi.png?alt=media&token=eed28f61-1e52-4c73-986c-eae29a1cd20b",
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
              child: Image.network(url, fit: BoxFit.cover, width: 1000.0),
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
