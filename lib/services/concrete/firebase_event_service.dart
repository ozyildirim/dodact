import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/user_model.dart';

class FirebaseEventService extends BaseService<EventModel> {
  @override
  Future<void> delete(String id) async {
    return eventsRef.doc(id).delete();
  }

  @override
  Future<EventModel> getDetail(String id) async {
    DocumentSnapshot documentSnapshot = await eventsRef.doc(id).get();
    EventModel eventModel = EventModel.fromJson(documentSnapshot.data());
    return eventModel;
  }

  @override
  Future<List<EventModel>> getList() async {
    List<EventModel> allEvents = [];

    QuerySnapshot querySnapshot =
        await eventsRef.where('visible', isEqualTo: true).get();
    for (DocumentSnapshot event in querySnapshot.docs) {
      EventModel _convertedEvent = EventModel.fromJson(event.data());
      allEvents.add(_convertedEvent);
    }

    return allEvents;
  }

  Future<List<EventModel>> getUserEvents(UserObject user) async {
    //Get post IDs from user object
    QuerySnapshot querySnapshot = await eventsRef
        .where('ownerId', isEqualTo: user.uid)
        .where('visible', isEqualTo: true)
        .get();

    List<EventModel> allUserEvents = [];
    for (DocumentSnapshot event in querySnapshot.docs) {
      EventModel _convertedEvent = EventModel.fromJson(event.data());
      allUserEvents.add(_convertedEvent);
    }
    return allUserEvents;
  }

  Future<List<EventModel>> getGroupEvents(String groupId) async {
    //Get post IDs from user object

    List<EventModel> groupEvents = [];

    QuerySnapshot querySnapshot = await eventsRef
        .where("ownerId", isEqualTo: groupId)
        .where("visible", isEqualTo: true)
        .get();

    for (DocumentSnapshot event in querySnapshot.docs) {
      EventModel singleEvent = EventModel.fromJson(event.data());
      groupEvents.add(singleEvent);
    }
    return groupEvents;
  }

  //fetch events by query
  @override
  Query getListQuery() {
    throw UnimplementedError();
  }

  @override
  Future<String> save(EventModel model) async {
    if (model.eventId == null || model.eventId.isEmpty) {
      String documentID;
      return await eventsRef.add(model.toJson()).then((eventReference) async {
        return await eventsRef
            .doc(eventReference.id)
            .update({'eventId': eventReference.id}).then((_) {
          documentID = eventReference.id;
          return documentID;
        });
      });
    } else {
      await eventsRef.doc(model.eventId).set(model.toJson());
    }
  }

  @override
  Future<void> update(String id, Map<String, dynamic> changes) async {
    return await eventsRef.doc(id).update(changes);
  }

  Future<List<EventModel>> getFilteredEventList(
      {String category,
      String city,
      String type,
      bool showAllCategories,
      bool showAllTypes,
      bool wholeCountry}) async {
    List<EventModel> filteredEvents = [];
    QuerySnapshot querySnapshot;

    if (showAllCategories && wholeCountry && showAllTypes) {
      querySnapshot = await eventsRef.where('visible', isEqualTo: true).get();
    } else if (showAllCategories && wholeCountry && showAllTypes == false) {
      querySnapshot = await eventsRef
          .where('visible', isEqualTo: true)
          .where("eventType", isEqualTo: type)
          .get();
    } else if (showAllCategories && wholeCountry == false && showAllTypes) {
      querySnapshot = await eventsRef
          .where('visible', isEqualTo: true)
          .where("city", isEqualTo: city)
          .get();
    } else if (showAllCategories &&
        wholeCountry == false &&
        showAllTypes == false) {
      querySnapshot = await eventsRef
          .where('visible', isEqualTo: true)
          .where("city", isEqualTo: city)
          .where('eventType', isEqualTo: type)
          .get();
    } else if (showAllCategories == false && wholeCountry && showAllTypes) {
      querySnapshot = await eventsRef
          .where('visible', isEqualTo: true)
          .where('eventCategory', isEqualTo: category)
          .get();
    } else if (showAllCategories == false &&
        wholeCountry == false &&
        showAllTypes) {
      querySnapshot = await eventsRef
          .where('visible', isEqualTo: true)
          .where('city', isEqualTo: city)
          .where('eventCategory', isEqualTo: category)
          .get();
    } else if (showAllCategories == false &&
        wholeCountry &&
        showAllTypes == false) {
      querySnapshot = await eventsRef
          .where('visible', isEqualTo: true)
          .where('eventCategory', isEqualTo: category)
          .where('eventType', isEqualTo: type)
          .get();
    } else {
      querySnapshot = await eventsRef
          .where('visible', isEqualTo: true)
          .where("city", isEqualTo: city)
          .where("eventCategory", isEqualTo: category)
          .where("eventType", isEqualTo: type)
          .get();
    }

    for (DocumentSnapshot event in querySnapshot.docs) {
      EventModel _event = EventModel.fromJson(event.data());
      filteredEvents.add(_event);
    }
    return filteredEvents;
  }

  Future<List<EventModel>> getSpecialEvents() async {
    List<EventModel> specialEvents = [];

    QuerySnapshot querySnapshot =
        await eventsRef.where('visible', isEqualTo: true).limit(3).get();

    for (DocumentSnapshot event in querySnapshot.docs) {
      EventModel _convertedEvent = EventModel.fromJson(event.data());
      specialEvents.add(_convertedEvent);
    }

    return specialEvents;
  }
}
