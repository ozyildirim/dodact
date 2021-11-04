import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
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
      return refEvents.get();
    } else {
      return refEvents.startAfterDocument(startAfter).get();
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

  Future<QuerySnapshot> getEventList(
      {int limit, DocumentSnapshot startAfter}) async {
    Query query = eventsRef.where('visible', isEqualTo: true).limit(limit);

    if (startAfter == null) {
      return query.get();
    } else {
      return query.startAfterDocument(startAfter).get();
    }
  }

  Future<QuerySnapshot> getFilteredEventList({
    String category,
    String city,
    String type,
    int limit,
    DocumentSnapshot startAfter,
  }) async {
    Query query;

    if (category != null && type != null && city != null) {
      query = eventsRef
          .where('eventCategory', isEqualTo: category)
          .where('eventType', isEqualTo: type)
          .where('city', isEqualTo: city)
          .where('visible', isEqualTo: true);
    } else if (category != null && type != null) {
      query = eventsRef
          .where('eventCategory', isEqualTo: category)
          .where('eventType', isEqualTo: type)
          .where('visible', isEqualTo: true);
    } else if (category != null && city != null) {
      query = eventsRef
          .where('eventCategory', isEqualTo: category)
          .where('city', isEqualTo: city)
          .where('visible', isEqualTo: true);
    } else if (type != null && city != null) {
      query = eventsRef
          .where('eventType', isEqualTo: type)
          .where('city', isEqualTo: city)
          .where('visible', isEqualTo: true);
    } else if (category != null) {
      query = eventsRef
          .where('eventCategory', isEqualTo: category)
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
