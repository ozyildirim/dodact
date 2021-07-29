import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCommentsPart extends StatefulWidget {
  final String postId;
  final String ownerId;

  PostCommentsPart(this.postId, this.ownerId);
  @override
  _PostCommentsPartState createState() => _PostCommentsPartState();
}

class _PostCommentsPartState extends BaseState<PostCommentsPart> {
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

    if (commentProvider.comments == null) {
      return Container(height: 200, child: Center(child: spinkit));
    } else {
      if (commentProvider.comments.isEmpty) {
        return Container(
          height: 200,
          child: Center(
            child: Text("Henüz yorum yapılmamış."),
          ),
        );
      }
      return Container(
        height: 220,
        child: ListView.builder(
            itemCount: commentProvider.comments.length,
            itemBuilder: (context, index) {
              var comment = commentProvider.comments[index];
              return Dismissible(
                background: comment.authorId != authProvider.currentUser.uid ||
                        widget.ownerId == authProvider.currentUser.uid
                    ? Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(FontAwesome5Regular.flag,
                                  color: Colors.black),
                            ],
                          ),
                        ))
                    : null,
                // Container(
                //     color: Colors.white,
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           Icon(FontAwesome5Solid.trash, color: Colors.red)
                //         ],
                //       ),
                //     ),
                //   ),
                secondaryBackground: authProvider.currentUser.uid ==
                        comment.authorId
                    ? Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(FontAwesome5Solid.trash, color: Colors.red),
                            ],
                          ),
                        ))
                    : null,
                key: Key(comment.toString()),
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.startToEnd) {
                    reportComment(comment.commentId);
                  } else {
                    deleteComment(comment.commentId);
                  }
                },

                // ignore: missing_return
                confirmDismiss: (DismissDirection direction) {
                  if (direction == DismissDirection.startToEnd) {
                    _showReportCommentDialog(comment.commentId);
                  } else {
                    _showDeleteCommentDialog(comment.commentId);
                  }
                },

                child: ListTile(
                  leading: CircleAvatar(),
                  title: Text(comment.comment),
                  subtitle: Text(comment.authorId),
                  trailing: Column(
                    children: [
                      Text(
                        DateFormat("dd:MM hh:MM").format(comment.commentDate),
                      ),
                      // if (commentProvider.comments[index].authorId ==
                      //     authProvider.currentUser.uid)
                      //   PopupMenuButton(iconSize: ,
                      //       itemBuilder: (context) => [
                      //             PopupMenuItem(
                      //                 child: IconButton(
                      //                     icon: Icon(
                      //                       FontAwesome5Regular.trash_alt,
                      //                     ),
                      //                     onPressed: () {}))
                      //           ])
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }

  Future<void> reportComment(String commentId) async {
    await FirebaseReportService()
        .reportComment(authProvider.currentUser.uid, commentId);
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

  Future<void> _showReportCommentDialog(String commentId) async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu içeriği bildirmek istediğinizden emin misiniz?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await reportComment(commentId);
          NavigationService.instance.pop();
        });
  }
}
