import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/provider/podcast_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/general/widgets/acik_sahne_part.dart';
import 'package:dodact_v1/ui/general/widgets/announcement_part.dart';
import 'package:dodact_v1/ui/general/widgets/contributions_part.dart';
import 'package:dodact_v1/ui/general/widgets/event_part.dart';
import 'package:dodact_v1/ui/general/widgets/podcast_part.dart';
import 'package:dodact_v1/ui/general/widgets/post_part.dart';
import 'package:dodact_v1/ui/general/widgets/spinner_part.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralPage extends StatefulWidget {
  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends BaseState<GeneralPage> {
  @override
  initState() {
    super.initState();
    fetchAppContent();
  }

  fetchAppContent() {
    // var userProvider = Provider.of<UserProvider>(context, listen: false);
    var postProvider = Provider.of<PostProvider>(context, listen: false);
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    var podcastProvider = Provider.of<PodcastProvider>(context, listen: false);

    postProvider.getTopPosts();
    eventProvider.getSpecialEvents();
    podcastProvider.getPodcastList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnnouncementPart(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.white60,
                      child: Text(
                        "Haftanın Öne Çıkan Paylaşımları",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PostPart(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.white60,
                      child: Text(
                        "Açık Sahne",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AcikSahnePart(),
                    SizedBox(height: 20),
                    Container(
                      color: Colors.white60,
                      child: Text(
                        "Podcast Önerileri",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PodcastPart(),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      color: Colors.white60,
                      child: Text(
                        "Çark",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SpinnerPart(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.white60,
                      child: Text(
                        "Kaçırılmaması Gereken Etkinlikler",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    EventPart(),
                    SizedBox(
                      height: kToolbarHeight,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
