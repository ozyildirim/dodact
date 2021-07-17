import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/repository/event_repository.dart';
import 'package:dodact_v1/services/concrete/firebase_event_service.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  EventRepository eventRepository = locator<EventRepository>();
  bool isLoading = false;

  EventModel event;
  List<EventModel> eventList;
  List<EventModel> userEventList;
  List<EventModel> otherUserEventList;

  List<EventModel> groupEvents;
  clear() {
    event = null;
    eventList.clear();
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

  Future save(
      {EventModel model,
      PlatformFile image,
      String name,
      bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      // if (image != null) {
      //   String imageURL = await UploadService.uploadImage(
      //       category: "event_picture", file: image, name: name);
      //   model.eventImages.add(imageURL);

      // return await FirebaseEventService().save(model);
    } catch (e) {
      print("EventProvider save error: " + e.toString());
    } finally {
      changeState(false);
    }
  }

  Future<bool> deleteEvent(String eventId, {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      return await eventRepository.delete(eventId).then((value) => true);
    } catch (e) {
      print("EventProvider delete error:  " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future<EventModel> getDetail(String eventId, {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      var fetchedEvent = await eventRepository.getDetail(eventId);
      event = fetchedEvent;
      return event;
    } catch (e) {
      print("EventProvider getDetail error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future<List<EventModel>> getAllEventsList() async {
    try {
      var fetchedList = await eventRepository.getList();
      eventList = fetchedList;
      notifyListeners();
      return eventList;
    } catch (e) {
      print("EventProvider getList error: " + e.toString());
      notifyListeners();
      return null;
    }
  }

  Future<List<EventModel>> getUserEvents(UserObject user) async {
    try {
      var fetchedList = await eventRepository.getUserEvents(user);
      userEventList = fetchedList;
      notifyListeners();
      return userEventList;
    } catch (e) {
      print("EventProvider getUserEvents error: " + e.toString());
      return null;
    }
  }

  Future<List<EventModel>> getOtherUserEvents(UserObject user,
      {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      var fetchedList = await eventRepository.getUserEvents(user);
      otherUserEventList = fetchedList;
      notifyListeners();
      return otherUserEventList;
    } catch (e) {
      print("EventProvider getOtherUserEvents error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
  }

  Future<List<EventModel>> getGroupEvents(GroupModel group,
      {bool isNotify}) async {
    try {
      changeState(true, isNotify: isNotify);
      var fetchedList = await eventRepository.getGroupEvents(group);
      eventList = fetchedList;
      return eventList;
    } catch (e) {
      print("EventProvider getGroupEvents error: " + e.toString());
      return null;
    } finally {
      changeState(false);
    }
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
}
