import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/message_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/chatroom_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:dodact_v1/ui/chatrooms/widgets/chatroom_page_appbar.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:logger/logger.dart';
import 'package:paginate_firestore/bloc/pagination_cubit.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatroomPage extends StatefulWidget {
  final String currentUserId;

  final UserObject otherUserObject;

  ChatroomPage({this.currentUserId, this.otherUserObject});

  @override
  _ChatroomPageState createState() => _ChatroomPageState();
}

class _ChatroomPageState extends BaseState<ChatroomPage> {
  var logger = Logger();
  SharedPreferences sharedPreferences;
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final ScrollController scrollController = ScrollController();
  bool doesRoomExist;
  bool isLoading;
  String roomId;
  String currentUserId;
  String otherUserId;
  ChatroomProvider chatroomProvider;

  UserObject otherUser;

  //Son mesaj silindiğinde buildEmptyRoomAction fonksiyonu 2 kere çalışıyor ve 2 kere pop yapıyor. Bunu önlemek için böyle ilkel bir çözüm buldum.
  int exitCounter = 0;

  setSharedPreference(String otherUserId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('activeChattingUser', otherUserId);
  }

  removeSharedPreference() async {
    await sharedPreferences.remove('activeChattingUser');

    // await sharedPreferences.setString('activeChattingUser', null);
    print("değer sıfırlandı");
  }

  @override
  void initState() {
    chatroomProvider = Provider.of<ChatroomProvider>(context, listen: false);
    currentUserId = widget.currentUserId;
    otherUserId = widget.otherUserObject.uid;

    roomId = generateRoomId(currentUserId, otherUserId);
    setSharedPreference(otherUserId);
    checkChatroom();
    super.initState();
  }

  checkChatroom() async {
    try {
      await chatroomProvider
          .checkChatroom(currentUserId, otherUserId)
          .then((result) {
        if (result == true) {
          setState(() {
            doesRoomExist = true;
            // print("oda mevcut");
          });
        } else {
          setState(() {
            doesRoomExist = false;
            // print("oda mevcut değil");
          });
        }
      });
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void dispose() {
    removeSharedPreference();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ChatroomProvider>(context, listen: false);
    return Scaffold(
      appBar: ChatroomPageAppBar(user: widget.otherUserObject),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: doesRoomExist == true
                  ? buildMessageStream(roomId)
                  : doesRoomExist == false
                      ? Container()
                      : doesRoomExist == null
                          ? Center(child: spinkit)
                          : Container(),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(width: 0.2, color: Colors.black),
                    )),
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                child: FormBuilder(
                  key: _formKey,
                  child: Row(
                    children: <Widget>[
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     height: 30,
                      //     width: 30,
                      //     decoration: BoxDecoration(
                      //       color: Color(0xff194d25),
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //     child: Icon(
                      //       Icons.add,
                      //       color: Colors.white,
                      //       size: 20,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: FormBuilderTextField(
                            enableSuggestions: true,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            name: "message",
                            decoration: InputDecoration(
                                hintText: "Mesaj yaz",
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: "Bu alanı boş bırakmamalısın."),
                              (value) {
                                return ProfanityChecker.profanityValidator(
                                    value);
                              }
                            ]),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          submitMessage();
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Color(0xff194d25),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool showDate = false;

  buildMessageStream(String chatroomId) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PaginateFirestore(
        // emptyDisplay: buildEmptyRoomAction(),
        scrollController: scrollController,
        onEmpty: Center(
          child: Text("Mesaj bulunamadı",
              style: TextStyle(fontSize: kPageCenteredTextSize)),
        ),
        itemsPerPage: 5,
        initialLoader: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
        // Use SliverAppBar in header to make it sticky
        // item builder type is compulsory.
        itemBuilderType:
            PaginateBuilderType.listView, //Change types accordingly
        onReachedEnd: (PaginationLoaded loaded) {
          if (loaded.documentSnapshots.isEmpty) {
            buildEmptyRoomAction();
          }
        },
        itemBuilder: (context, documentSnapshot, index) {
          final message = MessageModel.fromJson(documentSnapshot[index].data());
          if (!message.isRead &&
              message.senderId != userProvider.currentUser.uid) {
            updateMessageRead(documentSnapshot[index], chatroomId);

            // if (message.isRead == false) {
            //   Provider.of<ChatroomProvider>(context, listen: false)
            //       .updateMessageRead(documentSnapshot, chatroomId);
            // }
          }

          return GestureDetector(
            onLongPress: () {
              showMessageDialog(
                  message.senderId, message.messageId, message.message);
            },
            child: Container(
              padding:
                  EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
              child: Align(
                alignment: (message.senderId != authProvider.currentUser.uid
                    ? Alignment.topLeft
                    : Alignment.topRight),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (message.senderId != authProvider.currentUser.uid
                        ? Colors.grey.shade200
                        : Color(0xff194d25)),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    message.message,
                    style: TextStyle(
                        fontSize: 16,
                        color: message.senderId != authProvider.currentUser.uid
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
              ),
            ),
          );
        },

        // orderBy is compulsory to enable pagination
        query: chatroomsRef
            .doc(chatroomId)
            .collection('messages')
            .orderBy('messageCreationDate', descending: true),
        // to fetch real-time data
        isLive: true,
        reverse: true,
        bottomLoader: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  buildEmptyRoomAction() {
    if (exitCounter == 0) {
      if (doesRoomExist == true) {
        chatroomProvider.deleteChatroom(roomId).then((value) {
          print("buildEmptyRoomAction");
          exitCounter++;
          NavigationService.instance.pop();
        });
      }
    }
  }

  submitMessage() async {
    if (checkIfCurrentUserIsBlocked() || checkIfOtherUserIsBlocked()) {
      if (checkIfCurrentUserIsBlocked() && !checkIfOtherUserIsBlocked()) {
        _formKey.currentState.invalidateFirstField(
            errorText: "Bu kullanıcıya mesaj gönderemezsin.");
      } else if (!checkIfCurrentUserIsBlocked() &&
          checkIfOtherUserIsBlocked()) {
        _formKey.currentState
            .invalidateFirstField(errorText: "Bu kullanıcıyı engelledin.");
      } else {
        _formKey.currentState.invalidateFirstField(
            errorText: "Bu kullanıcıya mesaj gönderemezsin.");
      }
    } else {
      if (_formKey.currentState.saveAndValidate()) {
        try {
          if (doesRoomExist != null) {
            if (doesRoomExist == false) {
              await chatroomProvider.createChatRoom(currentUserId, otherUserId);
              setState(() {
                doesRoomExist = true;
              });
            }
            var message =
                _formKey.currentState.value['message'].toString().trim();

            _formKey.currentState.reset();
            await Provider.of<ChatroomProvider>(context, listen: false)
                .sendMessage(roomId, authProvider.currentUser.uid, message)
                .then((value) async {
              print("asda");
              final DocumentReference docRef = chatroomsRef.doc(roomId);

              MessageModel messageModel = MessageModel(
                message: message,
                isRead: false,
                senderId: authProvider.currentUser.uid,
                messageCreationDate: DateTime.now(),
                messageId: value.id,
              );

              await docRef.update({
                'lastMessage': messageModel.toJson(),
              });
            });
          }
        } catch (e) {
          print(e);
          _formKey.currentState.reset();
        }
      }
    }
  }

  checkIfCurrentUserIsBlocked() {
    if (widget.otherUserObject.blockedUserList
        .contains(userProvider.currentUser.uid)) {
      return true;
    }
    return false;
  }

  checkIfOtherUserIsBlocked() {
    if (userProvider.currentUser.blockedUserList
        .contains(widget.otherUserObject.uid)) {
      return true;
    }
    return false;
  }

  showSnackbar(String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 4,
    );
  }

  updateMessageRead(DocumentSnapshot snapshot, String conversationId) {
    final DocumentReference docRef = chatroomsRef
        .doc(conversationId)
        .collection('messages')
        .doc(snapshot.id);

    docRef.update({'isRead': true});
  }

  void showMessageDialog(
      String authorId, String messageId, String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Seçenekler",
            textAlign: TextAlign.center,
          ),
          contentPadding: EdgeInsets.all(16),
          children: [
            authProvider.currentUser.uid == authorId
                ? SimpleDialogOption(
                    child: Text("Mesajı Sil"),
                    onPressed: () {
                      deleteMessage(messageId);
                      Navigator.pop(context);
                    },
                  )
                : SimpleDialogOption(
                    child: Text("Mesajı Şikayet Et"),
                    onPressed: () {
                      Navigator.pop(context);
                      showReportMessageDialog(messageId, message);
                    },
                  ),
          ],
        );
      },
    );
  }

