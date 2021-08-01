import 'dart:io';

import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/request_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/repository/event_repository.dart';
import 'package:dodact_v1/services/concrete/firebase_request_service.dart';
import 'package:dodact_v1/services/concrete/upload_service.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  EventRepository eventRepository = locator<EventRepository>();
  FirebaseRequestService requestService = FirebaseRequestService();

  AuthProvider authProvider = AuthProvider();
  GroupProvider groupProvider = GroupProvider();

  bool isLoading = false;

  EventModel event;
  EventModel newEvent = new EventModel();
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
      } else {
        newEvent.eventImages = uploadedContents;
      }

      //Event linkleri event modeline dahil ediliyor.
      await eventRepository.save(newEvent);

      //Post isteği oluşturuluyor.
      await createEventRequest(newEvent);

      if (newEvent.ownerType == 'User') {
        await authProvider.editUserEventIDs(
            newEvent.eventId, newEvent.ownerId, true);
      } else if (newEvent.ownerType == 'Group') {
        await groupProvider.editGroupEventList(
            newEvent.eventId, newEvent.ownerId, true);
      }
    } catch (e) {
      print("EventProvider addEvent error: $e");
    }
  }

  Future<void> createEventRequest(EventModel event) async {
    try {
      var requestModel = new RequestModel();
      requestModel.requestOwnerId = event.ownerId;
      requestModel.requestDate = DateTime.now();
      requestModel.subjectId = event.eventId;
      requestModel.requestFor = "Event";
      requestModel.isExamined = false;
      requestModel.isApproved = false;
      requestModel.rejectionMessage = "";

      await requestService.addRequest(requestModel);
    } catch (e) {
      print("PostProvider createPostRequestModel error: $e ");
    }
  }

  Future<void> deleteEvent(String eventId, bool isLocatedInStorage) async {
    try {
      await eventRepository.delete(eventId).then((value) async {
        if (isLocatedInStorage) {
          await UploadService().deleteEventMedia(eventId);
        }
      });
      EventModel event =
          eventList.firstWhere((element) => element.eventId == eventId);
      eventList.remove(event);
      notifyListeners();
    } catch (e) {
      print("EventProvider delete error:  " + e.toString());
      return null;
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

  void clearNewEvent() {
    newEvent = new EventModel();
  }
}
