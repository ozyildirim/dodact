import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/app_constants.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class InterestRegistrationPage extends StatefulWidget {
  @override
  _InterestRegistrationPageState createState() =>
      _InterestRegistrationPageState();
}

class _InterestRegistrationPageState
    extends BaseState<InterestRegistrationPage> {
  GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> selectedInterests;
  bool isUpdated = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showInformationDialog();
    });
  }

  checkProfilePicture() async {
    if (userProvider.currentUser.profilePictureURL == null) {
      await userProvider.updateCurrentUser(
          {'profilePictureURL': AppConstant.kDefaultUserProfilePicture});
      userProvider.currentUser.profilePictureURL =
          AppConstant.kDefaultUserProfilePicture;
    }
  }

  @override
  Widget build(BuildContext context) {
    // showInformationDialog();
    return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("İlgi Alanları"),
              actions: [
                IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.info),
                    onPressed: showInformationDialog),
              ],
            ),
            key: _scaffoldKey,
            floatingActionButton: isUpdated != false
                ? isLoading != false
                    ? FloatingActionButton(
                        onPressed: null,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : FloatingActionButton(
                        onPressed: updateUserInterests,
                        child: Icon(Icons.check),
                      )
                : null,
            body: Container(
              height: dynamicHeight(1),
              width: dynamicWidth(1),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.dstATop),
                  image: AssetImage(kBackgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              // child: choiceWidget(),
              child: buildChipField(),
              // child: buildStack(),
            ),
          ),
        ));
  }

  buildChipField() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12),
            child: Text("İlgi Alanlarını Seç",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12),
            child: Text(
                "Diğer sanatseverler ne ile ilgilendiğini görsün! Uygulama içindeki maceranı özelleştirmek için ilgilendiğin alanları seç.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: MultiSelectChipField(
                  key: formKey,
                  decoration: BoxDecoration(), chipColor: Colors.grey[200],
                  selectedChipColor: kNavbarColor,
                  selectedTextStyle: TextStyle(color: Colors.white),
                  textStyle: TextStyle(color: Colors.black),
                  // title: Text("İlgi Alanlarını Seç",
                  //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  title: Text(""),
                  onTap: (selected) {
                    setState(() {
                      if (userProvider.currentUser.selectedInterests !=
                          selected) {
                        isUpdated = true;
                        selectedInterests = selected;
                      } else {
                        isUpdated = false;
                      }
                    });
                  },
                  headerColor: Colors.transparent,
                  searchHint: "Ara",
                  scroll: false,
                  searchable: true,
                  showHeader: true,
                  chipShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    // side: BorderSide(color: Colors.grey, width: 1),
                  ),
                  items: categoryList.map((e) {
                    return MultiSelectItem(e, e);
                  }).toList(),
                  // itemBuilder: (item, state) {
                  //   return InkWell(
                  //     onTap: () {
                  //       selectedInterests.contains(item.value)
                  //           ? selectedInterests.remove(item.value)
                  //           : selectedInterests.add(item.value);
                  //       state.didChange(selectedInterests);
                  //       formKey.currentState.validate();
                  //     },
                  //     child: Chip(
                  //       label: Text(item.label),
                  //     ),
                  //   );
                  // },
                  initialValue: selectedInterests,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  updateUserInterests() async {
    try {
      setState(() {
        isLoading = true;
      });
      await userProvider
          .updateCurrentUser({'selectedInterests': selectedInterests});
      setState(() {
        isUpdated = false;
        isLoading = false;
      });
      CustomMethods.showSnackbar(context, "İlgi alanları güncellendi.");
      navigateLanding();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CustomMethods.showSnackbar(context, "Bir hata oluştu.");
    }
  }

  void navigateLanding() {
    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
  }

  showInformationDialog() {
    String text =
        "Dodact içerisindeki maceranı şekillendirmek ve diğer sanatseverlerin seni daha iyi tanıyabilmesini sağlamak için ilgi alanlarını belirtebilirsin!";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("İlgi Alanları")),
          content: Text(text, style: TextStyle(fontSize: 18)),
          actions: [
            FlatButton(
              child: Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    // return AlertDialog(
    //   title: Text("Bilgilendirme"),
    //   content: Text(text),
    //   actions: [
    //     FlatButton(
    //       child: Text("Kapat"),
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //   ],
    // );
  }
}
