import 'package:cool_alert/cool_alert.dart';
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
                                  color: Colors.orange,
                                  child: ListTile(
                                    title: Text(
                                      event.eventTitle,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      DateFormat("dd/MM/yyyy")
                                          .format(event.eventCreationDate),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        //TODO: BU kısmı düzenle
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Uyarı"),
                                              content: Text(
                                                  "Bu etkinliği silmek istediğine emin misin?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("Evet"),
                                                  onPressed: () {
                                                    deleteGroupEvent(
                                                        event.eventId);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text("Hayır"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                            // return showDeletePostDialog(
                                            //     post.postId);
                                          },
                                        );
                                      },
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
    print("asdasd");
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
          await deleteGroupEvent(eventId);
        });
  }

  Future<List<EventModel>> getGroupEvents() async {
    return await groupProvider.getGroupEvents(groupProvider.group.groupId);
  }

  Future<void> deleteGroupEvent(String eventId) async {
    await groupProvider.deleteGroupEvent(eventId);
  }
}
