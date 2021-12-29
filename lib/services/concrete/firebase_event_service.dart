import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/user_model.dart';

class FirebaseEventService {
  Future<void> delete(String id) async {
    return eventsRef.doc(id).delete();
  }

  Future<EventModel> getDetail(String id) async {
    DocumentSnapshot documentSnapshot = await eventsRef.doc(id).get();
    EventModel eventModel = EventModel.fromJson(documentSnapshot.data());
    return eventModel;
  }

  Future getList(int limit, DocumentSnapshot startAfter) async {
    final refEvents = eventsRef.limit(limit);

    if (startAfter == null) {
      return refEvents.where('visible', isEqualTo: true).get();
    } else {
      return refEvents
          .startAfterDocument(startAfter)
          .where('visible', isEqualTo: true)
          .get();
    }
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

  Query getListQuery() {
    throw UnimplementedError();
  }

  @override
  Future<String> save(EventModel model) async {
    String documentID;
    return await eventsRef.add(model.toJson()).then((eventReference) async {
      return await eventsRef
          .doc(eventReference.id)
          .update({'eventId': eventReference.id}).then((_) {
        documentID = eventReference.id;
        return documentID;
      });
    });
  }

  @override
  Future<void> update(String id, Map<String, dynamic> changes) async {
    return await eventsRef.doc(id).update(changes);
  }

  Future<QuerySnapshot> getEventList(
      {int limit, DocumentSnapshot startAfter}) async {
    Query query = eventsRef
        .where('visible', isEqualTo: true)
        .orderBy('startDate', descending: true)
        .limit(limit);

    if (startAfter == null) {
      return query.get();
    } else {
      return query.startAfterDocument(startAfter).get();
    }
  }

  Future<QuerySnapshot> getFilteredEventList({
    List<String> categories,
    String city,
    String type,
    int limit,
    DocumentSnapshot startAfter,
  }) async {
    try {
      Query query;

      if (categories != null && type != null && city != null) {
        query = eventsRef
            .where('eventCategories', arrayContainsAny: categories)
            .where('eventType', isEqualTo: type)
            .where('city', isEqualTo: city)
            .where('visible', isEqualTo: true);
      } else if (categories != null && type != null) {
        query = eventsRef
            .where('eventCategories', arrayContainsAny: categories)
            .where('eventType', isEqualTo: type)
            .where('visible', isEqualTo: true);
      } else if (categories != null && city != null) {
        query = eventsRef
            .where('eventCategories', arrayContainsAny: categories)
            .where('city', isEqualTo: city)
            .where('visible', isEqualTo: true);
      } else if (type != null && city != null) {
        query = eventsRef
            .where('eventType', isEqualTo: type)
            .where('city', isEqualTo: city)
            .where('visible', isEqualTo: true);
      } else if (categories != null) {
        query = eventsRef
            .where('eventCategories', arrayContainsAny: categories)
            .where('visible', isEqualTo: true);
      } else if (type != null) {
        query = eventsRef
            .where('eventType', isEqualTo: type)
            .where('visible', isEqualTo: true);
      } else if (city != null) {
        query = eventsRef
            .where('city', isEqualTo: city)
            .where('visible', isEqualTo: true);
      } else {
        query = eventsRef.where('visible', isEqualTo: true);
      }

      if (startAfter == null) {
        return query.limit(limit).get();
      } else {
        return query.limit(limit).startAfterDocument(startAfter).get();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<EventModel>> getSpecialEvents() async {
    List<EventModel> specialEvents = [];

    QuerySnapshot querySnapshot = await eventsRef
        .where('visible', isEqualTo: true)
        // .orderBy('creationDate', descending: true)
        .limit(3)
        .get();

    for (DocumentSnapshot event in querySnapshot.docs) {
      EventModel _convertedEvent = EventModel.fromJson(event.data());
      specialEvents.add(_convertedEvent);
    }

    return specialEvents;
  }
}
