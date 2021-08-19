import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TemporaryRegistrationInterestsPage extends StatefulWidget {
  @override
  _TemporaryRegistrationInterestsPageState createState() =>
      _TemporaryRegistrationInterestsPageState();
}

class _TemporaryRegistrationInterestsPageState
    extends BaseState<TemporaryRegistrationInterestsPage> {
  var logger = new Logger();
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButton: selectedIndex != -1
            ? FloatingActionButton(
                onPressed: () {
                  updateUserInterest();
                },
                child: Icon(Icons.save),
              )
            : null,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
          ),
          child: Center(
            child: Container(
              height: dynamicHeight(0.5),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, int position) {
                  return InkWell(
                    onTap: () => setState(() => selectedIndex = position),
                    child: Stack(children: [
                      Card(
                        shape: (selectedIndex == position)
                            ? RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: Colors.amberAccent, width: 4),
                              )
                            : null,
                        elevation: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  categoryList[position].coverPhotoUrl),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              categoryList[position].name,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateUserInterest() async {
    try {
      CommonMethods().showLoaderDialog(context, "Hemen hallediyoruz");
      await authProvider.updateCurrentUser(
        {'mainInterest': categoryList[selectedIndex].name},
      );
      navigateLanding();
    } catch (e) {
      logger.e("Kullanıcı ilgi alanları güncellenirken hata meydana geldi.");
      CommonMethods().showErrorDialog(
          context, "İlgi alanları güncellenirken bir hata meydana geldi");
    }
  }

  void navigateLanding() {
    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
  }
}
