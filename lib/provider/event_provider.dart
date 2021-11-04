import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/event_repository.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EventProvider extends ChangeNotifier {
  var logger = new Logger();
  EventRepository eventRepository = locator<EventRepository>();
  bool isLoading = false;
  EventModel event;
  EventModel newEvent = new EventModel();

  //Events that showed in general page
  List<EventModel> specialEvents;

  List<EventModel> groupEvents;

  final eventsSnapshot = <DocumentSnapshot>[];
  final filteredEventsSnapshot = <DocumentSnapshot>[];
  String errorMessage = '';
  int documentLimit = 3;
  bool _hasNext = true;
  bool _hasNextFiltered = true;
  bool _isFetchingEvents = false;
  bool _isFetchingFilteredEvents = false;

  bool get hasNext => _hasNext;

  bool get hasNextFiltered => _hasNextFiltered;
  List<EventModel> get events =>
      eventsSnapshot.map((e) => EventModel.fromJson(e.data())).toList();

  List<EventModel> get filteredEvents =>
      filteredEventsSnapshot.map((e) => EventModel.fromJson(e.data())).toList();

  clear() {
    event = null;
  }

  changeState(bool _isLoading, {bool isNotify}) {
    isLoading = _isLoading;
    if (isNotify != null) {
      if (isNotify) {
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }

  Future addEvent(List<File> eventImages) async {
    try {
      //EVENT MODELİ FİRESTOREYE EKLENİYOR ve EVENT ID GERİ DÖNDÜRÜLÜYOR(içerik url olmadan)
      var eventId = await eventRepository.save(newEvent);
      newEvent.eventId = eventId;

      List<String> uploadedContents = [];
      //Event resimleri upload ediliyor.
      if (eventImages != null) {
        await Future.wait(eventImages.map((file) async {
          await UploadService()
              .uploadEventMedia(
                  eventID: eventId,
                  fileNameAndExtension: file.path.split('/').last,
                  fileToUpload: file)
              .then((url) {
            uploadedContents.add(url);
          });
        }));
        print(
            "eventImageesss null deeğğil ve  içeriiği: ${uploadedContents.toString()}");
        newEvent.eventImages = uploadedContents;
      } else {
        print("eventImageesss null");
        //Eğer yüklenen bir fotoğraf yoksa, default bir fotoğraf belirlenir.
        newEvent.eventImages[0] =
            "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/app%2Fornek-etkinlik%20(2).jpg?alt=media&token=ef38b635-305d-4e44-828d-5e70f3cf355c";
      }

      //Event linkleri event modeline dahil ediliyor.
      await eventRepository.save(newEvent);
    } catch (e) {
      print("EventProvider addEvent error: $e");
    }
  }

  Future<void> deleteEvent(String eventId, bool isLocatedInStorage) async {
    try {
      await eventRepository.delete(eventId);
      notifyListeners();
    } catch (e) {
      print("EventProvider delete error:  " + e.toString());
      return null;
    }
  }

  Future<EventModel> getDetail(String eventId, {bool isNotify}) async {
    try {
      var fetchedEvent = await eventRepository.getDetail(eventId);
      event = fetchedEvent;

      return event;
    } catch (e) {
      print("EventProvider getDetail error: " + e.toString());
      return null;
    } finally {
      notifyListeners();
    }
  }

  Future<List<EventModel>> getUserEvents(UserObject user) async {
    try {
      return await eventRepository.getUserEvents(user);
    } catch (e) {
      print("EventProvider getUserEvents error: " + e.toString());
      return null;
    }
  }

  Future<void> getSpecialEvents() async {
    try {
      specialEvents = await eventRepository.getSpecialEvents();
      notifyListeners();
    } catch (e) {
      logger.e("EventProvider getSpecialEvents error: " + e.toString());
    }
  }

  Future getEventList() async {
    if (_isFetchingEvents) return;
    errorMessage = '';
    _isFetchingEvents = true;

    try {
      var snap = await eventRepository.getEventList(
        limit: documentLimit,
        startAfter: eventsSnapshot.isNotEmpty ? eventsSnapshot.last : null,
      );

      eventsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (e) {
      logger.e("EventProvider getEventList error: " + e.toString());
      notifyListeners();
      return null;
    }

    _isFetchingEvents = false;
  }

  Future getFilteredEventList(
      {bool reset, String category, String city, String type}) async {
    if (reset) {
      filteredEventsSnapshot.clear();
      _hasNextFiltered = true;
    }

    if (_isFetchingFilteredEvents) return;
    errorMessage = '';
    _isFetchingFilteredEvents = true;

    try {
      var snap = await eventRepository.getFilteredEventList(
        category: category,
        city: city,
        type: type,
        limit: documentLimit,
        startAfter: filteredEventsSnapshot.isNotEmpty
            ? filteredEventsSnapshot.last
            : null,
      );

      filteredEventsSnapshot.addAll(snap.docs);
      // print("snap.docs");

      if (snap.docs.length < documentLimit) _hasNextFiltered = false;
      notifyListeners();
    } catch (e) {
      logger.e("EventProvider getFilteredEventList error: " + e.toString());
      notifyListeners();
      return null;
    }

    _isFetchingFilteredEvents = false;
  }

  Future<bool> update(String eventId, Map<String, dynamic> changes,
      {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      return await eventRepository
          .update(eventId, changes)
          .then((value) => true);
    } catch (e) {
      print("EventProvider update error: " + e.toString());
      return false;
    } finally {
      changeState(false);
    }
  }

  void clearNewEvent() {
    newEvent = new EventModel();
  }
}
