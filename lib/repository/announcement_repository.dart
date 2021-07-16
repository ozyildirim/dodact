import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/base/base_service.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/announcement_model.dart';
import 'package:dodact_v1/services/concrete/fake_auth_service.dart';
import 'package:dodact_v1/services/concrete/firebase_announcement_service.dart';
import 'package:dodact_v1/services/concrete/firebase_auth_service.dart';

enum AppMode { DEBUG, RELEASE }

// class that make us decide for which service provider we want to use

class AnnouncementRepository implements BaseService<AnnouncementModel> {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirebaseAnnouncementService _announcementService =
      locator<FirebaseAnnouncementService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<AnnouncementModel> getDetail(String id) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _announcementService.getDetail(id);
    }
  }

  @override
  Future<List<AnnouncementModel>> getList() async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(null);
    } else {
      return await _announcementService.getList();
    }
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Query getListQuery() {
    throw UnimplementedError();
  }

  @override
  Future<void> save(AnnouncementModel model) {
    throw UnimplementedError();
  }

  @override
  Future<void> update(String id, Map<String, dynamic> changes) {
    throw UnimplementedError();
  }
}
