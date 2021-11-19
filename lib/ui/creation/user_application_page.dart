import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class UserApplicationMenuPage extends StatefulWidget {
  @override
  State<UserApplicationMenuPage> createState() =>
      _UserApplicationMenuPageState();
}

class _UserApplicationMenuPageState extends BaseState<UserApplicationMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  buildBody() {
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            child: Container(
              height: size.height * 0.3,
              child: CachedNetworkImage(
                  imageUrl:
                      "https://ae01.alicdn.com/kf/HTB1U7dDX6LuK1Rjy0Fhq6xpdFXad.jpg",
                  width: size.width,
                  fit: BoxFit.cover),
            ),
          ),
          // Container(
          //   height: size.height * 0.1,
          //   child: ListTile(
          //     title: Text('Sesini Dodact ile daha güçlü duyur!',
          //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          //     subtitle: Text("Lorem Ipsum asddasdas"),
          //   ),
          // ),
          // Container(
          //   height: size.height - kToolbarHeight - (size.height * 0.4),
          //   child: buildCardPart(),
          // ),
          Expanded(
            child: buildCardPart(),
          )
        ],
      ),
    );
  }

  buildCardPart() {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1),
      children: [
        _buildCard(Icons.post_add, "İçerik&Etkinlik Üretici",
            "Kendine özgü içeriklerinle topluluk arasındaki yerini al!", () {
          NavigationService.instance.navigate(k_ROUTE_CREATOR_APPLICATION);
        }),
        _buildCard(
            Icons.stream,
            "Canlı Yayın Üretici",
            "Canlı yayınlarını Dodact üzerinden yayınla, hedef kitlene daha kolay ulaş!",
            () {}),
        _buildCard(Icons.group, "Topluluk Başvurusu",
            "Topluluğunu Dodact'in gücü ile buluştur!", () {}),
        // _buildCard(Icons.post_add, "İçerik Üretici",
        //     "Kendine özgü içeriklerinle topluluk arasındaki yerini al!", () {}),
      ],
    );
  }

  _buildCard(IconData icon, String title, String description, Function onTap,
      {String groupId}) {
    var cardBackgroundColor = Color(0xFFF8F9FA);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: cardBackgroundColor,
          child: Container(
            width: size.width * 0.2,
            height: size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 8,
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.12,
                    child: Icon(icon, size: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
