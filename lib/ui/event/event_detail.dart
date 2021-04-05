import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:flutter/material.dart';

class EventDetailPage extends StatefulWidget {
  final EventModel event;

  const EventDetailPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends BaseState<EventDetailPage> {
  EventModel _event;
  @override
  void initState() {
    _event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          backwardsCompatibility: true,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(_event.eventTitle, style: TextStyle(color: Colors.black)),
        ),
        body: Container(
          width: dynamicWidth(1),
          child: Column(),
        ),
      ),
    );
  }
}
