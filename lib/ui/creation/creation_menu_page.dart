import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/utilities/lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// ignore: must_be_immutable
class CreationMenuPage extends StatefulWidget {
  final String groupId;

  CreationMenuPage({this.groupId});

  @override
  _CreationMenuPageState createState() => _CreationMenuPageState();
}

class _CreationMenuPageState extends BaseState<CreationMenuPage> {
  GlobalKey<FormBuilderState> _postDialogKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> _eventDialogKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int space = 100;

  FocusNode eventCategoryDropdownFocus = new FocusNode();
  FocusNode eventTypeDropdownFocus = new FocusNode();
  // FocusNode radioButtonFocus = new FocusNode();

  FocusNode postCategoryDropdownFocus = new FocusNode();
  FocusNode postTypeDropdownFocus = new FocusNode();

  @override
  void dispose() {
    super.dispose();
    eventCategoryDropdownFocus.dispose();
    eventTypeDropdownFocus.dispose();
    postCategoryDropdownFocus.dispose();
    postTypeDropdownFocus.dispose();
    // radioButtonFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
            elevation: 8,
            title: Text(
              "Oluştur",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            actions: widget.groupId == null
                ? [
                    MaterialButton(
                      onPressed: () {
                        NavigationService.instance
                            .navigate(k_ROUTE_USER_APPLICATION_MENU);
                      },
                      child: Text("Başvurular",
                          style: TextStyle(color: Colors.white)),
                    )
                  ]
                : null),
        key: _scaffoldKey,
        extendBodyBehindAppBar: false,
        body: Container(
          height: size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              userProvider.currentUser.permissions['create_post'] != false
                  ? _buildCard(
                      Icons.post_add,
                      "İçerik Oluştur",
                      "Kendine özgü içeriklerinle topluluk arasındaki yerini al!",
                      showCreateContentBottomSheet)
                  : Container(),
              userProvider.currentUser.permissions['create_event'] != false
                  ? _buildCard(
                      Icons.event_available,
                      "Etkinlik Oluştur",
                      "Etkinliklerini topluluğa kolayca ulaştır, yeni serüvenlere açıl!",
                      showCreateEventBottomSheet)
                  : Container(),
            ],
          ),
        )
        // ListView(
        //   children: <Widget>[
        //     Stack(
        //       children: [
        // CurvedListItem(
        //   textPos: 150,
        //   boxSize: 246,
        //   spaceValue: 110,
        //   title: 'Etkinlik',
        //   onTap: () async {
        //     showCreateEventBottomSheet();
        //   },
        //   conImage:
        //       AssetImage('assets/images/creation/etkinlik_olustur.jpg'),
        // ),
        //         CurvedListItem(
        //           textPos: 120,
        //           boxSize: 180,
        //           spaceValue: 0,
        //           title: 'İçerik',
        //           onTap: () async {
        //             showCreateContentBottomSheet();
        //           },
        //           conImage:
        //               AssetImage('assets/images/creation/icerik_olustur.jpg'),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        );
  }

  _buildCard(IconData icon, String title, String description, Function onTap,
      {String groupId}) {
    var cardBackgroundColor = Color(0xFFF8F9FA);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: cardBackgroundColor,
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 8,
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.12,
                    child: Icon(icon, size: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showCreateContentBottomSheet() async {
    // var result = await userProvider.canUserCreatePostInCurrentDay();

    var size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return FormBuilder(
          key: _postDialogKey,
          child: new Container(
            padding: EdgeInsets.only(
              left: 5.0,
              right: 5.0,
              top: 5.0,
              bottom: 5.0,
            ),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  title: const Text(
                    'İçerik Oluştur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: Text(
                          "Kategori",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            color: Colors.grey[200],
                            width: size.width * 0.4,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FormBuilderDropdown(
                                name: "postCategory",
                                focusNode: postCategoryDropdownFocus,
                                decoration: InputDecoration(
                                  hintText: "Kategori Seçin",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                items: buildArtCategoryDropdownItems(),
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: Text(
                          "Tür",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: size.width * 0.4,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FormBuilderChoiceChip(
                                name: "postType",
                                // focusNode: postTypeDropdownFocus,
                                direction: Axis.horizontal,
                                padding: EdgeInsets.all(12),
                                spacing: 4,
                                decoration: InputDecoration(
                                  hintText: "Tür Seçin",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                options: buildPostTypeChips(),
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Divider(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      child: new ListTile(
                        title: const Text(
                          'Uygula',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () async {
                          submitPostDialog();
                        },
                      ),
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: new ListTile(
                        title: const Text(
                          'Temizle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () async {
                          NavigationService.instance.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    // if (result) {

    // } else {
    //   print("asdassda");
    //   showSnackbar("Her gün 1 içerik oluşturabilirsin.");
    // }
  }

  showSnackbar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  showCreateEventBottomSheet() {
    var size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return FormBuilder(
          key: _eventDialogKey,
          child: new Container(
            padding: EdgeInsets.only(
              left: 5.0,
              right: 5.0,
              top: 5.0,
              bottom: 5.0,
            ),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
            ),
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  title: const Text(
                    'Etkinlik Oluştur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: Text(
                          "Kategori",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            color: Colors.grey[200],
                            width: size.width * 0.4,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FormBuilderDropdown(
                                name: "eventCategory",
                                focusNode: eventCategoryDropdownFocus,
                                decoration: InputDecoration(
                                  hintText: "Kategori Seçin",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                items: buildArtCategoryDropdownItems(),
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: Text(
                          "Tür",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            color: Colors.grey[200],
                            width: size.width * 0.4,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FormBuilderDropdown(
                                name: "eventType",
                                focusNode: eventTypeDropdownFocus,
                                decoration: InputDecoration(
                                  hintText: "Tür Seçin",
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                items: buildEventTypeDropdownItems(),
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        child: Text(
                          "Online Etkinlik",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            color: Colors.grey[200],
                            width: size.width * 0.4,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FormBuilderRadioGroup(
                                // focusNode: radioButtonFocus,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                name: "online_status",
                                options: [
                                  FormBuilderFieldOption(
                                    value: true,
                                    child: Text("Online"),
                                  ),
                                  FormBuilderFieldOption(
                                    value: false,
                                    child: Text("Offline"),
                                  ),
                                ],
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Divider(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      child: new ListTile(
                        title: const Text(
                          'Uygula',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () async {
                          submitEventDialog();
                        },
                      ),
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: new ListTile(
                        title: const Text(
                          'Temizle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () async {
                          NavigationService.instance.pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  buildArtCategoryDropdownItems() {
    return artCategories
        .map((category) => DropdownMenuItem(
              value: category,
              child: Center(
                child: Text(
                  category,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ))
        .toList();
  }

  buildEventTypeDropdownItems() {
    return eventTypes
        .map((type) => DropdownMenuItem(
              value: type,
              child: Center(
                child: Text(
                  type,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ))
        .toList();
  }

  buildPostTypeChips() {
    return postTypes
        .map((e) => FormBuilderFieldOption(value: e, child: Text(e)))
        .toList();
  }

  void submitEventDialog() {
    if (_eventDialogKey.currentState.saveAndValidate()) {
      var eventCategory = _eventDialogKey.currentState.value['eventCategory'];
      var eventType = _eventDialogKey.currentState.value['eventType'];
      bool onlineStatus = _eventDialogKey.currentState.value['online_status'];

      NavigationService.instance.pop();
      NavigationService.instance.navigate(k_ROUTE_CREATE_EVENT_PAGE, args: [
        eventCategory,
        eventType,
        onlineStatus,
        widget.groupId ?? null
      ]);
    }
  }

  void submitPostDialog() {
    if (_postDialogKey.currentState.saveAndValidate()) {
      var postCategory = _postDialogKey.currentState.value['postCategory'];
      var postType = _postDialogKey.currentState.value['postType'];

      print(postCategory);
      print(postType);

      NavigationService.instance.pop();
      NavigationService.instance.navigate(k_ROUTE_CREATE_POST_PAGE,
          args: [postType, postCategory, widget.groupId ?? null]);
    }
  }
}
