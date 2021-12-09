import 'package:dodact_v1/model/event_model.dart';
import 'package:flutter/material.dart';

class EventEditPage extends StatefulWidget {
  EventModel event;
  EventEditPage({this.event});

  @override
  _EventEditPageState createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Etkinlik Düzenle'),
      ),
      body: Container(
        child: Text('Edit Event'),
      ),
    );
  }
}
