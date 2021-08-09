import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/podcast_model.dart';
import 'package:dodact_v1/services/concrete/firebase_podcast_service.dart';

enum AppMode { DEBUG, RELEASE }

class PodcastRepository {
  FirebasePodcastService firebasePodcastService =
      locator<FirebasePodcastService>();

  AppMode appMode = AppMode.RELEASE;

  Future<List<PodcastModel>> getPodcastList() async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(List<PodcastModel>.empty());
    }
    return await firebasePodcastService.getPodcastList();
  }

  Future<PodcastModel> getPodcastDetail(String podcastId) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(PodcastModel());
    }
    return await firebasePodcastService.getPodcastDetail(podcastId);
  }
}
