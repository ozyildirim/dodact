import 'package:dodact_v1/model/date_model.dart';
import 'package:dodact_v1/model/event_type_model.dart';
import 'package:dodact_v1/model/events_model.dart';

List<DateModel> getDates() {
  List<DateModel> dates = [];
  DateModel dateModel = new DateModel();

  //1
  dateModel.date = "10";
  dateModel.weekDay = "Pazartesi";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "11";
  dateModel.weekDay = "Salı";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "12";
  dateModel.weekDay = "Çarşamba";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "13";
  dateModel.weekDay = "Perşembe";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "14";
  dateModel.weekDay = "Cuma";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "15";
  dateModel.weekDay = "Cumartesi";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "16";
  dateModel.weekDay = "Pazar";
  dates.add(dateModel);

  dateModel = new DateModel();

  return dates;
}

List<EventTypeModel> getEventTypes() {
  List<EventTypeModel> events = new List();
  EventTypeModel eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/images/concert.png";
  eventModel.eventType = "Müzik";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/images/theater_icon.png";
  eventModel.eventType = "Tiyatro";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  //1
  eventModel.imgAssetPath = "assets/images/dance.png";
  eventModel.eventType = "Dans";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  eventModel.imgAssetPath = "assets/images/paint-brush.png";
  eventModel.eventType = "Resim";
  events.add(eventModel);

  eventModel = new EventTypeModel();

  return events;
}

List<EventsModel> getEvents() {
  List<EventsModel> events = [];
  EventsModel eventsModel = new EventsModel();

  //1
  eventsModel.imgeAssetPath = "assets/images/concert.jpg";
  eventsModel.date = "Haziran 12, 2021";
  eventsModel.desc = "Grup Atali Online Konser";
  eventsModel.address = "Zoom";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //2
  eventsModel.imgeAssetPath = "assets/images/second.png";
  eventsModel.date = "Haziran 12, 2021";
  eventsModel.desc = "Soyut Çizime Giriş";
  eventsModel.address = "Uzun Cd. Beyoğlu, İstanbul";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //3
  eventsModel.imgeAssetPath = "assets/images/radio_theater.jpg";
  eventsModel.date = "Haziran 15, 2021";
  eventsModel.address = "Tiyatro Diyalektik Radyo Tiyatrosu";
  eventsModel.desc = "Radyo Tiyatrosu Etkinliği";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  return events;
}
