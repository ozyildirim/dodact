import 'dart:async';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/message_model.dart';
import 'package:dodact_v1/provider/chatroom_provider.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class ChatroomPage extends StatefulWidget {
  final String chatroomId;

  ChatroomPage({this.chatroomId});

  @override
  _ChatroomPageState createState() => _ChatroomPageState();
}

class _ChatroomPageState extends BaseState<ChatroomPage> {
  String roomId;
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    roomId = widget.chatroomId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ChatroomProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sohbet'),
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
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: PaginateFirestore(
                  scrollController: scrollController,
                  itemsPerPage: 5,
                  // Use SliverAppBar in header to make it sticky
                  // item builder type is compulsory.
                  itemBuilderType:
                      PaginateBuilderType.listView, //Change types accordingly
                  itemBuilder: (index, context, documentSnapshot) {
                    final message =
                        MessageModel.fromJson(documentSnapshot.data());
                    return GestureDetector(
                      onLongPress: () {
                        showMessageDialog(message.senderId, message.messageId);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment:
                              (message.senderId != authProvider.currentUser.uid
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (message.senderId !=
                                      authProvider.currentUser.uid
                                  ? Colors.grey.shade200
                                  : Color(0xff194d25)),
                            ),
                            padding: EdgeInsets.all(16),
                            child: SelectableText(
                              message.message,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: message.senderId !=
                                          authProvider.currentUser.uid
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
                      .doc(roomId)
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
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: FormBuilder(
                  key: formKey,
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

  submitMessage() async {
    if (formKey.currentState.saveAndValidate()) {
      try {
        var message = formKey.currentState.value['message'].toString().trim();

        var messageModel = MessageModel(
          message: message,
          isRead: false,
          senderId: authProvider.currentUser.uid,
          messageCreationDate: DateTime.now(),
        );
        await Provider.of<ChatroomProvider>(context, listen: false)
            .sendMessage(roomId, authProvider.currentUser.uid, message);

        formKey.currentState.reset();
      } catch (e) {
        print(e);
        formKey.currentState.reset();
      }
    }
  }

  void showMessageDialog(String authorId, String messageId) async {
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
                  ),
          ],
        );
      },
    );
  }

  void deleteMessage(String messageId) async {
    await Provider.of<ChatroomProvider>(context, listen: false)
        .deleteMessage(roomId, messageId);
  }
}
