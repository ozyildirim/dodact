import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
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
import 'package:dodact_v1/utilities/dialogs.dart';
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
    tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: BackButton(
                  color: Colors.black,
                ),
              ),
            ),
            actionsIconTheme: IconThemeData(color: Colors.black),
            actions: canUserControlEvent()
                ? [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: PopupMenuButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            icon: Icon(Icons.more_vert, color: Colors.black),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: ListTile(
                                        leading:
                                            Icon(FontAwesome5Regular.trash_alt),
                                        title: Text("Sil"),
                                        onTap: () async {
                                          await _showDeleteEventDialog(
                                              event.id);
                                        }),
                                  )
                                ]),
                      ),
                    )
                  ]
                : [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: PopupMenuButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            icon: Icon(Icons.more_vert, color: Colors.black),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: ListTile(
                                        leading: Icon(FontAwesome5Regular.bell),
                                        title: Text("Bildir"),
                                        onTap: () async {
                                          await _showReportEventDialog(
                                              event.id);
                                        }),
                                  ),
                                ]),
                      ),
                    )
                  ],
            expandedHeight: dynamicHeight(0.4),
            pinned: true,
            snap: false,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                event.eventImages[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //_buildEventHeader(),
                      _buildEventDetailBody(),
                      _buildEventDetailTabs()
                      // _buildMap()
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  //Widget _buildEventHeader() {
  //  return Container(
  //    width: dynamicWidth(1),
  //    height: dynamicHeight(0.4),
  //    decoration: BoxDecoration(
  //      image: DecorationImage(
  //        image: NetworkImage(event.eventImages[0]),
  //        fit: BoxFit.cover,
  //      ),
  //    ),
  //  );
  //}

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
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      event.title,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            _getCreatorInfo(),
            ListTile(
              leading: Icon(Icons.event),
              title: Text(
                DateFormat('dd.MM.yyyy hh:mm').format(event.startDate),
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text("Etkinlik Başlangıcı"),
            ),
            // Column(
            //   children: [
            //     Text("Etkinlik Başlangıcı", style: TextStyle(fontSize: 18)),
            //     Text(
            //       DateFormat('dd,MM,yyyy hh:mm').format(event.eventStartDate),
            //     ),
            //   ],
            // ),

            !event.isOnline
                ? ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(
                      event.city,
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text("Lokasyon"),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      child: IconButton(
                        icon: Icon(Icons.map),
                        onPressed: () async {
                          await _buildMap();
                        },
                      ),
                    ),
                  )
                : ListTile(
                    leading: Icon(Icons.link),
                    title: Text(
                      "Referans Bağlantı",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text("Etkinlik Web Adresi"),
                    onTap: () {
                      CommonMethods.launchURL(event.eventURL);
                    },
                  ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text(
                event.eventType +
                    (event.isOnline
                        ? " / Online Etkinlik"
                        : " / Fiziksel Etkinlik"),
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text("Etkinlik Türü"),
            )
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
            tabs: [
              Tab(text: "Detaylar"),
              Tab(text: "Görseller"),
            ],
          ),
        ),
        Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabBarView(controller: tabController, children: [
              buildDetailTab(),
              buildEventMediaTab(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget buildDetailTab() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          event.description,
          style: TextStyle(fontSize: 16),
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
                        text: fetchedUser.nameSurname,
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

              // return Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: InkWell(
              //         onTap: () {
              //           NavigationService.instance
              //               .navigate(k_ROUTE_GROUP_DETAIL, args: fetchedGroup);
              //         },
              //         child: GFImageOverlay(
              //           width: 100,
              //           height: 100,
              //           shape: BoxShape.circle,
              //           image: NetworkImage(fetchedGroup.groupProfilePicture),
              //           boxFit: BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //     Text(
              //       fetchedGroup.groupName.toUpperCase(),
              //       style: TextStyle(fontWeight: FontWeight.w700),
              //     )
              //   ],
              // );
              return ListTile(
                onTap: () {
                  NavigationService.instance
                      .navigate(k_ROUTE_GROUP_DETAIL, args: fetchedGroup);
                },
                leading: CircleAvatar(
                  radius: 15,
                  backgroundImage:
                      NetworkImage(fetchedGroup.groupProfilePicture),
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
                        text: fetchedGroup.groupName.toUpperCase(),
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
    } else {
      return spinkit;
    }
  }

  Future<void> _showDeleteEventDialog(String eventId) async {
    //TODO: burayı düzelt
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu içeriği silmek istediğinden emin misin?",
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
        text: "Bu içeriği bildirmek istediğinden emin misin?",
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

  _showEditEventDialog() {}

  _buildMap() {
    if (event.locationCoordinates != null) {
      var lat = event.locationCoordinates.split(",")[0];
      var lng = event.locationCoordinates.split(",")[1];

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
