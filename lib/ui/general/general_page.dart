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
          backgroundColor: Colors.white,
          elevation: 5,
          title: Text("Anasayfa", style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnnouncementPart(),
                  Text(
                    "Haftanın Öne Çıkan Paylaşımları",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                  PostPart(),
                  Text(
                    "Podcast Önerileri",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                  PodcastPart(),
                  Text(
                    "Kaçırılmaması Gereken Etkinlikler",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                  EventPart()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
