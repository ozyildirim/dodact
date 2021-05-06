import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/story_model.dart';
import 'package:dodact_v1/ui/feed/component/story_container.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends StatefulWidget {
  Topic topic;
  List<StoryModel> stories;
  StoryPageView({this.topic, this.stories});

  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final controller = StoryController();
  List<StoryModel> stories = [];

  @override
  void initState() {
    super.initState();
    stories = widget.stories;
  }

  List<StoryItem> buildStoryList() {
    switch (widget.topic) {
      case Topic.Muzik:
        return stories
            .where((e) => e.type == "Müzik")
            .map((e) => buildStoryViewItem(e))
            .toList();
        break;
      case Topic.Tiyatro:
        return stories
            .where((e) => e.type == "Tiyatro")
            .map((e) => buildStoryViewItem(e))
            .toList();
        break;
      case Topic.Resim:
        return stories
            .where((e) => e.type == "Resim")
            .map((e) => buildStoryViewItem(e))
            .toList();
        break;
      case Topic.Dans:
        return stories
            .where((e) => e.type == "Dans")
            .map((e) => buildStoryViewItem(e))
            .toList();
        break;
    }
  }

  StoryItem buildStoryViewItem(StoryModel story) {
    return StoryItem.pageImage(
        url: story.photoURL, controller: controller, imageFit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    // final List<StoryItem> storyItems = [
    //   StoryItem.pageImage(
    //       caption: "Selam",
    //       url:
    //           "https://img-s2.onedio.com/id-5e0e1424a181be44523430d9/rev-0/w-635/listing/f-jpg-webp/s-0fdfcc94be25ec0766c3b7daf8bfa2a948e9f4b9.webp",
    //       controller: controller),
    //   StoryItem.text(title: '''“YA BU İNANILMAZ BİR ŞEY YAV”
    //    – Kutay YILDIRIM''', backgroundColor: Colors.blueGrey),
    //   StoryItem.pageImage(
    //       url:
    //           "https://img-s2.onedio.com/id-5e0e1424a181be44523430d9/rev-0/w-635/listing/f-jpg-webp/s-0fdfcc94be25ec0766c3b7daf8bfa2a948e9f4b9.webp",
    //       controller: controller,
    //       imageFit: BoxFit.contain),
    // ];
    return Material(
      child: StoryView(
        onComplete: () {
          NavigationService.instance.pop();
        },
        storyItems: buildStoryList(),
        controller: controller,
        inline: false,
        repeat: true,
      ),
    );
  }
}
