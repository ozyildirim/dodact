import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/request_model.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum ObjectStatus { waiting, approved, rejected }

class UserRequestsStatusPage extends StatefulWidget {
  @override
  _UserRequestsStatusPageState createState() => _UserRequestsStatusPageState();
}

class _UserRequestsStatusPageState extends BaseState<UserRequestsStatusPage> {
  RequestProvider requestProvider;
  PostProvider postProvider;
  EventProvider eventProvider;

  @override
  void initState() {
    super.initState();
    postProvider = Provider.of<PostProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "İsteklerim",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RequestStatusPageBodyPart(),
        ),
      ),
    );
  }
}

class RequestStatusPageBodyPart extends StatefulWidget {
  @override
  _RequestStatusPageBodyPartState createState() =>
      _RequestStatusPageBodyPartState();
}

class _RequestStatusPageBodyPartState
    extends BaseState<RequestStatusPageBodyPart> {
  @override
  void initState() {
    super.initState();
    Provider.of<RequestProvider>(context, listen: false)
        .getUserRequests(authProvider.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);

    if (requestProvider.requests == null) {
      return Center(child: spinkit);
    } else if (requestProvider.requests.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: Center(
            child: Container(
          color: Colors.white70,
          child: Text("Herhangi bir istekte bulunmadınız.",
              style: TextStyle(fontSize: 22)),
        )),
      );
    } else {
      List<RequestModel> postRequests = requestProvider.requests
          .where((element) => element.requestFor == "Post")
          .toList();
      List<RequestModel> groupRequests = requestProvider.requests
          .where((element) => element.requestFor == "Group")
          .toList();

      List<RequestModel> eventRequests = requestProvider.requests
          .where((element) => element.requestFor == "Event")
          .toList();

      ObjectStatus objectStatus;
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: refreshRequests,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      Text("İçerik İsteklerim", style: TextStyle(fontSize: 24)),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                      itemCount: postRequests.length,
                      // ignore: missing_return
                      itemBuilder: (context, index) {
                        RequestModel request = postRequests[index];

                        if (request.isExamined == false) {
                          objectStatus = ObjectStatus.waiting;
                        } else if (request.isExamined == true &&
                            request.isApproved == true) {
                          objectStatus = ObjectStatus.approved;
                        } else if (request.isExamined == true &&
                            request.isApproved == false) {
                          objectStatus = ObjectStatus.rejected;
                        }

                        switch (objectStatus) {
                          case ObjectStatus.waiting:
                            return Container(
                              color: Colors.white70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    FontAwesome5Solid.hourglass_start,
                                    color: Colors.grey,
                                  ),
                                ),
                                title: Text(request.requestId),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                                    .format(request.requestDate)
                                    .toString()),
                              ),
                            );

                          case ObjectStatus.approved:
                            return Container(
                              color: Colors.white70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    FontAwesome5Solid.check,
                                    color: Colors.green,
                                  ),
                                ),
                                title: Text(request.requestId),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                                    .format(request.requestDate)
                                    .toString()),
                              ),
                            );

                          case ObjectStatus.rejected:
                            return Container(
                              color: Colors.white70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    FontAwesome5Solid.times,
                                    color: Colors.red,
                                  ),
                                ),
                                title: Text(request.requestId),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                                    .format(request.requestDate)
                                    .toString()),
                                trailing: IconButton(
                                    icon: Icon(Icons.info),
                                    onPressed: () {
                                      CommonMethods().showInfoDialog(
                                          context,
                                          "İçeriğiniz reddedilmiştir.\nSebebi: ${request.rejectionMessage}",
                                          "Bilgilendirme");
                                    }),
                              ),
                            );
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Etkinlik Oluşturma İsteklerim",
                      style: TextStyle(fontSize: 24)),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                      itemCount: eventRequests.length,
                      // ignore: missing_return
                      itemBuilder: (context, index) {
                        RequestModel request = eventRequests[index];

                        if (request.isExamined == false) {
                          objectStatus = ObjectStatus.waiting;
                        } else if (request.isExamined == true &&
                            request.isApproved == true) {
                          objectStatus = ObjectStatus.approved;
                        } else if (request.isExamined == true &&
                            request.isApproved == false) {
                          objectStatus = ObjectStatus.rejected;
                        }

                        switch (objectStatus) {
                          case ObjectStatus.waiting:
                            return Container(
                              color: Colors.white70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    FontAwesome5Solid.hourglass_start,
                                    color: Colors.grey,
                                  ),
                                ),
                                title: Text(request.requestId),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                                    .format(request.requestDate)
                                    .toString()),
                              ),
                            );

                          case ObjectStatus.approved:
                            return Container(
                              color: Colors.white70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    FontAwesome5Solid.check,
                                    color: Colors.green,
                                  ),
                                ),
                                title: Text(request.requestId),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                                    .format(request.requestDate)
                                    .toString()),
                              ),
                            );

                          case ObjectStatus.rejected:
                            return Container(
                              color: Colors.white70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    FontAwesome5Solid.times,
                                    color: Colors.red,
                                  ),
                                ),
                                title: Text(request.requestId),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                                    .format(request.requestDate)
                                    .toString()),
                                trailing: IconButton(
                                    icon: Icon(Icons.info),
                                    onPressed: () {
                                      CommonMethods().showInfoDialog(
                                          context,
                                          "İçeriğiniz reddedilmiştir.\nSebebi: ${request.rejectionMessage}",
                                          "Bilgilendirme");
                                    }),
                              ),
                            );
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Grup Oluşturma İsteklerim",
                      style: TextStyle(fontSize: 24)),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                      itemCount: groupRequests.length,
                      // ignore: missing_return
                      itemBuilder: (context, index) {
                        RequestModel request = groupRequests[index];

                        if (request.isExamined == false) {
                          objectStatus = ObjectStatus.waiting;
                        } else if (request.isExamined == true &&
                            request.isApproved == true) {
                          objectStatus = ObjectStatus.approved;
                        } else if (request.isExamined == true &&
                            request.isApproved == false) {
                          objectStatus = ObjectStatus.rejected;
                        }

                        switch (objectStatus) {
                          case ObjectStatus.waiting:
                            return Container(
                              color: Colors.white70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    FontAwesome5Solid.hourglass_start,
                                    color: Colors.grey,
                                  ),
                                ),
                                title: Text(request.subjectId),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                                    .format(request.requestDate)
                                    .toString()),
                              ),
                            );

                          case ObjectStatus.approved:
                            return Container(
                              color: Colors.white70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    FontAwesome5Solid.check,
                                    color: Colors.green,
                                  ),
                                ),
                                title: Text(request.subjectId),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                                    .format(request.requestDate)
                                    .toString()),
                              ),
                            );

                          case ObjectStatus.rejected:
                            return Container(
                              color: Colors.white70,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    FontAwesome5Solid.times,
                                    color: Colors.red,
                                  ),
                                ),
                                title: Text(request.subjectId),
                                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                                    .format(request.requestDate)
                                    .toString()),
                                trailing: IconButton(
                                    icon: Icon(Icons.info),
                                    onPressed: () {
                                      CommonMethods().showInfoDialog(
                                          context,
                                          "İçeriğiniz reddedilmiştir.\nSebebi: ${request.rejectionMessage}",
                                          "Bilgilendirme");
                                    }),
                              ),
                            );
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> refreshRequests() async {
    await Provider.of<RequestProvider>(context, listen: false)
        .getUserRequests(authProvider.currentUser.uid);
  }
}
