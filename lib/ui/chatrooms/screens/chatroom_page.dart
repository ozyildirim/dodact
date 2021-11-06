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
import 'package:logger/logger.dart';
import 'package:paginate_firestore/bloc/pagination_cubit.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class ChatroomPage extends StatefulWidget {
  final String currentUserId;

  final UserObject otherUserObject;

  ChatroomPage({this.currentUserId, this.otherUserObject});

  @override
  _ChatroomPageState createState() => _ChatroomPageState();
}

class _ChatroomPageState extends BaseState<ChatroomPage> {
  var logger = Logger();
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final ScrollController scrollController = ScrollController();
  bool doesRoomExist;
  bool isLoading;
  String roomId;
  String currentUserId;
  String otherUserId;
  ChatroomProvider chatroomProvider;

  //Son mesaj silindiğinde buildEmptyRoomAction fonksiyonu 2 kere çalışıyor ve 2 kere pop yapıyor. Bunu önlemek için böyle ilkel bir çözüm buldum.
  int exitCounter = 0;

  @override
  void initState() {
    chatroomProvider = Provider.of<ChatroomProvider>(context, listen: false);
    currentUserId = widget.currentUserId;
    otherUserId = widget.otherUserObject.uid;
    roomId = generateRoomId(currentUserId, otherUserId);
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
            print("oda mevcut");
          });
        } else {
          setState(() {
            doesRoomExist = false;
            print("oda mevcut değil");
          });
        }
      });
    } catch (e) {
      logger.e(e);
    }
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
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: FormBuilder(
                  key: _formKey,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Color(0xff194d25),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
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
                              return ProfanityChecker.profanityValidator(value);
                            }
                          ]),
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

  buildMessageStream(String chatroomId) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: PaginateFirestore(
        // emptyDisplay: buildEmptyRoomAction(),
        scrollController: scrollController,
        itemsPerPage: 5,
        // Use SliverAppBar in header to make it sticky
        // item builder type is compulsory.
        itemBuilderType:
            PaginateBuilderType.listView, //Change types accordingly
        onReachedEnd: (PaginationLoaded loaded) {
          if (loaded.documentSnapshots.isEmpty) {
            buildEmptyRoomAction();
          }
        },
        itemBuilder: (index, context, documentSnapshot) {
          final message = MessageModel.fromJson(documentSnapshot.data());
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
                  child: SelectableText(
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
        bottomLoader: Container(
          height: 50,
          child: Center(
            child: CircularProgressIndicator(),
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

          var messageModel = MessageModel(
            message: message,
            isRead: false,
            senderId: authProvider.currentUser.uid,
            messageCreationDate: DateTime.now(),
          );
          await Provider.of<ChatroomProvider>(context, listen: false)
              .sendMessage(roomId, authProvider.currentUser.uid, message);

          _formKey.currentState.reset();
        }
      } catch (e) {
        print(e);
        _formKey.currentState.reset();
      }
    }
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
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu mesajı bildirmek istediğinden emin misin?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await reportMessage(roomId, messageId, message);
          NavigationService.instance.pop();
        });
  }

  showSnackbar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  reportMessage(String roomId, String messageId, String message) async {
    CommonMethods().showLoaderDialog(context, "İşlemin gerçekleştiriliyor.");
    await FirebaseReportService()
        .reporMessage(currentUserId, roomId, messageId, message)
        .then((value) async {
      showSnackbar("Bildirimin bizlere ulaştı. En kısa sürede inceleyeceğiz.");

      NavigationService.instance.pop();
    }).catchError((value) async {
      showSnackbar("İşlem gerçekleştirilirken hata oluştu.");
      NavigationService.instance.pop();
    });
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