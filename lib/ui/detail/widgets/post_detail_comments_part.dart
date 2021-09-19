import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/model/comment_model.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:dodact_v1/ui/detail/widgets/post_comment_tile.dart';
import 'package:dodact_v1/utilities/profanity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
              child: Container(
                color: Colors.white70,
                child: Text(
                  "Henüz yorum yapılmamış.",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          );
        }
        commentProvider.comments
            .sort((a, b) => a.commentDate.compareTo(b.commentDate));
        return Container(
          height: 220,
          child: ListView.builder(
            itemCount: commentProvider.comments.length,
            itemBuilder: (context, index) {
              var comment = commentProvider.comments[index];
              return PostCommentTile(
                postId: widget.postId,
                comment: comment,
                postOwnerId: widget.postOwnerId,
              );
            },
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Yorumlar"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: () async => refreshComments(),
          child: Container(
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
        ),
      ),
    );
  }

  Widget buildCommentBox() {
    return Container(
      alignment: Alignment(0.0, -1.0),
      height: 70,
      //TODO: Form builder ekle
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

        await commentProvider.saveComment(commentModel, widget.postId);
        setState(() {});
        FocusScope.of(context).unfocus();
        commentController.text = "";
      }
    }
  }

  Future refreshComments() async {
    var commentProvider = Provider.of<CommentProvider>(context, listen: false);
    await commentProvider.getPostComments(widget.postId);
  }
}
