import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/general/widgets/announcement_part.dart';
import 'package:dodact_v1/ui/general/widgets/contributions_part.dart';
import 'package:dodact_v1/ui/general/widgets/event_part.dart';
import 'package:dodact_v1/ui/general/widgets/podcast_part.dart';
import 'package:dodact_v1/ui/general/widgets/post_part.dart';
import 'package:dodact_v1/ui/general/widgets/spinner_part.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   elevation: 5,
        //   title: Text(
        //     "Anasayfa",
        //   ),
        // ),

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
                padding: const EdgeInsets.all(22.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              color: Colors.white60,
                              child: Text(
                                "Çark",
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SpinnerPart(),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              color: Colors.white60,
                              child: Text(
                                "Yardımlar",
                                textAlign: TextAlign.start,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ContributionsPart()
                          ],
                        )
                      ],
                    ),
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
