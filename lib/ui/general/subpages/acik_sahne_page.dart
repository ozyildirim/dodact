import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
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
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: BackButton(
                color: Colors.black,
              ),
            ),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
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
          height: size.height * 0.4,
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
        headerValue: "Açık Sahne nedir?",
        expandedValue:
            "Açık Sahne: sahnelerde sergilenen etkinlik, workshop, eğitim gibi aktivitelerin canlı ve kayıtlı yayınlandığı, sanatçılar ile sanatseverler arasında dijital bir bağlantı oluşturduğumuz yapıdır."),
    QuestionItem(
        headerValue:
            "Sanatsever olarak Açık Sahne sayesinde neler yapabilirim?",
        expandedValue:
            "Açık Sahne sayesinde ücretli/ücretsiz, farklı türden dijital etkinliklere dilediğin yerden dilediğin zaman katılabilirsin. Sanat ile arandaki mesafeyi kaldırmak istiyoruz."),
    QuestionItem(
        headerValue: "Sanatçı olarak Açık Sahne sayesinde neler yapabilirim?",
        expandedValue:
            "Dodact, Açık Sahne ile amatör sahnelerin etkinliklerini daha büyük kitlelere ulaştırmalarını sağlıyor. Platform sayesinde dijital etkinliklerinizden maddi gelir ve yeni takipçiler elde edebilirsiniz. Teknolojik gereksinimlerin karşılanması durumunda Dodact ile sanatını dilediğin yere ulaştır!"),
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
          Text(
            "Açık Sahne ile sanatın ulaşılabilirliğini artırmak için elimizden geleni yapıyoruz. Sahnelenen performansların canlı ve kayıtlı olacak şekilde sergileneceği bu yapı ile hem sanatseverler hem de sanatçılar için kolay ve keyifli bir dijital süreç oluşturuyoruz.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
