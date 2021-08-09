import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/podcast_model.dart';
import 'package:flutter/material.dart';

class PodcastDetail extends StatelessWidget {
  final PodcastModel podcast;

  PodcastDetail({this.podcast});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(podcast.podcastTitle),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      image: DecorationImage(
                          image: NetworkImage(podcast.podcastImageUrl),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        podcast.podcastTitle,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              color: Colors.white54,
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(podcast.podcastOwnerPhotoUrl),
                    ),
                  ),
                ),
                title: Text(
                  podcast.podcastOwner,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                color: Colors.amberAccent,
                height: 200,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    podcast.podcastDescription,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
