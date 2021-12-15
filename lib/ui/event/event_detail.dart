import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/utilities/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
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
    if (event.ownerType == "User") {
      if (authProvider.currentUser.uid == event.ownerId) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    event = widget.event;
    tabController = new TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              NavigationService.instance.pop();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: BackButtonIcon(),
            ),
          ),
        ),
        actionsIconTheme: IconThemeData(color: Colors.black),
        actions: canUserControlEvent()
            ? [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        icon: Icon(Icons.more_vert, color: Colors.black),
                        onSelected: (value) async {
                          if (value == 1) {
                            await _showDeleteEventDialog(event.id);
                          } else if (value == 2) {
                            await _showEditEventDialog(event);
                          }
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  child: InkWell(
                                    onTap: () async {
                                      await _showDeleteEventDialog(event.id);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(FontAwesome5Regular.trash_alt,
                                            size: 16),
                                        SizedBox(width: 14),
                                        Text("Sil",
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  )),
                              PopupMenuItem(
                                value: 2,
                                child: Row(
                                  children: [
                                    Icon(FontAwesome5Regular.edit, size: 16),
                                    SizedBox(width: 14),
                                    Text("Düzenle",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              )
                            ]),
                  ),
                )
              ]
            : [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        icon: Icon(Icons.more_vert, color: Colors.black),
                        onSelected: (value) async {
                          if (value == 0) {
                            await _showReportEventDialog(event.id);
                          }
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                child: Row(
                                  children: [
                                    Icon(FontAwesome5Regular.bell, size: 16),
                                    SizedBox(width: 14),
                                    Text("Bildir",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ]),
                  ),
                )
              ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        width: dynamicWidth(1),
        height: dynamicHeight(1),
        child: Column(
          children: [
            _buildEventHeader(),
            _buildEventDetailBody(),
            _buildEventDetailTabs()
            // _buildMap()
          ],
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return GestureDetector(
      onTap: () {
        CommonMethods.showImagePreviewDialog(context,
            url: event.eventImages[0]);
      },
      child: Container(
        width: dynamicWidth(1),
        height: dynamicHeight(0.4),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(event.eventImages[0]),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetailBody() {
    return Container(
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
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, bottom: 12.0),
                    child: Text(
                      event.title,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: kNavbarColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                            DateFormat("MMMM", "tr_TR").format(event.startDate),
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                        Text(DateFormat("d").format(event.startDate),
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            _getCreatorInfo(),

            // Column(
            //   children: [
            //     Text("Etkinlik Başlangıcı", style: TextStyle(fontSize: 18)),
            //     Text(
            //       DateFormat('dd,MM,yyyy hh:mm').format(event.eventStartDate),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailTabs() {
    return Flexible(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            child: TabBar(
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              controller: tabController,
              tabs: [
                Tab(text: "Bilgiler"),
                Tab(text: "Açıklama"),
                Tab(text: "Görseller"),
              ],
            ),
          ),
          Flexible(
            child: TabBarView(controller: tabController, children: [
              buildInfoTab(),
              buildDescriptionTab(),
              buildEventMediaTab(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildDescriptionTab() {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            event.description,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildEventMediaTab() {
    if (event.eventImages.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GFCarousel(
          passiveIndicator: Colors.white,
          enlargeMainPage: true,
          autoPlay: true,
          activeIndicator: Colors.white,
          pagination: true,
          items: event.eventImages.map((image) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  CommonMethods.showImagePreviewDialog(context, url: image);
                },
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child:
                        Image.network(image, fit: BoxFit.cover, width: 1000.0),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildInfoTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: ListTile(
              leading: Icon(
                Icons.category,
              ),
              title: Text(
                event.eventType +
                    (event.isOnline
                        ? " / Online Etkinlik"
                        : " / Fiziksel Etkinlik"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: Text("Etkinlik Türü"),
            ),
          ),
          !event.isOnline
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(
                      event.address,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text("Adres"),
                    trailing: CircleAvatar(
                      backgroundColor: kNavbarColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.map,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _buildMap();
                        },
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.link),
                    title: Text(
                      "Referans Bağlantı",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text("Etkinlik Web Adresi"),
                    onTap: () {
                      CommonMethods.launchURL(event.eventURL);
                    },
                    trailing: IconButton(
                      onPressed: () {
                        showInfoDialog(context,
                            "Bu web sitesi üzerinden online etkinliğe ulaşabilirsin.");
                      },
                      icon: Icon(Icons.info),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                DateFormat("dd.MM.yyyy HH:mm", "tr_TR").format(event.startDate),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: Text("Etkinlik Başlangıç Tarihi"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                DateFormat("dd.MM.yyyy HH:mm", "tr_TR").format(event.endDate),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: Text("Etkinlik Bitiş Tarihi"),
            ),
          ),
        ],
      ),
    );
  }

  showInfoDialog(BuildContext context, String infoDescription) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(title),
          content: Text(
            infoDescription,
            textAlign: TextAlign.center,
          ),
          contentTextStyle: TextStyle(fontSize: 18, color: Colors.black),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            FlatButton(
              child: Text("Tamam"),
              onPressed: () {
                NavigationService.instance.pop();
              },
            ),
          ],
        );
      },
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

              return ListTile(
                onTap: () {
                  if (fetchedUser.uid != userProvider.currentUser.uid) {
                    NavigationService.instance.navigate(
                        k_ROUTE_OTHERS_PROFILE_PAGE,
                        args: fetchedUser);
                  }
                },
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(fetchedUser.profilePictureURL),
                ),
                title: Text(
                  fetchedUser.nameSurname,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
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

              return ListTile(
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_GROUP_DETAIL, args: fetchedGroup);
                },
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage(fetchedGroup.groupProfilePicture),
                ),
                title: Text(
                  fetchedGroup.groupName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              );
          }
        },
      );
    } else {
      return spinkit;
    }
  }

  Future<void> _showDeleteEventDialog(String eventId) async {
    //TODO: burayı düzelt
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu etkinliği silmek istediğinden emin misin?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await _deleteEvent(eventId);
        });
  }

  Future<void> _showReportEventDialog(String eventId) async {
    //TODO: burayı düzelt
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu etkinliği bildirmek istediğinden emin misin?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await reportEvent(eventId);
          NavigationService.instance.pop();
        });
  }

  Future<void> _deleteEvent(String eventId) async {
    bool isLocatedInStorage = event.eventImages != [] ? true : false;

    //POST ENTRY SİL - STORAGE ELEMANLARINI SİL
    CommonMethods().showLoaderDialog(context, "İşlemin Gerçekleştiriliyor.");

    await Provider.of<EventProvider>(context, listen: false)
        .deleteEvent(event.id, isLocatedInStorage);

    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
    //}
  }

  _showEditEventDialog(EventModel event) {
    NavigationService.instance.navigate(k_ROUTE_EVENT_EDIT_PAGE, args: event);
  }

  _buildMap() {
    if (event.locationCoordinates != null) {
      var lat = event.locationCoordinates.split(",")[0];
      var lng = event.locationCoordinates.split(",")[1];

      final CameraPosition eventMapCameraPosition = CameraPosition(
        target: LatLng(double.parse(lat), double.parse(lng)),
        zoom: 18,
      );

      Marker(
          markerId: MarkerId("0"),
          position: LatLng(double.parse(lat), double.parse(lng)));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MapPage(eventMapCameraPosition);
          },
        ),
      );
    } else {
      logger.i("Bilinmeyen Konum");
    }
  }

  Future<void> reportEvent(String eventId) async {
    var reportReason = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => reportReasonDialog(context),
    );

    if (reportReason != null) {
      CommonMethods()
          .showLoaderDialog(context, "İşleminiz gerçekleştiriliyor.");
      await FirebaseReportService()
          .reportEvent(authProvider.currentUser.uid, event.id, reportReason)
          .then((value) async {
        await CommonMethods().showSuccessDialog(context,
            "Bildirimin bizlere ulaştı. En kısa sürede inceleyeceğiz.");
        NavigationService.instance.pop();
        NavigationService.instance.pop();
      }).catchError((value) async {
        await CommonMethods()
            .showErrorDialog(context, "İşlem gerçekleştirilirken hata oluştu.");
        NavigationService.instance.pop();
      });
    } else {
      NavigationService.instance.pop();
    }
  }
}

class MapPage extends StatefulWidget {
  final CameraPosition eventLocation;

  MapPage(this.eventLocation);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: goToEventLocation,
        backgroundColor: kNavbarColor,
        label: Text('Etkinlik Konumu'),
        icon: Icon(Icons.directions),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Etkinlik Konum Bilgileri"),
      ),
      body: Container(
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: widget.eventLocation,
          compassEnabled: true,
          mapToolbarEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          buildingsEnabled: false,
          markers: {
            Marker(
              infoWindow: InfoWindow(title: "Etkinlik Konum"),
              zIndex: 1,
              markerId: MarkerId("1"),
              position: LatLng(widget.eventLocation.target.latitude,
                  widget.eventLocation.target.longitude),
            )
          },
        ),
      ),
    );
  }

  Future goToEventLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(widget.eventLocation));
  }
}
