import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class AcikSahnePage extends StatefulWidget {
  @override
  State<AcikSahnePage> createState() => _AcikSahnePageState();
}

class _AcikSahnePageState extends State<AcikSahnePage> {
  var imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/app%2Facik_sahne_cover-min.jpeg?alt=media&token=64b3f1ee-7015-4230-8c4e-525c0b0b0e40";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  NavigationService.instance.pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: BackButtonIcon(
                        // color: Colors.black,
                        ),
                  ),
                ),
              ),
            ),
            // leading: MaterialButton(
            //   color: Colors.white,
            //   shape: CircleBorder(),
            //   onPressed: () {},
            //   child: Padding(
            //       padding: const EdgeInsets.all(100),
            //       child: BackButton(
            //         color: Colors.black,
            //       )),
            // ),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            width: size.width,
            height: size.height,
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
                children: [
                  buildHeaderPart(context),
                  buildBodyPart(context),
                ],
              ),
            ),
          )),
    );
  }

  buildHeaderPart(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: size.width,
          height: size.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imageProvider,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: size.width * 0.8,
                child: Text("Dodact Açık Sahne",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        );
      },
    );
  }

  List<QuestionItem> questionItems = [
    QuestionItem(
        headerValue: "İzleyici olarak Açık Sahne sayesinde neler yapabilirim?",
        expandedValue:
            "Açık Sahne sayesinde sanatın her alanında gerçekleştirilecek dijital performanslara dilediğin zamanda ve dilediğin yerden katılım sağlayabilirsin. İlgilendiğin sanat dalını daha kolay takip edebilmeni ve daha kolay katılım sağlayabilmeni sağlamak için Açık Sahne seninle!"),
    QuestionItem(
        headerValue:
            "İlgilendiğim sanat alanı ile ilgili Açık Sahne'de kendimi göstermek istiyorum, neler yapabilirim?",
        expandedValue:
            "Dodact kişilerin Açık Sahne vasıtasıyla belirlenen kalite standartları dahilinde performanslarını kitleler ile buluşturmasını, yeni yeteneklerin keşfedilmesini ve yapılan bu işten kazanç sağlamalarını amaçlamaktadır. Açık Sahne'de olacak kişi performansı ile ilgili detayları öncesinde belirlemek ve bildirmek zorundadır. Gerekli teknolojik standartlar oluşturulduktan sonra sürece dahil olabilirsin."),
    QuestionItem(
        headerValue: "Açık Sahne'de nasıl yer alabilirim?",
        expandedValue:
            "Açık Sahne hakkında daha detaylı bilgi almak ve sürece dahil olmak için hello@dodact.com adresinden bizimle iletişime geçebilirsin."),
  ];

  buildBodyPart(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Açık Sahne: Sanat ile ilgilenen kişilerin hedef kitlesine canlı yayınlar ile ulaşmasını sağlayacak bir aracı kanaldır.\n\nKişiler performanslarını belirlenmiş kalite standartları dahilinde izleyicilerine, zaman,mekan veya olumsuz şartlardan bağımsız şekilde, diledikleri her an ulaştırabilecekler. Böylelikle ilgilendiği sanat dalında performansını sergilemek isteyen kişilerin sahneye ulaşılabilirliğini arttırıyoruz.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          buildExpandedPanelList()
        ],
      ),
    );
  }

  buildExpandedPanelList() {
    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.all(20),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          questionItems[index].isExpanded = !isExpanded;
        });
      },
      children: questionItems.map<ExpansionPanel>((QuestionItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
            );
          },
          body: ListTile(
            title: Text(item.expandedValue),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class QuestionItem {
  QuestionItem({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
