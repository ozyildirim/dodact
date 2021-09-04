import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/utilities/dialogs.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CreationPage extends StatefulWidget {
  @override
  _CreationPageState createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  int space = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        backwardsCompatibility: false,
        title: Text(
          "Oluştur",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      extendBodyBehindAppBar: false,
      body: ListView(
        children: <Widget>[
          Stack(
            children: [
              CurvedListItem(
                textPos: 180,
                boxSize: 240,
                spaceValue: 285,
                title: 'Ekip',
                onTap: () => NavigationService.instance.navigate('/add_group'),
                conImage: AssetImage('assets/images/creation/grup_olustur.jpg'),
              ),
              CurvedListItem(
                textPos: 150,
                boxSize: 246,
                spaceValue: 110,
                title: 'Etkinlik',
                onTap: () async {
                  var eventCategoryData = await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => categoryDialog(context));

                  if (eventCategoryData != null) {
                    var eventTypeData = await showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => eventTypeDialog(context));
                    if (eventTypeData != null) {
                      var eventPlatformData = await showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => eventPlatformDialog(context));
                      if (eventPlatformData != null) {
                        NavigationService.instance
                            .navigate(k_ROUTE_CREATE_EVENT_PAGE, args: [
                          eventCategoryData,
                          eventTypeData,
                          eventPlatformData
                        ]);
                      }
                    }
                  }
                },
                conImage:
                    AssetImage('assets/images/creation/etkinlik_olustur.jpg'),
              ),
              CurvedListItem(
                textPos: 120,
                boxSize: 180,
                spaceValue: 0,
                title: 'İçerik',
                onTap: () async {
                  var postCategoryData = await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => categoryDialog(context));

                  if (postCategoryData != null) {
                    var postTypeData = await showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => postTypeDialog(context));
                    if (postTypeData != null) {
                      NavigationService.instance.navigate(
                          k_ROUTE_CREATE_POST_PAGE,
                          args: [postTypeData, postCategoryData]);
                    }
                  }
                },
                conImage:
                    AssetImage('assets/images/creation/icerik_olustur.jpg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurvedListItem extends StatelessWidget {
  const CurvedListItem(
      {this.title,
      this.conImage,
      this.spaceValue,
      this.boxSize,
      this.textPos,
      this.onTap});

  final String title;
  final AssetImage conImage;
  final int spaceValue;
  final int boxSize;
  final double textPos;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: <Widget>[
        Container(
          child: Column(
            children: [
              Container(
                height: spaceValue.toDouble(),
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: boxSize.toDouble(),
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(80.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: conImage,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 32,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    bottom: textPos * 0.25.toDouble(),
                    child: Container(
                      child: Text(
                        title,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
