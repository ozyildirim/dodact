import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/event_model.dart';
import 'package:dodact_v1/provider/group_provider.dart';
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

  String get kBackgroundImage => null;

  get spinkit => null;

  @override
  Widget build(BuildContext context) {
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Grup Etkinlik Yönetimi"),
      ),
      body: Container(
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
                  child: Text("Grup Etkinliği Bulunmamakta."),
                );
              } else {
                return GridView.builder(
                    itemCount: asyncSnapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1,
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
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(event.eventImages[0]),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: ListTile(
                                      leading: Text(
                                        event.city,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      title: Text(
                                        event.eventTitle.substring(0, 15),
                                      ),
                                      subtitle: Text(
                                        DateFormat("dd/MM/yyyy")
                                            .format(event.eventCreationDate),
                                      ),
                                      trailing: PopupMenuButton(
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                              value: 'Sil',
                                              child: Text('Sil'),
                                              onTap: () async {
                                                // await showDeleteEventDialog(
                                                //     event.eventId);
                                                deleteGroupEvent(event.eventId);
                                                setState(() {});
                                              }),
                                        ],
                                      ),
                                    ))
                              ],
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

  Future<void> showDeleteEventDialog(String postId) async {
    print("asdasd");
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
          await deleteGroupEvent(postId);
        });
  }

  Future<List<EventModel>> getGroupEvents() async {
    return await groupProvider.getGroupEvents(groupProvider.group.groupId);
  }

  Future<void> deleteGroupEvent(String eventId) async {
    await groupProvider.deleteGroupEvent(eventId);
  }
}
