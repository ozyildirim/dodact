import 'package:dodact_v1/ui/general/widgets/announcement_part.dart';
import 'package:dodact_v1/ui/general/widgets/event_part.dart';
import 'package:dodact_v1/ui/general/widgets/podcast_part.dart';
import 'package:dodact_v1/ui/general/widgets/post_part.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 5,
          title: Text(
            "Anasayfa",
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/app/app-background.png"),
            fit: BoxFit.cover,
          )),
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
                    Text(
                      "Haftanın Öne Çıkan Paylaşımları",
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PostPart(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Podcast Önerileri",
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PodcastPart(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Kaçırılmaması Gereken Etkinlikler",
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    EventPart()
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
