import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/comment_model.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_comments/post_comment_tile.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class PostCommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;

  PostCommentsPage({this.postId, this.postOwnerId});
  @override
  _PostCommentsPageState createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends BaseState<PostCommentsPage> {
  GlobalKey<FormBuilderState> _formKey = new GlobalKey<FormBuilderState>();
  final TextEditingController commentController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  PaginateRefreshedChangeListener refreshChangeListener;

  @override
  void initState() {
    super.initState();
    refreshChangeListener = PaginateRefreshedChangeListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Yorumlar"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          color: kNavbarColor,
          onRefresh: () async => refreshComments(),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.25), BlendMode.dstATop),
                image: AssetImage(kBackgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: buildBody(),
                ),
                FormBuilder(key: _formKey, child: buildCommentBox())
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildBody() {
    return PaginateFirestore(
      listeners: [refreshChangeListener],
      query: postsRef
          .doc(widget.postId)
          .collection("comments")
          .orderBy('commentDate', descending: false),
      itemBuilderType: PaginateBuilderType.listView,
      itemsPerPage: 10,
      isLive: false,
      onEmpty: Center(
        child: Text(
          "Bu gönderi için henüz yorum yapılmamış",
          style: TextStyle(fontSize: kPageCenteredTextSize),
        ),
      ),
      itemBuilder:
          (BuildContext context, List<DocumentSnapshot> document, int index) {
        CommentModel comment = CommentModel.fromJson(document[index].data());
        return Slidable(
          child: PostCommentTile(
            postId: widget.postId,
            comment: comment,
            postOwnerId: widget.postOwnerId,
          ),
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          actions: comment.authorId != authProvider.currentUser.uid ||
                  widget.postOwnerId == authProvider.currentUser.uid
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
      },
    );
  }

  Widget buildCommentBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextFieldContainer(
          child: FormBuilderTextField(
            name: "comment",
            focusNode: focusNode,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
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
            },
          ),
        ),
        CircleAvatar(
          radius: 18,
          backgroundColor: kNavbarColor,
          child: IconButton(
              icon: Icon(
                FontAwesome5Solid.paper_plane,
                size: 16,
                color: Colors.white,
              ),
              onPressed: () {
                submitComment(context);
              }),
        ),
      ],
    );
  }

  void submitComment(BuildContext context) async {
    if (_formKey.currentState.saveAndValidate()) {
      var comment = _formKey.currentState.value['comment'];
      print(comment);
      bool profanityResult = ProfanityChecker.hasProfanity(comment);

      if (profanityResult) {
        CustomMethods.showSnackbar(context, "Argo içerikli giriş yapıldı");
        FocusScope.of(context).unfocus();
      } else {
        var commentProvider =
            Provider.of<CommentProvider>(context, listen: false);

        FocusScope.of(context).unfocus();
        _formKey.currentState.reset();

        await commentProvider.saveComment(
            CommentModel(
              authorId: authProvider.currentUser.uid,
              commentDate: DateTime.now(),
              comment: comment,
            ),
            widget.postId);
      }
    }
  }

  Future refreshComments() async {
    refreshChangeListener.refreshed = true;
  }

  Future<void> _showReportCommentDialog(String commentId, String postId) async {
    // CoolAlert.show(
    //     context: context,
    //     type: CoolAlertType.confirm,
    //     text: "Bu yorumu bildirmek istediğinden emin misin?",
    //     confirmBtnText: "Evet",
    //     cancelBtnText: "Vazgeç",
    //     title: "",
    //     onCancelBtnTap: () {
    //       NavigationService.instance.pop();
    //     },
    //     onConfirmBtnTap: () async {
    //       await reportComment(commentId, postId);
    //       NavigationService.instance.pop();
    //     });

    CustomMethods.showCustomDialog(
        context: context,
        confirmActions: () async {
          await reportComment(commentId, postId);
          Get.back();
        },
        title: "Bu yorumu bildirmek istediğinden emin misin?",
        confirmButtonText: "Evet");
  }

  Future<void> reportComment(String commentId, String postId) async {
    var result = await FirebaseReportService.checkCommentHasSameReporter(
        reportedCommentId: commentId, reporterId: userProvider.currentUser.uid);

    if (result) {
      CustomMethods.showSnackbar(context, "Bu yorumu daha önce bildirdin.");
    } else {
      try {
        await FirebaseReportService.reportComment(
            authProvider.currentUser.uid, commentId, postId);
        CustomMethods.showSnackbar(context, "Yorum başarıyla bildirildi.");
      } catch (e) {
        CustomMethods.showSnackbar(context, "Yorum bildirilirken hata oluştu.");
      }
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await Provider.of<CommentProvider>(context, listen: false)
          .deleteComment(commentId, widget.postId);

      CustomMethods.showSnackbar(context, "Yorum silindi.");
    } catch (e) {
      CustomMethods.showSnackbar(context, "Yorum silinirken hata oluştu.");
    }
  }

  Future<void> _showDeleteCommentDialog(String commentId) async {
    // CoolAlert.show(
    //     context: context,
    //     type: CoolAlertType.confirm,
    //     text: "Bu yorumu silmek istediğinden emin misin?",
    //     confirmBtnText: "Evet",
    //     cancelBtnText: "Vazgeç",
    //     title: "Onay",
    //     onCancelBtnTap: () {
    //       NavigationService.instance.pop();
    //     },
    //     onConfirmBtnTap: () async {
    //       await deleteComment(commentId);
    //       NavigationService.instance.pop();
    //     });

    CustomMethods.showCustomDialog(
        context: context,
        confirmActions: () async {
          await deleteComment(commentId);
          Get.back();
        },
        title: "Bu yorumu silmek istediğinden emin misin?",
        confirmButtonText: "Evet");
  }
}
