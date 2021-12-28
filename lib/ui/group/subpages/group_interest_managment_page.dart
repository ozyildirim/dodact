import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/interest/interests_util.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class GroupInterestManagementPage extends StatefulWidget {
  @override
  _GroupInterestManagementPageState createState() =>
      _GroupInterestManagementPageState();
}

class _GroupInterestManagementPageState
    extends State<GroupInterestManagementPage> {
  GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();
  GroupProvider groupProvider;
  GroupModel group;
  bool isUpdated = false;
  bool isLoading = false;
  List<String> selectedInterests = [];

  @override
  void initState() {
    super.initState();
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    group = groupProvider.group;
    getGroupInterests();
  }

  getGroupInterests() {
    selectedInterests = group.selectedInterests;
  }

  @override
  Widget build(BuildContext context) {
    print(group.toString());
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: isLoading
          // ignore: missing_required_param
          ? FloatingActionButton(
              child: CircularProgressIndicator(color: Colors.white))
          : isUpdated
              ? FloatingActionButton(
                  onPressed: updateGroupInterests,
                  child: Icon(Icons.check),
                )
              : null,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Topluluk İlgi Alanları'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: buildChipField(),
        // child: ,
      ),
    );
  }

  buildChipField() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12),
            child: Row(
              children: [
                Flexible(
                  child: Text("Topluluk İlgi Alanlarını Seç",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12),
            child: Text(
                "Diğer sanatseverler topluluğunun ne ile ilgilendiğini görsün! Uygulama içindeki maceranızı özelleştirmek için ilgilendiğiniz alanları seç.",
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
                    print(selected);
                    setState(() {
                      if (group.selectedInterests != selected) {
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

                  initialValue: selectedInterests,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void updateGroupInterests() async {
    setState(() {
      isLoading = true;
    });

    await groupProvider
        .updateGroup(group.groupId, {'selectedInterests': selectedInterests});
    setState(() {
      isLoading = false;
      isUpdated = false;
    });
    CustomMethods.showSnackbar(context, "İlgi alanları güncellendi");
  }
}
