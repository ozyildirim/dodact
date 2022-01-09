import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  Get.back();
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
        headerValue: "Kimler Açık Sahne'de yer alabilir?",
        expandedValue:
            "Açık Sahnede yayınlamak istediğin performans fikrini detaylarıyla Dodact ekibiyle paylaşan ve belli standartlar doğrultusunda onaylanan herkes Açık Sahnede yer alabilir. Açık Sahne'de yer alabilmek için bizimle hello@dodact.com üzerinden iletişime geçebilirsin."),
    QuestionItem(
        headerValue: "Açık Sahnede ne tip performanslar izleyebilirim?",
        expandedValue:
            "Dodact olarak amacımız kendini göstermek isteyen yeni yetenekleri kitlelerle buluşturabilmek. Bu sayede sen de birbirinden farklı, yeni ve şahane performanslara kesintisiz ulaşabileceksin. "),
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
              "Açık Sahne sanat ile ilgilenen kişilerin performanslarını canlı olarak hedef kitlelerine ulaştırmalarını sağlayan bir ortamdır. Canlı yayınlamak istediğiniz her türlü performansı izleyiclerinizle zamandan ve mekandan bağımsız buluşturabilirsiniz. ",
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
