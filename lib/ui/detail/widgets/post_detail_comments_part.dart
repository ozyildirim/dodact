import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/comment_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:dodact_v1/ui/common_widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PostCommentsPage extends StatefulWidget {
  final String postId;
  final String ownerId;

  PostCommentsPage({this.postId, this.ownerId});
  @override
  _PostCommentsPageState createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends BaseState<PostCommentsPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    Provider.of<CommentProvider>(context, listen: false)
        .getPostComments(widget.postId)
        .then((value) {
      print(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = Provider.of<CommentProvider>(context);
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    buildBody() {
      if (commentProvider.comments == null) {
        return Container(
          height: 200,
          child: Center(child: spinkit),
        );
      } else {
        if (commentProvider.comments.isEmpty) {
          return Container(
            height: 200,
            child: Center(
              child: Text(
                "Henüz yorum yapılmamış.",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }
        return Container(
          height: 220,
          child: ListView.builder(
              itemCount: commentProvider.comments.length,
              itemBuilder: (context, index) {
                var comment = commentProvider.comments[index];
                return FutureBuilder(
                    // ignore: missing_return
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                              ConnectionState.none &&
                          userSnapshot.hasData == null) {
                        //print('project snapshot data is: ${projectSnap.data}');
                        return Center(
                          child: Container(
                            child: spinkit,
                          ),
                        );
                      } else if (userSnapshot.connectionState ==
                          ConnectionState.done) {
                        UserObject user = userSnapshot.data;
                        return Slidable(
                          child: Container(
                            color: Colors.white54,
                            child: ListTile(
                              onLongPress: () {
                                print(comment.commentId);
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user.profilePictureURL),
                                maxRadius: 30,
                              ),
                              title: Text(
                                comment.comment,
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                "@" + user.username,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    DateFormat("dd/MM/yyyy hh:MM")
                                        .format(comment.commentDate),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          actions: comment.authorId !=
                                      authProvider.currentUser.uid ||
                                  widget.ownerId == authProvider.currentUser.uid
                              ? [
                                  IconSlideAction(
                                    caption: 'Bildir',
                                    color: Colors.blue,
                                    icon: FontAwesome5Solid.flag,
                                    onTap: () => _showReportCommentDialog(
                                        comment.commentId, widget.postId),
                                  ),
                                ]
                              : null,
                          secondaryActions: authProvider.currentUser.uid ==
                                      comment.authorId ||
                                  authProvider.currentUser.uid == widget.ownerId
                              ? [
                                  IconSlideAction(
                                    caption: 'Sil',
                                    color: Colors.red,
                                    icon: FontAwesome5Solid.trash,
                                    onTap: () => _showDeleteCommentDialog(
                                        comment.commentId),
                                  )
                                ]
                              : null,
                        );
                      } else {
                        return Center(
                          child: Container(
                            child: spinkit,
                          ),
                        );
                      }
                    },
                    future: userProvider.getUserByID(comment.authorId));
              }),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Yorumlar"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: buildBody(),
            ),
            buildCommentBox()
          ],
        ),
      ),
    );
  }

  Future<void> reportComment(String commentId, String postId) async {
    CommonMethods().showLoaderDialog(context, "İşleminiz gerçekleştiriliyor.");
    await FirebaseReportService()
        .reportComment(authProvider.currentUser.uid, commentId, postId)
        .then((value) {
      CommonMethods().showInfoDialog(context, "İşlem Başarılı", "");
      NavigationService.instance.pop();
      NavigationService.instance.pop();
    }).catchError((value) {
      CommonMethods()
          .showErrorDialog(context, "İşlem gerçekleştirilirken hata oluştu.");
      NavigationService.instance.pop();
    });
  }

  Future<void> deleteComment(String commentId) async {
    await Provider.of<CommentProvider>(context, listen: false)
        .deleteComment(commentId, widget.postId);
  }

  Future<void> _showDeleteCommentDialog(String commentId) async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu yorumu silmek istediğinizden emin misiniz?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "Onay",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await deleteComment(commentId);
          NavigationService.instance.pop();
        });
  }

  Future<void> _showReportCommentDialog(String commentId, String postId) async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu yorumu bildirmek istediğinizden emin misiniz?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await reportComment(commentId, postId);
          NavigationService.instance.pop();
        });
  }

  Widget buildCommentBox() {
    return Container(
      alignment: Alignment(0.0, -1.0),
      height: 70,
      child: Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFieldContainer(
              child: TextFormField(
                focusNode: focusNode,
                controller: commentController,
                maxLines: 3,
                keyboardType: TextInputType.text,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  icon: Icon(
                    FontAwesome5Regular.comment_dots,
                    color: kPrimaryColor,
                  ),
                  hintText: "Harika bir içerik!",
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Bir yorum yazmak istemez miydin?";
                  }
                  return null;
                },
              ),
            ),
            CircleAvatar(
              child: IconButton(
                  icon: Icon(FontAwesome5Regular.paper_plane),
                  onPressed: () {
                    submitComment(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void submitComment(BuildContext context) async {
    // formKey.currentState.saveAndValidate();
    if (_formKey.currentState.validate()) {
      var commentProvider =
          Provider.of<CommentProvider>(context, listen: false);
      var commentModel = CommentModel(
        authorId: authProvider.currentUser.uid,
        commentDate: DateTime.now(),
        comment: commentController.text,
      );

      await commentProvider.saveComment(commentModel, widget.postId);
      FocusScope.of(context).unfocus();
      commentController.text = "";
    }
  }
}
