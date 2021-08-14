import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/request_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailPage extends StatefulWidget {
  final EventModel event;

  const EventDetailPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends BaseState<EventDetailPage> {
  EventModel _event;
  Completer<GoogleMapController> _controller = Completer();

  bool canUserControlEvent() {
    if (_event.ownerType == 'Group') {
      if (authProvider.currentUser.ownedGroupIDs.contains(_event.ownerId)) {
        return true;
      } else {
        return false;
      }
    } else if (_event.ownerType == "User") {
      if (authProvider.currentUser.uid == _event.ownerId) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    _event = widget.event;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: canUserControlEvent()
            ? [
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                                leading: Icon(FontAwesome5Regular.trash_alt),
                                title: Text("Sil"),
                                onTap: () async {
                                  await _showDeleteEventDialog();
                                }),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(FontAwesome5Solid.cogs),
                              title: Text("Düzenle"),
                              onTap: () async {
                                await _showEditEventDialog();
                              },
                            ),
                          ),
                        ])
              ]
            : null,
        elevation: 8,
        backwardsCompatibility: true,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(_event.eventTitle, style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(kBackgroundImage),
        )),
        width: dynamicWidth(1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildEventImageCarousel(),
              _buildEventHeaderPart(),
              _buildMap()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventImageCarousel() {
    if (_event.eventImages.isNotEmpty) {
      return Container(
        height: 250,
        width: double.infinity,
        child: GFCarousel(
          autoPlay: true,
          items: _event.eventImages.map((image) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.network(image, fit: BoxFit.cover, width: 1000.0),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildEventHeaderPart() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildCreatorInfo(),
        ),
        Expanded(
          flex: 3,
          child: _buildEventInfo(),
        )
      ],
    );
  }

  Widget _buildCreatorInfo() {
    if (_event.ownerType == "User") {
      final provider = Provider.of<UserProvider>(context, listen: false);
      return FutureBuilder(
        future: provider.getOtherUser(_event.ownerId),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: spinkit);
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: spinkit);
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              UserObject fetchedUser = snapshot.data;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        NavigationService.instance.navigate(
                            k_ROUTE_OTHERS_PROFILE_PAGE,
                            args: fetchedUser.uid);
                      },
                      child: GFImageOverlay(
                        width: 100,
                        height: 100,
                        shape: BoxShape.circle,
                        image: NetworkImage(fetchedUser.profilePictureURL),
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    fetchedUser.nameSurname.toUpperCase(),
                    textAlign: TextAlign.center,
                  )
                ],
              );
          }
        },
      );
    } else if (_event.ownerType == "Group") {
      final provider = Provider.of<GroupProvider>(context, listen: false);
      return FutureBuilder(
        future: provider.getGroupDetail(_event.ownerId),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: spinkit);
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: spinkit);
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              GroupModel fetchedGroup = snapshot.data;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        NavigationService.instance
                            .navigate(k_ROUTE_GROUP_DETAIL, args: fetchedGroup);
                      },
                      child: GFImageOverlay(
                        width: 100,
                        height: 100,
                        shape: BoxShape.circle,
                        image: NetworkImage(fetchedGroup.groupProfilePicture),
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    fetchedGroup.groupName.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  )
                ],
              );
          }
        },
      );
    } else {
      return spinkit;
    }
  }

  Widget _buildEventInfo() {
    return Container(
      height: 200,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(FontAwesome5Solid.adjust),
                    SizedBox(
                      width: 10,
                    ),
                    Text(_event.eventTitle)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(FontAwesome5Solid.calendar),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy hh:mm')
                          .format(_event.eventStartDate),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GFButton(
                  onPressed: () {},
                  color: Colors.cyan,
                  text: "Takvime Ekle",
                  shape: GFButtonShape.pills,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteEventDialog() async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu içeriği silmek istediğinizden emin misiniz?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await _deleteEvent();
        });
  }

  Future<void> _deleteEvent() async {
    //TODO: Bunlardan herhangi birisi patlarsa ne yapacağız?

    bool isLocatedInStorage = _event.eventImages != [] ? true : false;

    //POST ENTRY SİL - STORAGE ELEMANLARINI SİL
    CommonMethods().showLoaderDialog(context, "İşleminiz gerçekleştiriliyor.");

    await Provider.of<EventProvider>(context, listen: false)
        .deleteEvent(_event.eventId, isLocatedInStorage);

    //KULLANICININ / GRUBUN POSTIDS den SİL
    if (_event.ownerType == "User") {
      await Provider.of<AuthProvider>(context, listen: false)
          .editUserEventIDs(_event.eventId, _event.ownerId, false);
    } else if (_event.ownerType == "Group") {
      await Provider.of<GroupProvider>(context, listen: false)
          .editGroupPostList(_event.eventId, _event.ownerId, false);
    }

    //REQUESTİNİ SİL
    await Provider.of<RequestProvider>(context, listen: false)
        .deleteRequest(_event.eventId);

    NavigationService.instance.navigateToReset(k_ROUTE_USER_PROFILE);
    //}
  }

  _showEditEventDialog() {}

  _buildMap() {
    if (_event.eventLocationCoordinates != null) {
      var lat = _event.eventLocationCoordinates.split(",")[0];
      var lng = _event.eventLocationCoordinates.split(",")[1];

      final CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(double.parse(lat), double.parse(lng)),
        zoom: 14.4746,
      );
      return Container(
        height: 300,
        width: double.infinity,
        child: GoogleMap(initialCameraPosition: _kGooglePlex),
      );
    } else {
      return Container(
        height: 50,
        width: double.infinity,
        child: Text("Bilinmeyen Konum", style: TextStyle(fontSize: 24)),
      );
    }
  }
}
