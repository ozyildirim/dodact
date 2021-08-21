import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/contribution_model.dart';
import 'package:dodact_v1/provider/contribution_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContributionsPage extends StatefulWidget {
  @override
  _ContributionsPageState createState() => _ContributionsPageState();
}

class _ContributionsPageState extends State<ContributionsPage> {
  List<ContributionModel> allContributions;
  List<PieChartSectionData> sections = [];

  List<ContributionModel> temaElements;
  List<ContributionModel> dodactElements;

  double temaRatio;
  double dodactRatio;

  ContributionProvider contributonProvider;

  @override
  void initState() {
    contributonProvider =
        Provider.of<ContributionProvider>(context, listen: false);

    contributonProvider.getContributions().then((value) {
      allContributions = value;

      temaRatio = allContributions
          .where((element) => element.contributedCompany == 'TEMA')
          .toList()
          .length
          .toDouble();

      dodactRatio = allContributions
          .where((element) => element.contributedCompany == 'DODACT')
          .toList()
          .length
          .toDouble();

      setState(() {
        buildSections();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Yardımlar'),
      ),
      body: Container(
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: pageBody(),
      ),
    );
  }

  pageBody() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Container(
            height: size.height * 0.6,
            width: size.width * 0.8,
            child: Center(
                child: allContributions != null
                    ? allContributions.isNotEmpty
                        ? PieChart(
                            PieChartData(sections: sections),
                            swapAnimationDuration:
                                Duration(milliseconds: 150), // Optional
                            swapAnimationCurve: Curves.linear, // Optional
                          )
                        : Text("Yardım yok")
                    : spinkit),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white70,
            height: size.height * 0.2,
            child: Text(
              "Yukarıdaki grafikte uygulamamız araclığıyla, sizlerin sayesinde yapılan yardımları görüntülemektesin.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  buildSections() {
    sections = [
      PieChartSectionData(
        title: "Dodact",
        color: Colors.black,
        showTitle: true,
        value: dodactRatio,
        titleStyle: TextStyle(color: Colors.white, fontSize: 22),
        badgeWidget: Container(
          color: Colors.amberAccent,
          width: 80,
          height: 80,
          child: Image.asset(
            "assets/images/app/logo.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
      PieChartSectionData(
          showTitle: false,
          color: Colors.green,
          badgeWidget: Container(
            color: Colors.amberAccent,
            width: 80,
            height: 80,
            child: Image.asset(
              "assets/images/companies/tema.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          value: temaRatio,
          titleStyle: TextStyle(color: Colors.black, fontSize: 22)),
    ];
  }
}
