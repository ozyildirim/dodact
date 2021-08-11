import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

// ignore: must_be_immutable
class CreationPage extends StatefulWidget {
  @override
  _CreationPageState createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  int space = 100;

  @override
  Widget build(BuildContext context) {
    final SimpleDialog postTypeDialog = SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text('İçerik Türü'),
      children: [
        SimpleDialogItem(
          icon: FontAwesome5Solid.image,
          color: Colors.orange,
          text: 'Görüntü',
          onPressed: () {
            Navigator.pop(context, "Görüntü");
          },
        ),
        SimpleDialogItem(
          icon: FontAwesome5Solid.video,
          color: Colors.green,
          text: 'Video',
          onPressed: () {
            Navigator.pop(context, "Video");
          },
        ),
        SimpleDialogItem(
          icon: Icons.audiotrack,
          color: Colors.grey,
          text: 'Ses',
          onPressed: () {
            Navigator.pop(context, "Ses");
          },
        ),
      ],
    );

    final SimpleDialog categoryDialog = SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text('Kategori'),
      children: [
        SimpleDialogItem(
          icon: FontAwesome5Solid.theater_masks,
          color: Colors.orange,
          text: 'Tiyatro',
          onPressed: () {
            Navigator.pop(context, "Tiyatro");
          },
        ),
        SimpleDialogItem(
          icon: FontAwesome5Solid.palette,
          color: Colors.green,
          text: 'Resim',
          onPressed: () {
            Navigator.pop(context, "Resim");
          },
        ),
        SimpleDialogItem(
          icon: FontAwesome5Solid.music,
          color: Colors.grey,
          text: 'Müzik',
          onPressed: () {
            Navigator.pop(context, "Müzik");
          },
        ),
        SimpleDialogItem(
          icon: FontAwesome5Solid.user_ninja,
          color: Colors.grey,
          text: 'Dans',
          onPressed: () {
            Navigator.pop(context, "Dans");
          },
        ),
      ],
    );

    final SimpleDialog eventTypeDialog = SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text('Etkinlik Türü'),
      children: [
        SimpleDialogItem(
          icon: FontAwesome5Solid.theater_masks,
          color: Colors.orange,
          text: 'Açık Hava Etkinliği',
          onPressed: () {
            Navigator.pop(context, "Açık Hava Etkinliği");
          },
        ),
        SimpleDialogItem(
          icon: FontAwesome5Solid.home,
          color: Colors.green,
          text: 'Kapalı Mekan Etkinliği',
          onPressed: () {
            Navigator.pop(context, "Kapalı Mekan Etkinliği");
          },
        ),
        SimpleDialogItem(
          icon: FontAwesome5Solid.shapes,
          color: Colors.grey,
          text: 'Workshop',
          onPressed: () {
            Navigator.pop(context, "Workshop");
          },
        ),
      ],
    );

    final SimpleDialog eventPlatformDialog = SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text('Platform'),
      children: [
        SimpleDialogItem(
          icon: FontAwesome5Solid.city,
          color: Colors.orange,
          text: 'Fiziksel Etkinlik',
          onPressed: () {
            Navigator.pop(context, "Fiziksel Etkinlik");
          },
        ),
        SimpleDialogItem(
          icon: FontAwesome5Solid.globe,
          color: Colors.green,
          text: 'Online Etkinlik',
          onPressed: () {
            Navigator.pop(context, "Online Etkinlik");
          },
        ),
      ],
    );

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
                spaceValue: 440,
                title: 'Topluluk',
                onTap: () =>
                    NavigationService.instance.navigate('/add_community'),
                conImage:
                    AssetImage('assets/images/creation/icerik_olustur.jpg'),
              ),
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
                      builder: (context) => categoryDialog);

                  if (eventCategoryData != null) {
                    var eventTypeData = await showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => eventTypeDialog);
                    if (eventTypeData != null) {
                      var eventPlatformData = await showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => eventPlatformDialog);
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
                      builder: (context) => categoryDialog);

                  if (postCategoryData != null) {
                    var postTypeData = await showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => postTypeDialog);
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

class SimpleDialogItem extends StatelessWidget {
  const SimpleDialogItem(
      {Key key, this.icon, this.color, this.text, this.onPressed})
      : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 36.0, color: color),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(text),
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
