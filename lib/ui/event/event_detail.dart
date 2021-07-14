import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/model/group_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/common_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
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

  @override
  void initState() {
    _event = widget.event;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          backwardsCompatibility: true,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(_event.eventTitle, style: TextStyle(color: Colors.black)),
        ),
        body: Container(
          width: dynamicWidth(1),
          child: Column(
            children: [_buildEventImageCarousel(), _buildEventHeaderPart()],
          ),
        ),
      ),
    );
  }

  Widget _buildEventImageCarousel() {
    return Container(
      color: Colors.amberAccent,
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
    if (_event.ownerType == "Bireysel") {
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
    } else if (_event.ownerType == "Grup") {
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
                      DateFormat('dd/MM/yyyy hh:mm').format(_event.eventDate),
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
}
