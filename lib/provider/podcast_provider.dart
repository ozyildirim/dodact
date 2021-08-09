import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/model/podcast_model.dart';
import 'package:dodact_v1/repository/podcast_repository.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PodcastProvider with ChangeNotifier {
  PodcastRepository podcastRepository = locator<PodcastRepository>();
  var logger = Logger(printer: PrettyPrinter());

  PodcastModel podcast;
  List<PodcastModel> podcastList;

  Future getPodcastList() async {
    try {
      podcastList = await podcastRepository.getPodcastList();
      notifyListeners();
      return podcastList;
    } catch (e) {
      logger.e("GetPodcastList error, $e", "PodcastProvider Error");
    }
  }

  Future getPodcastDetail(String podcastId) async {
    try {
      podcast = await podcastRepository.getPodcastDetail(podcastId);
      notifyListeners();
      return podcast;
    } catch (e) {
      logger.e("GetPodcastDetail error, $e", "PodcastProvider Error");
    }
  }
}
