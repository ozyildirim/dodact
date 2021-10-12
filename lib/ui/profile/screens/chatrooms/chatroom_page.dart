import 'dart:async';

import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/message_model.dart';
import 'package:dodact_v1/provider/chatroom_provider.dart';
import 'package:dodact_v1/utilities/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
                child: StreamBuilder(
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length > 0) {
                        var messages = snapshot.data.docs;

                        Timer(
                            Duration(seconds: 1),
                            () => scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                ));

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: messages.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onLongPress: () {
                                showMessageDialog(messages[index]["senderId"],
                                    messages[index]["messageId"]);
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 14, right: 14, top: 10, bottom: 10),
                                child: Align(
                                  alignment: (messages[index]["senderId"] !=
                                          authProvider.currentUser.uid
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (messages[index]["senderId"] !=
                                              authProvider.currentUser.uid
                                          ? Colors.grey.shade200
                                          : Color(0xff194d25)),
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: SelectableText(
                                      messages[index]["message"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: messages[index]["senderId"] !=
                                                  authProvider.currentUser.uid
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Text(
                              "Mesaj geçmişi yok.",
                              style: TextStyle(fontSize: kPageCenteredTextSize),
                            ),
                          ),
                        );
                      }
                    } else {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                  stream: chatroomsRef
                      .doc(roomId)
                      .collection('messages')
                      .orderBy('messageCreationDate', descending: false)
                      .snapshots(),
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
                          name: "message",
                          decoration: InputDecoration(
                              hintText: "Mesaj yaz",
                              hintStyle: TextStyle(color: Colors.black),
                              border: InputBorder.none),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
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
        FocusScope.of(context).unfocus();
      } catch (e) {
        print(e);
        formKey.currentState.reset();
        FocusScope.of(context).unfocus();
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
