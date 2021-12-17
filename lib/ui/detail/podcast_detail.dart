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
    var tileTitleSize = 16.0;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text("Podcast Detayı"),
      ),
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      CustomMethods.showImagePreviewDialog(context,
                          url: podcast.podcastImageUrl);
                    },
                    child: Container(
                      height: mediaQuery.size.height * 0.3,
                      width: mediaQuery.size.width,
                      child: Image.network(podcast.podcastImageUrl),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 10,
                  //   right: 10,
                  //   child: FloatingActionButton(
                  //     onPressed: () async {
                  //       await launchPodcastUrl();
                  //     },
                  //     backgroundColor: kNavbarColor,
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(FontAwesome5Brands.spotify, size: 20),
                  //         Padding(
                  //           padding: const EdgeInsets.all(4.0),
                  //           child: Text(
                  //             "Dinle",
                  //             style: TextStyle(
                  //                 fontSize: 14, fontWeight: FontWeight.w400),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
              // Row(
              //   children: [
              //     CircleAvatar(
              //       child: Icon(FontAwesome5Brands.spotify),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: mediaQuery.size.width * 0.4,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () async {
                      await launchPodcastUrl();
                    },
                    color: kNavbarColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesome5Brands.spotify,
                              size: 20, color: Colors.white),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Dinle",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                    radius: 16,
                    foregroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.list_alt,
                      color: Colors.white,
                    )),
                title: Text(podcast.podcastTitle,
                    style: TextStyle(
                        fontSize: tileTitleSize, fontWeight: FontWeight.w500)),
                subtitle: Text("Podcast Başlığı"),
              ),
              ListTile(
                leading: CircleAvatar(
                  foregroundColor: Colors.greenAccent,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  radius: 16,
                ),
                title: Text(podcast.podcastOwner,
                    style: TextStyle(
                        fontSize: tileTitleSize, fontWeight: FontWeight.w500)),
                subtitle: Text("Podcast Yapımcısı"),
                // trailing: CircleAvatar(
                //   backgroundImage: NetworkImage(podcast.podcastOwnerPhotoUrl),
                //   backgroundColor: Colors.white,
                //   radius: 16,
                // ),
                onTap: () async {
                  await launchOwnerUrl("www.dodact.com");
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  foregroundColor: Colors.greenAccent,
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                    DateFormat("dd.MM.yyyy").format(podcast.podcastReleaseDate),
                    style: TextStyle(
                        fontSize: tileTitleSize, fontWeight: FontWeight.w500)),
                subtitle: Text("Yayınlanma Tarihi"),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                      width: mediaQuery.size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Podcast Açıklaması",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 18),
                            Text(podcast.podcastDescription),
                          ],
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  launchOwnerUrl(String url) {
    CustomMethods.launchURL(url);
  }

  launchPodcastUrl() {
    CustomMethods.launchURL(podcast.podcastLink);
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
