// import 'package:dodact_v1/config/navigation/navigation_service.dart';
// import 'package:dodact_v1/model/story_model.dart';
// import 'package:dodact_v1/ui/discover/widgets/story_container.dart';

// import 'package:flutter/material.dart';
// import 'package:story_view/controller/story_controller.dart';
// import 'package:story_view/story_view.dart';

// class StoryPageView extends StatefulWidget {
//   Topic topic;
//   List<StoryModel> stories;
//   StoryPageView({this.topic, this.stories});

//   @override
//   _StoryPageViewState createState() => _StoryPageViewState();
// }

// class _StoryPageViewState extends State<StoryPageView> {
//   final controller = StoryController();
//   List<StoryModel> stories = [];
//   Topic topic;
//   List<StoryItem> storyItems = [];

//   @override
//   void initState() {
//     super.initState();
//     stories = widget.stories;
//     topic = widget.topic;
//     storyItems = buildStoryList();
//   }

//   List<StoryItem> buildStoryList() {
//     List<StoryItem> list = [];
//     if (topic == Topic.Muzik) {
//       list = stories
//           .where((e) => e.type == "Müzik")
//           .map((e) => buildStoryViewItem(e))
//           .toList();
//       return list;
//     } else if (topic == Topic.Tiyatro) {
//       list = stories
//           .where((e) => e.type == "Tiyatro")
//           .map((e) => buildStoryViewItem(e))
//           .toList();
//       return list;
//     } else if (topic == Topic.Resim) {
//       list = stories
//           .where((e) => e.type == "Resim")
//           .map((e) => buildStoryViewItem(e))
//           .toList();
//       return list;
//     } else {
//       list = stories
//           .where((e) => e.type == "Dans")
//           .map((e) => buildStoryViewItem(e))
//           .toList();
//       return list;
//     }
//   }

//   StoryItem buildStoryViewItem(StoryModel story) {
//     return StoryItem.pageImage(
//         url: story.photoURL, controller: controller, imageFit: BoxFit.fill);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: StoryView(
//         onComplete: () {
//           NavigationService.instance.pop();
//         },
//         storyItems: buildStoryList(),
//         controller: controller,
//         inline: false,
//         repeat: true,
//       ),
//     );
//   }
// }
