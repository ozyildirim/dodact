import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';

import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/interest_model.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InterestsPage extends StatefulWidget {
  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends BaseState<InterestsPage> {
  bool isSelected = false;

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  List<FormBuilderFieldOption> selectedTheaterCategories = [];
  List<FormBuilderFieldOption> selectedMusicCategories = [];
  List<FormBuilderFieldOption> selectedDanceCategories = [];
  List<FormBuilderFieldOption> selectedVisualCategories = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: FormBuilder(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text("İlgi Alanları"),
            automaticallyImplyLeading: false,
            actionsIconTheme: IconThemeData(color: Colors.black),
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 8,
            actions: [
              IconButton(icon: Icon(Icons.info_outline), onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    navigateLanding();
                  })
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () async {
              _formKey.currentState.save();
              if (_formKey.currentState.validate()) {
                print(_formKey.currentState.value);
                await updateInterests();
              }
            },
          ),
          body: Column(
            children: [
              Container(
                height: dynamicHeight(0.8),
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    var category = categoryList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: ExpansionCard(
                          initiallyExpanded: false,
                          onExpansionChanged: (value) {
                            if (value == false) {
                              _formKey.currentState.save();
                              if (_formKey.currentState.validate()) {
                                print(_formKey.currentState.value);
                              }
                            }
                          },
                          background: Image.asset(
                            category.coverPhotoUrl,
                          ),
                          title: Container(
                            child: Text(
                              category.name,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          children: [buildChoiceContainer(category)],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Widget> showInterestDialog(InterestType interest) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        content: buildChoiceContainer(interest),
      ),
    );
  }

  buildChoiceContainer(InterestType interest) {
    var chosenList = buildPreselectedChipOptions(interest);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child: Column(
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FormBuilderFilterChip(
                      spacing: 6,
                      padding: EdgeInsets.all(8),
                      backgroundColor: Colors.amberAccent,
                      labelStyle: TextStyle(fontSize: 16),
                      name: interest.name,
                      initialValue: chosenList,
                      options: buildChipOptions(interest),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildChipOptions(InterestType interest) {
    List<FormBuilderFieldOption> options = [];

    for (var subCategory in interest.subCategories) {
      options.add(
        FormBuilderFieldOption(
          value: subCategory,
          child: Text(subCategory),
        ),
      );
    }

    return options;
  }

  buildPreselectedChipOptions(InterestType interest) {
    List<FormBuilderFieldOption> preselectedOptions = [];

    if (authProvider.currentUser.interests != null) {
      authProvider.currentUser.interests.map((interestElement) {
        if (interestElement.interestCategory == interest.name) {
          interestElement.interestSubcategory.map((subCategory) {
            preselectedOptions.add(FormBuilderFieldOption(
              value: subCategory,
              child: Text(subCategory),
            ));
          });

          return preselectedOptions;
        } else if (interestElement.interestCategory == interest.name) {
          interestElement.interestSubcategory.map((subCategory) {
            preselectedOptions.add(FormBuilderFieldOption(
              value: subCategory,
              child: Text(subCategory),
            ));
          });

          return preselectedOptions;
        } else if (interestElement.interestCategory == interest.name) {
          interestElement.interestSubcategory.map((subCategory) {
            preselectedOptions.add(FormBuilderFieldOption(
              value: subCategory,
              child: Text(subCategory),
            ));
          });

          return preselectedOptions;
        } else {
          interestElement.interestSubcategory.map((subCategory) {
            preselectedOptions.add(FormBuilderFieldOption(
              value: subCategory,
              child: Text(subCategory),
            ));
          });

          return preselectedOptions;
        }
      });
    } else {
      return preselectedOptions;
    }
  }

  void navigateLanding() {
    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
  }

  Future<void> updateInterests() async {
    try {
      CommonMethods().showLoaderDialog(context, "Hemen hallediyoruz.");
      selectedTheaterCategories = _formKey.currentState.value['Tiyatro'] ?? [];
      selectedMusicCategories = _formKey.currentState.value['Müzik'] ?? [];
      selectedDanceCategories = _formKey.currentState.value['Dans'] ?? [];
      selectedVisualCategories =
          _formKey.currentState.value['Görsel Sanatlar'] ?? [];

      print(selectedTheaterCategories);
      print(selectedMusicCategories);
      print(selectedDanceCategories);
      print(selectedVisualCategories);

      List<InterestModel> selectedInterestsList = [
        InterestModel(
            interestId: "0",
            interestCategory: "Tiyatro",
            interestSubcategory: selectedTheaterCategories),
        InterestModel(
            interestId: "1",
            interestCategory: "Müzik",
            interestSubcategory: selectedMusicCategories),
        InterestModel(
            interestId: "2",
            interestCategory: "Dans",
            interestSubcategory: selectedDanceCategories),
        InterestModel(
            interestId: "3",
            interestCategory: "Görsel Sanatlar",
            interestSubcategory: selectedVisualCategories),
      ];

      await authProvider.updateUserInterests(selectedInterestsList);
      print("ne yapıyoruz");
    } catch (e) {
      CommonMethods().showErrorDialog(
          context, "İlgi alanı güncellemesi sırasında hata oluştu.");
    } finally {
      CommonMethods().hideDialog();
    }
  }
}
