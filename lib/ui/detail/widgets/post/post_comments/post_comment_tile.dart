import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/comment_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCommentTile extends StatefulWidget {
  CommentModel comment;
  String postOwnerId;
  String postId;

  PostCommentTile({this.comment, this.postOwnerId, this.postId});

  @override
  _PostCommentTileState createState() => _PostCommentTileState();
}

class _PostCommentTileState extends BaseState<PostCommentTile> {
  CommentModel comment;
  UserProvider userProvider;
  UserObject authorUser;

  initState() {
    super.initState();
    comment = widget.comment;
    Provider.of<UserProvider>(context, listen: false)
        .getUserByID(comment.authorId)
        .then((value) {
      authorUser = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CommentProvider>(context);
    return Slidable(
      child: Container(
          child: authorUser != null
              ? ListTile(
                  onLongPress: () {
                    print(comment.commentId);
                  },
                  leading: InkWell(
                    onTap: () => navigateAuthorProfile(),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(authorUser.profilePictureURL),
                      maxRadius: 30,
                    ),
                  ),
                  title: Text(
                    comment.comment,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    "@" + authorUser.username,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  trailing: Column(
                    children: [
                      Text(
                        DateFormat("dd.MM.yyyy hh:mm")
                            .format(comment.commentDate),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: spinkit,
                )),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: comment.authorId != authProvider.currentUser.uid ||
              widget.postOwnerId == authProvider.currentUser.uid
          ? [
              IconSlideAction(
                caption: 'Bildir',
                color: Colors.blue,
                icon: FontAwesome5Solid.flag,
                onTap: () =>
                    _showReportCommentDialog(comment.commentId, widget.postId),
              ),
            ]
          : null,
      secondaryActions: authProvider.currentUser.uid == comment.authorId ||
              authProvider.currentUser.uid == widget.postOwnerId
          ? [
              IconSlideAction(
                caption: 'Sil',
                color: Colors.red,
                icon: FontAwesome5Solid.trash,
                onTap: () => _showDeleteCommentDialog(comment.commentId),
              )
            ]
          : null,
    );
  }

  Future<void> _showReportCommentDialog(String commentId, String postId) async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu yorumu bildirmek istediğinden emin misin?",
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
        text: "Bu yorumu silmek istediğinden emin misin?",
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

  navigateAuthorProfile() {
    NavigationService.instance
        .navigate(k_ROUTE_OTHERS_PROFILE_PAGE, args: authorUser);
  }
}
