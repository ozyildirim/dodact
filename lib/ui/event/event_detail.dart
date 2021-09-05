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
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EventDetailPage extends StatefulWidget {
  final EventModel event;

  const EventDetailPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends BaseState<EventDetailPage>
    with SingleTickerProviderStateMixin {
  EventModel event;
  Completer<GoogleMapController> controller = Completer();
  TabController tabController;
  var logger = new Logger();

  bool canUserControlEvent() {
    if (event.ownerType == 'Group') {
      if (authProvider.currentUser.ownedGroupIDs.contains(event.ownerId)) {
        return true;
      } else {
        return false;
      }
    } else if (event.ownerType == "User") {
      if (authProvider.currentUser.uid == event.ownerId) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    event = widget.event;
    tabController = new TabController(length: 1, vsync: this);
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
        title: Text("Detay", style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(kBackgroundImage),
        )),
        width: dynamicWidth(1),
        height: dynamicHeight(1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildEventImageCarousel(),
              _buildEventDetailBody(),
              _buildEventDetailTabs()
              // _buildMap()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventImageCarousel() {
    if (event.eventImages.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GFCarousel(
          passiveIndicator: Colors.white,
          enlargeMainPage: true,
          autoPlay: true,
          activeIndicator: Colors.white,
          items: event.eventImages.map((image) {
            return Container(
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

  Widget _buildEventDetailBody() {
    return Container(
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      event.eventTitle,
                      style: GoogleFonts.poppins(fontSize: 24),
                    ),
                  ),
                ),
                !event.isOnline
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: FloatingActionButton(
                          onPressed: () async {
                            await _buildMap();
                          },
                          child: Icon(Icons.navigation),
                        ),
                      )
                    : Container()
              ],
            ),
            _getCreatorInfo(),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                DateFormat('dd,MM,yyyy hh:mm').format(event.eventStartDate),
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text("Etkinlik Başlangıç Tarihi"),
            ),
            ListTile(
              leading: Icon(Icons.view_day),
              title: Text(
                DateFormat('dd,MM,yyyy hh:mm').format(event.eventEndDate),
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text("Etkinlik Bitiş Tarihi"),
            ),
            ListTile(
                leading: Icon(Icons.view_day),
                title: Text(
                  event.isOnline ? "Online Etkinlik" : "Fiziksel Etkinlik",
                  style: TextStyle(fontSize: 18),
                )),
            !event.isOnline
                ? ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text(
                      event.city,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListTile(
                    leading: Icon(Icons.web),
                    title: Text(
                      event.eventURL,
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      CommonMethods.launchURL(event.eventURL);
                    },
                  ),
            ListTile(
                leading: Icon(Icons.category),
                title: Text(
                  event.eventType,
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailTabs() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          child: TabBar(
            labelColor: Colors.black,
            labelStyle: GoogleFonts.poppins(
              fontSize: 18,
            ),
            controller: tabController,
            tabs: const [
              const Tab(text: "Detaylar"),
            ],
          ),
        ),
        Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(controller: tabController, children: [
              buildDetailTab(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget buildDetailTab() {
    return Container(
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          event.eventDescription,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _getCreatorInfo() {
    if (event.ownerType == "User") {
      final provider = Provider.of<UserProvider>(context, listen: false);
      return FutureBuilder(
        future: provider.getOtherUser(event.ownerId),
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

              var nameToShow = fetchedUser.nameSurname == null ||
                      fetchedUser.nameSurname == ""
                  ? fetchedUser.username
                  : fetchedUser.nameSurname;

              return ListTile(
                leading: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(fetchedUser.profilePictureURL),
                ),
                title: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Oluşturan: ",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: nameToShow,
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      );
    } else if (event.ownerType == "Group") {
      final provider = Provider.of<GroupProvider>(context, listen: false);
      return FutureBuilder(
        future: provider.getGroupDetail(event.ownerId),
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

    bool isLocatedInStorage = event.eventImages != [] ? true : false;

    //POST ENTRY SİL - STORAGE ELEMANLARINI SİL
    CommonMethods().showLoaderDialog(context, "İşleminiz gerçekleştiriliyor.");

    await Provider.of<EventProvider>(context, listen: false)
        .deleteEvent(event.eventId, isLocatedInStorage);

    //KULLANICININ / GRUBUN POSTIDS den SİL
    if (event.ownerType == "User") {
      await Provider.of<AuthProvider>(context, listen: false)
          .editUserEventIDs(event.eventId, event.ownerId, false);
    } else if (event.ownerType == "Group") {
      await Provider.of<GroupProvider>(context, listen: false)
          .editGroupPostList(event.eventId, event.ownerId, false);
    }

    //REQUESTİNİ SİL
    await Provider.of<RequestProvider>(context, listen: false)
        .deleteRequest(event.eventId);

    NavigationService.instance.navigateToReset(k_ROUTE_USER_PROFILE);
    //}
  }

  _showEditEventDialog() {}

  _buildMap() {
    if (event.eventLocationCoordinates != null) {
      var lat = event.eventLocationCoordinates.split(",")[0];
      var lng = event.eventLocationCoordinates.split(",")[1];

      final CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(double.parse(lat), double.parse(lng)),
        zoom: 8,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MapPage(_kGooglePlex);
          },
        ),
      );
    } else {
      logger.i("Bilinmeyen Konum");
    }
  }
}

class MapPage extends StatefulWidget {
  final CameraPosition googlePlex;

  MapPage(this.googlePlex);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Etkinlik Konum Bilgileri"),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: widget.googlePlex,
          compassEnabled: true,
          mapToolbarEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          buildingsEnabled: false,
          markers: {
            Marker(
              infoWindow: InfoWindow(title: "Etkinlik Lokasyonu"),
              markerId: MarkerId("1"),
              position: LatLng(widget.googlePlex.target.latitude,
                  widget.googlePlex.target.longitude),
            )
          },
        ),
      ),
    );
  }
}
