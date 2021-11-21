import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/announcement_model.dart';
import 'package:dodact_v1/repository/announcement_repository.dart';

import 'package:flutter/material.dart';

enum ViewState { Idle, Busy }

class AnnouncementProvider extends ChangeNotifier {
  ViewState state = ViewState.Idle;
  AnnouncementRepository announcementRepository =
      locator<AnnouncementRepository>();

  AnnouncementModel _announcement;
  List<AnnouncementModel> _announcementList;

  // ignore: unnecessary_getters_setters
  AnnouncementModel get announcement => _announcement;

  set announcement(AnnouncementModel value) {
    _announcement = value;
  }

  List<AnnouncementModel> get announcementList => _announcementList;

  set announcementList(List<AnnouncementModel> value) {
    _announcementList = value;
  }

  clear() {
    _announcement = null;
    _announcementList.clear();
  }

  changeState(ViewState value, {bool isNotify}) {
    if (isNotify != null) {
      if (isNotify) {
        state = value;
        notifyListeners();
      } else {
        state = value;
      }
    } else {
      state = value;
      notifyListeners();
    }
  }

  Future<AnnouncementModel> getDetail(String announcementId,
      {bool isNotify}) async {
    try {
      changeState(ViewState.Busy, isNotify: isNotify);
      var fetchedAnnouncement =
          await AnnouncementRepository().getDetail(announcementId);
      _announcement = fetchedAnnouncement;
      return _announcement;
    } catch (e) {
      print("AnnouncementProvider getDetail error: " + e.toString());
      return null;
    } finally {
      changeState(ViewState.Idle);
    }
  }

  Future<List<AnnouncementModel>> getList() async {
    try {
      var fetchedList = await AnnouncementRepository().getList();
      announcementList = fetchedList;
      notifyListeners();
      return announcementList;
    } catch (e) {
      print("AnnouncementProvider getList error: " + e.toString());
      notifyListeners();
      return null;
    }
  }
}
