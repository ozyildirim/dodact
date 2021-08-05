import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
              return Slidable(
                child: ListTile(
                  onLongPress: () {
                    print(comment.commentId);
                  },
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
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                actions: comment.authorId != authProvider.currentUser.uid ||
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
                secondaryActions:
                    authProvider.currentUser.uid == comment.authorId ||
                            authProvider.currentUser.uid == widget.ownerId
                        ? [
                            IconSlideAction(
                              caption: 'Sil',
                              color: Colors.red,
                              icon: FontAwesome5Solid.trash,
                              onTap: () =>
                                  _showDeleteCommentDialog(comment.commentId),
                            )
                          ]
                        : null,
              );
            }),
      );
    }
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
}
