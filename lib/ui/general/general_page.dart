import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/podcast_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/general/widgets/acik_sahne_part.dart';
import 'package:dodact_v1/ui/general/widgets/announcement_part.dart';
import 'package:dodact_v1/ui/general/widgets/event_part.dart';
import 'package:dodact_v1/ui/general/widgets/podcast_part.dart';
import 'package:dodact_v1/ui/general/widgets/post_part.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralPage extends StatefulWidget {
  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends BaseState<GeneralPage> {
  double titleSize = 20;

  @override
  initState() {
    super.initState();
    fetchAppContent();
  }

  fetchAppContent() {
    // var userProvider = Provider.of<UserProvider>(context, listen: false);
    var postProvider = Provider.of<PostProvider>(context, listen: false);
    // var eventProvider = Provider.of<EventProvider>(context, listen: false);
    var podcastProvider = Provider.of<PodcastProvider>(context, listen: false);

    if (postProvider.topPosts == null) {
      print("top posts çekildi");
      postProvider.getTopPosts();
    }
    // eventProvider.getSpecialEvents();
    if (podcastProvider.podcastList == null) {
      print("podcastler çekildi");
      podcastProvider.getPodcastList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: AnnouncementPart(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      "Öne Çıkan Gönderiler",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          color: Colors.black,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: PostPart(),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      "Bu Etkinlikleri Kaçırma",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          color: Colors.black,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  EventPart(),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      "Yakında!",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          color: Colors.black,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AcikSahnePart(),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      "Podcast Önerileri",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          color: Colors.black,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  PodcastPart(),
                  SizedBox(
                    height: kToolbarHeight,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
