import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class AboutDodactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    var aboutString =
        "Amatöründen profesyoneline herkesi aramıza beklediğimiz, seviyeli ve faydalı bir kitle oluşturmak için çabaladığımız Dodact ile sen de yeni bir maceraya dahil olabilirsin. Sürpriz yarışmalar ve etkinlikler ile bu zor günlerde sanata dair etkileşimi en üst seviyeye çıkarmak istiyoruz.";

    return Scaffold(
      appBar: AppBar(
        title: Text('Dodact Nedir?'),
      ),
      body: Container(
        height: mediaQuery.size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: 250,
                  child: Image(
                    image: AssetImage(kDodactLogo),
                  ),
                ),
                Container(
                  color: Colors.white70,
                  child: Text(
                    aboutString,
                    style: TextStyle(fontSize: 18),
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
