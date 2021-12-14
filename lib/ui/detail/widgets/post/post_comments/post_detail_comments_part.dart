import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/config/constants/firebase_constants.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/comment_model.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_comments/post_comment_tile.dart';
import 'package:dodact_v1/ui/common/validators/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildBody() {
      return PaginateFirestore(
        query: postsRef
            .doc(widget.postId)
            .collection("comments")
            .orderBy('commentDate', descending: false),
        itemBuilderType: PaginateBuilderType.listView,
        itemsPerPage: 10,
        isLive: true,
        onEmpty: Center(
            child: Text("Bu gönderi için henüz yorum yapılmamış.",
                style: TextStyle(fontSize: kPageCenteredTextSize))),
        itemBuilder:
            (BuildContext context, List<DocumentSnapshot> document, int index) {
          CommentModel comment = CommentModel.fromJson(document[index].data());
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PostCommentTile(
              postId: widget.postId,
              comment: comment,
              postOwnerId: widget.postOwnerId,
            ),
          );
        },
      );
    }

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
                buildCommentBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCommentBox() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //TODO: Form builder ekle
          TextFieldContainer(
            child: TextFormField(
              focusNode: focusNode,
              controller: commentController,
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
                return null;
              },
            ),
          ),
          CircleAvatar(
            backgroundColor: kNavbarColor,
            child: IconButton(
                icon: Icon(
                  FontAwesome5Solid.paper_plane,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: () {
                  submitComment(context);
                }),
          ),
        ],
      ),
    );
  }

  void submitComment(BuildContext context) async {
    // formKey.currentState.saveAndValidate();
    if (_formKey.currentState.validate()) {
      bool profanityResult =
          ProfanityChecker.hasProfanity(commentController.text);

      if (profanityResult) {
        CommonMethods()
            .showErrorDialog(context, "Küfür içeren bir yorum yapamazsın!");
        FocusScope.of(context).unfocus();

        commentController.clear();
      } else {
        var commentProvider =
            Provider.of<CommentProvider>(context, listen: false);
        var commentModel = CommentModel(
          authorId: authProvider.currentUser.uid,
          commentDate: DateTime.now(),
          comment: commentController.text,
        );

        FocusScope.of(context).unfocus();
        commentController.text = "";

        await commentProvider.saveComment(commentModel, widget.postId);
      }
    }
  }

  Future refreshComments() async {
    var commentProvider = Provider.of<CommentProvider>(context, listen: false);
    await commentProvider.getPostComments(widget.postId);
  }
}
