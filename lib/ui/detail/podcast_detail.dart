import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/podcast_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

class PodcastDetail extends StatelessWidget {
  final PodcastModel podcast;

  PodcastDetail({this.podcast});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var tileTitleSize = 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Podcast Detayları"),
      ),
      body: Container(
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: mediaQuery.size.height * 0.3,
              width: mediaQuery.size.width,
              child: Image.network(podcast.podcastImageUrl),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text(podcast.podcastOwner,
                  style: TextStyle(fontSize: tileTitleSize)),
              subtitle: Text("Podcast Yapımcısı"),
              trailing: CircleAvatar(
                backgroundImage: NetworkImage(podcast.podcastOwnerPhotoUrl),
                radius: 30,
              ),
              onTap: () async {
                await launchOwnerUrl("www.dodact.com");
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text(podcast.podcastTitle,
                  style: TextStyle(fontSize: tileTitleSize)),
              subtitle: Text("Podcast Başlığı"),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                  DateFormat("dd MM yyyy").format(podcast.podcastReleaseDate),
                  style: TextStyle(fontSize: tileTitleSize)),
              subtitle: Text("Yayınlanma Tarihi"),
            ),
            ListTile(
              title: IconButton(
                onPressed: () async {
                  await launchPodcastUrl();
                },
                icon: Icon(FontAwesome5Brands.spotify),
              ),
              subtitle: Center(child: Text("Yayın Kanalları")),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Container(
                      width: mediaQuery.size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Podcast Açıklaması",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(height: 18),
                            Text(podcast.podcastDescription),
                          ],
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  launchOwnerUrl(String url) {
    CommonMethods.launchURL(url);
  }

  launchPodcastUrl() {
    CommonMethods.launchURL(podcast.podcastLink);
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
