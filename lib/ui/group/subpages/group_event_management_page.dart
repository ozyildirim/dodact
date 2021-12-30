import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupEventManagementPage extends StatefulWidget {
  @override
  State<GroupEventManagementPage> createState() =>
      _GroupEventManagementPageState();
}

class _GroupEventManagementPageState extends State<GroupEventManagementPage> {
  GroupProvider groupProvider;

  @override
  void initState() {
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Topluluk Etkinlik Yönetimi"),
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
        child: FutureBuilder(
          future: getGroupEvents(),
          builder: (context, AsyncSnapshot<List<EventModel>> asyncSnapshot) {
            if (asyncSnapshot.connectionState != ConnectionState.done) {
              return Center(
                child: spinkit,
              );
            } else {
              if (asyncSnapshot.data.length == 0) {
                return Center(
                    child: Text(
                  "Topluluğa ait etkinlik bulunmuyor.",
                  style: TextStyle(fontSize: kPageCenteredTextSize),
                ));
              } else {
                return GridView.builder(
                    itemCount: asyncSnapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: mediaQuery.size.width * 0.02,
                      mainAxisSpacing: mediaQuery.size.width * 0.02,
                    ),
                    itemBuilder: (context, index) {
                      var event = asyncSnapshot.data[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(event.eventImages[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: Colors.grey,
                                  child: ListTile(
                                    title: Text(
                                      event.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      DateFormat("dd/MM/yyyy")
                                          .format(event.creationDate),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.black),
                                        onPressed: () {
                                          showDeleteEventDialog(event.id);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            }
            // return main screen here
          },
        ),
      ),
    );
  }

  Future<void> showDeleteEventDialog(String eventId) async {
    CustomMethods.showCustomDialog(
        context: context,
        confirmButtonText: "Evet",
        confirmActions: () async {
          await deleteGroupEvent(eventId);
        },
        title: "Bu etkinliği silmek istediğinden emin misin?");
  }

  Future<List<EventModel>> getGroupEvents() async {
    return await groupProvider.getGroupEvents(groupProvider.group.groupId);
  }

  Future<void> deleteGroupEvent(String eventId) async {
    await groupProvider.deleteGroupEvent(eventId);

    try {
      await groupProvider.deleteGroupEvent(eventId);
      NavigationService.instance.pop();
      setState(() {});
      CustomMethods.showSnackbar(
          context, "Topluluk gönderisi başarıyla kaldırıldı.");
    } catch (e) {
      CustomMethods.showSnackbar(
          context, "Topluluk gönderisi kaldırılırken bir hata oluştu.");
    }
  }
}
