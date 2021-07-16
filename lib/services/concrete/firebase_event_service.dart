import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
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

    QuerySnapshot querySnapshot = await eventsRef.get();
    for (DocumentSnapshot event in querySnapshot.docs) {
      EventModel _convertedEvent = EventModel.fromJson(event.data());
      allEvents.add(_convertedEvent);
    }
    print(allEvents.toString());
    return allEvents;
  }

  Future<List<EventModel>> getUserEvents(UserObject user) async {
    //Get post IDs from user object
    List<dynamic> eventIDs = user.eventIDs;
    List<EventModel> allUserEvents = [];

    print("Event IDs from user object:" + eventIDs.toString());
    for (dynamic event in eventIDs) {
      DocumentSnapshot documentSnapshot =
          await eventsRef.doc(event.toString()).get();
      EventModel singleEvent = EventModel.fromJson(documentSnapshot.data());
      allUserEvents.add(singleEvent);
    }
    return allUserEvents;
  }

  Future<List<EventModel>> getGroupEvents(GroupModel group) async {
    //Get post IDs from user object
    List<dynamic> eventIDs = group.eventIDs;
    List<EventModel> allGroupEvents = [];

    print("Event IDs from group object:" + eventIDs.toString());
    for (dynamic event in eventIDs) {
      DocumentSnapshot documentSnapshot =
          await eventsRef.doc(event.toString()).get();
      EventModel singleEvent = EventModel.fromJson(documentSnapshot.data());
      allGroupEvents.add(singleEvent);
    }
    return allGroupEvents;
  }

  //fetch events by query
  @override
  Query getListQuery() {
    throw UnimplementedError();
  }

  @override
  Future<void> save(EventModel model) async {
    if (model.eventId == null || model.eventId.isEmpty) {
      return await eventsRef.add(model.toJson()).then((value) async =>
          await eventsRef.doc(value.id).update({'eventId': value.id}));
    }
    return await eventsRef.doc(model.eventId).set(model.toJson());
  }

  @override
  Future<void> update(String id, Map<String, dynamic> changes) async {
    return await eventsRef.doc(id).update(changes);
  }
}