  Future<void> showReportMessageDialog(String messageId, String message) async {
    // CoolAlert.show(
    //     context: context,
    //     type: CoolAlertType.confirm,
    //     text: "Bu mesajı bildirmek istediğinden emin misin?",
    //     confirmBtnText: "Evet",
    //     cancelBtnText: "Vazgeç",
    //     title: "",
    //     onCancelBtnTap: () {
    //       NavigationService.instance.pop();
    //     },
    //     onConfirmBtnTap: () async {
    //       await reportMessage(roomId, messageId, message);
    //       NavigationService.instance.pop();
    //     });

    CustomMethods.showCustomDialog(
        context: context,
        confirmActions: () async {
          await reportMessage(roomId, messageId, message);
          NavigationService.instance.pop();
        },
        title: "Bu mesajı bildirmek istediğinden emin misin?",
        confirmButtonText: "Evet");
  }

  reportMessage(String roomId, String messageId, String message) async {
    var result = await FirebaseReportService.checkPrivateMessageHasSameReporter(
        reporterId: userProvider.currentUser.uid,
        reportedPrivateMessageId: messageId);

    if (result) {
      showSnackbar("Bu mesajı daha önce bildirdin");
    } else {
      try {
        await FirebaseReportService.reportMessage(
            currentUserId, roomId, messageId, message);
        showSnackbar(
            "Bildirimin bizlere ulaştı. En kısa sürede inceleyeceğiz.");
      } catch (e) {
        showSnackbar("İşlem gerçekleştirilirken hata oluştu.");
      }
    }
  }

  generateRoomId(String firstUserId, String secondUserId) {
    String roomId;
    int result = firstUserId.compareTo(secondUserId);

    if (result < 0) {
      roomId = firstUserId + "_" + secondUserId;
    } else {
      roomId = secondUserId + "_" + firstUserId;
    }
    return roomId;
  }

  void deleteMessage(String messageId) async {
    await Provider.of<ChatroomProvider>(context, listen: false)
        .deleteMessage(roomId, messageId);
  }
}
