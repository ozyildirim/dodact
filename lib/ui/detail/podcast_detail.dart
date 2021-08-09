import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/podcast_model.dart';
import 'package:flutter/material.dart';

class PodcastDetail extends StatelessWidget {
  final PodcastModel podcast;

  PodcastDetail({this.podcast});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Podcast Detay"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                child: Stack(
                  children: [
                    Container(
                      height: mediaQuery.size.height * 0.3,
                      width: mediaQuery.size.width * 0.7,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          image: DecorationImage(
                              image: NetworkImage(podcast.podcastImageUrl),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1, 1),
                            )
                          ]),
                    ),
                    Positioned(
                      left: (mediaQuery.size.width * 0.7) - 200,
                      bottom: -10,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(podcast.podcastOwnerPhotoUrl),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                color: Colors.white54,
                child: ListTile(
                  title: Text(
                    podcast.podcastOwner,
                    style: TextStyle(fontSize: 24),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      CommonMethods.launchURL(podcast.podcastLink);
                    },
                    icon: Icon(Icons.link),
                  ),
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

/*

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

*/