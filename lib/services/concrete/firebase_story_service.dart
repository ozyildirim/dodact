import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/model/story_model.dart';

class FirebaseStoryService {
  @override
  Future<List<StoryModel>> getStoryList() async {
    List<StoryModel> stories = await storiesRef.get().then((value) =>
        value.docs.map((e) => StoryModel.fromJson(e.data())).toList());
    for (int i = 0; i < stories.length; i++) {
      print(stories[i].photoURL);
    }
    return stories;
  }
}
