import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TemporaryInterestsPage extends StatefulWidget {
  @override
  _TemporaryInterestsPageState createState() => _TemporaryInterestsPageState();
}

class _TemporaryInterestsPageState extends BaseState<TemporaryInterestsPage> {
  var logger = new Logger();
  bool isChanged = false;
  String preselectedOption;

  int selectedIndex;

  @override
  void initState() {
    super.initState();
    getPreselectedIndex();
  }

  getPreselectedIndex() {
    preselectedOption = authProvider.currentUser.mainInterest ?? "";
    if (preselectedOption.length != 0 || preselectedOption != null) {
      int selectedOption = categoryList.indexWhere((element) {
        return element.name == preselectedOption;
      });

      return selectedIndex = selectedOption;
    } else {
      selectedIndex = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateUserInterest();
        },
        child: Icon(Icons.save),
      ),
      appBar: AppBar(
        title: Text("İlgi Alanlarım"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: Center(
          child: Container(
            height: dynamicHeight(0.5),
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
    );
  }

  Future<void> updateUserInterest() async {
    try {
      CommonMethods().showLoaderDialog(context, "Hemen hallediyoruz");
      await authProvider.updateCurrentUser(
        {'mainInterest': categoryList[selectedIndex].name},
      );
      CommonMethods().hideDialog();
    } catch (e) {
      logger.e("Kullanıcı ilgi alanları güncellenirken hata meydana geldi.");
      CommonMethods().showErrorDialog(
          context, "İlgi alanları güncellenirken bir hata meydana geldi");
    }
  }
}
