import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/announcement_model.dart';

class FirebaseAnnouncementService extends BaseService<AnnouncementModel> {
  @override
  Future<AnnouncementModel> getDetail(String id) async {
    DocumentSnapshot documentSnapshot = await announcementsRef.doc(id).get();
    AnnouncementModel announcementModel =
        AnnouncementModel.fromJson(documentSnapshot.data());
    return announcementModel;
  }

  @override
  Future<List<AnnouncementModel>> getList() async {
    List<AnnouncementModel> allAnnouncements = [];

    QuerySnapshot querySnapshot =
        await announcementsRef.orderBy('eventDate').get();
    for (DocumentSnapshot announcement in querySnapshot.docs) {
      AnnouncementModel _convertedAnnouncement =
          AnnouncementModel.fromJson(announcement.data());
      allAnnouncements.add(_convertedAnnouncement);
    }
    return allAnnouncements;
  }

  @override
  Query getListQuery() {
    // TODO: implement getListQuery
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> save(AnnouncementModel model) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> update(String id, Map<String, dynamic> changes) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
