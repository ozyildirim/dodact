import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/podcast_model.dart';

class FirebasePodcastService {
  Future<List<PodcastModel>> getPodcastList() async {
    List<PodcastModel> podcasts = [];

    QuerySnapshot querySnapshot = await podcastsRef.get();
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      PodcastModel convertedPodcast =
          PodcastModel.fromJson(documentSnapshot.data());
      podcasts.add(convertedPodcast);
    }
    return podcasts;
  }

  Future<PodcastModel> getPodcastDetail(String podcastId) async {
    DocumentSnapshot documentSnapshot = await podcastsRef.doc(podcastId).get();
    PodcastModel convertedPodcast =
        PodcastModel.fromJson(documentSnapshot.data());
    return convertedPodcast;
  }
}
