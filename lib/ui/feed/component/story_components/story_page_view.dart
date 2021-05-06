import 'package:dodact_v1/ui/feed/component/story_container.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends StatefulWidget {
  Topic topic;
  StoryPageView({this.topic});

  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final controller = StoryController();

  @override
  Widget build(BuildContext context) {
    final List<StoryItem> storyItems = [
      StoryItem.pageImage(
          url:
              "https://lh3.googleusercontent.com/proxy/fMkBbxqnVddPdCRyB6cM_ldzFflH5ToM-O4fwm1blHcj54bgD2UvsEjJy2Ob9CMlqXydmdgv47KyyVu31RAcCEqpvrW5_By9zg",
          controller: controller),
      StoryItem.text(
          title: '''“When you talk, you are only repeating something you know.
       But if you listen, you may learn something new.” 
       – Dalai Lama''', backgroundColor: Colors.blueGrey),
      StoryItem.pageImage(
          url:
              "https://lh3.googleusercontent.com/proxy/fMkBbxqnVddPdCRyB6cM_ldzFflH5ToM-O4fwm1blHcj54bgD2UvsEjJy2Ob9CMlqXydmdgv47KyyVu31RAcCEqpvrW5_By9zg",
          controller: controller,
          imageFit: BoxFit.contain),
    ];
    return Material(
      child: StoryView(
        storyItems: storyItems,
        controller: controller,
        inline: false,
        repeat: true,
      ),
    );
  }
}
