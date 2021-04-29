import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class GeneralPage extends StatefulWidget {
  @override
  _GeneralPageState createState() => _GeneralPageState();
}

class _GeneralPageState extends BaseState<GeneralPage> {
  PostProvider _postProvider;

  @override
  void initState() {
    super.initState();
    _postProvider = getProvider<PostProvider>();
    _postProvider.getList(isNotify: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSlider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Haftanın Öne Çıkan Paylaşımları",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              TopPostsSlider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Podcast Önerileri",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              PodcastSlider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Bu Etkinlikleri Kaçırma!",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              EventSlider()
            ],
          ),
        ),
      ),
    );
  }

  //TODO: Haftanın kullanıcıları, En hit paylaşımlar, yeni gruplar

  Padding ImageSlider() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GFCarousel(
        autoPlay: true,
        activeIndicator: Colors.black,
        passiveIndicator: Colors.grey,
        items: imageList.map(
          (url) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.network(url, fit: BoxFit.cover, width: 1000.0),
              ),
            );
          },
        ).toList(),
        onPageChanged: (index) {
          setState(() {
            index;
          });
        },
      ),
    );
  }

  GFItemsCarousel TopPostsSlider() {
    return GFItemsCarousel(
      rowCount: 2,
      children: [CustomCard(), CustomCard(), CustomCard(), CustomCard()],
    );
  }

  GFItemsCarousel PodcastSlider() {
    return GFItemsCarousel(
      rowCount: 2,
      children: [
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Dodact Podcast 1",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Dodact Podcast 2",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Dodact Podcast 3",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Dodact Podcast 4",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  GFItemsCarousel EventSlider() {
    return GFItemsCarousel(
      rowCount: 2,
      children: [
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Örnek Etkinlik 1",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Örnek Etkinlik 2",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Örnek Etkinlik 3",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        GFCard(
          padding: EdgeInsets.all(0),
          boxFit: BoxFit.cover,
          image: Image.asset('assets/images/drawerBg.jpg'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Örnek Etkinlik 4",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  final List<String> imageList = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];
}

Widget CustomCard() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 240,
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.purple,
                  image: DecorationImage(
                      image: AssetImage('assets/images/drawerBg.jpg'),
                      fit: BoxFit.cover)),
            )),
            Text(
              "Başlık",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Altbaşlık",
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    ),
  );
}
