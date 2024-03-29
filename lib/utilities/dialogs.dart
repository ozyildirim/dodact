import 'package:dodact_v1/utilities/lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

SimpleDialog categoryDialog(BuildContext context) {
  return SimpleDialog(
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
        text: 'Görsel Sanatlar',
        onPressed: () {
          Navigator.pop(context, "Görsel Sanatlar");
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
}

SimpleDialog eventPlatformDialog(BuildContext context) {
  return SimpleDialog(
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
}

SimpleDialog postTypeDialog(BuildContext context) {
  return SimpleDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    title: Text('Gönderi Türü'),
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
}

SimpleDialog eventTypeDialog(BuildContext context) {
  return SimpleDialog(
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
}

SimpleDialog reportReasonDialog(BuildContext context) {
  return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text('Bildirim Sebebin'),
      children: reportReasons
          .map((reason) => SimpleDialogItem(
                text: reason,
                onPressed: () {
                  Navigator.pop(context, reason);
                },
              ))
          .toList());
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
