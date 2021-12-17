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

  //Events that showed in general page
  List<EventModel> specialEvents;

  List<EventModel> groupEvents;

  var eventsSnapshot = <DocumentSnapshot>[];
  var filteredEventsSnapshot = <DocumentSnapshot>[];
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

  Future addEvent(EventModel event, List<File> eventImages) async {
    try {
      //EVENT MODELİ FİRESTOREYE EKLENİYOR ve EVENT ID GERİ DÖNDÜRÜLÜYOR(içerik url olmadan)
      var eventId = await eventRepository.save(event);

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
      }

      //Event linkleri ve eventID event modeline dahil ediliyor.
      await eventRepository
          .update(eventId, {'id': eventId, 'eventImages': uploadedContents});
    } catch (e) {
      print("EventProvider addEvent error: $e");
    }
  }

  Future<void> deleteEvent(String eventId) async {
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

  Future<List<EventModel>> getSpecialEvents() async {
    try {
      return await eventRepository.getSpecialEvents();
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
      logger.d("etkinlikler çekildi");

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
      logger.d("filtreli etkinlikler çekildi");
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

  Future<bool> update(String eventId, Map<String, dynamic> changes) async {
    try {
      return await eventRepository
          .update(eventId, changes)
          .then((value) => true);
    } catch (e) {
      print("EventProvider update error: " + e.toString());
      return false;
    }
  }
}
