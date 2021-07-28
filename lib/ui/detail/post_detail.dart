import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/comment_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/request_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/ui/common_widgets/text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostDetail extends StatefulWidget {
  final String postId;

  PostDetail({
    this.postId,
  });

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends BaseState<PostDetail> {
  String videoId;
  PostModel post;
  Future _postFuture;
  UserObject _creator;

  final formKey = GlobalKey<FormBuilderState>();
  final TextEditingController commentController = TextEditingController();

  FocusNode focusNode = new FocusNode();

  bool isCurrentUserPostOwner() {
    return authProvider.currentUser.postIDs.contains(widget.postId);
  }

  Future _obtainPostFuture(BuildContext context) {
    return Provider.of<PostProvider>(context, listen: false)
        .getDetail(widget.postId);
  }

  Future<void> _refreshPost(BuildContext context) async {
    await Provider.of<PostProvider>(context, listen: false)
        .getDetail(widget.postId);
  }

  Future<void> _getCreatorData(BuildContext context, String creatorId) async {
    await Provider.of<UserProvider>(context)
        .getUserByID(creatorId)
        .then((userInfo) {
      _creator = userInfo;
    });
  }

  @override
  void initState() {
    _postFuture = _obtainPostFuture(context);
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        actions: isCurrentUserPostOwner()
            ? [
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                                leading: Icon(FontAwesome5Regular.trash_alt),
                                title: Text("Sil"),
                                onTap: () async {
                                  await _showDeletePostDialog();
                                }),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(FontAwesome5Solid.cogs),
                              title: Text("Düzenle"),
                              onTap: () async {
                                await _showEditPostDialog();
                              },
                            ),
                          ),
                        ])
              ]
            : null,
        centerTitle: true,
        title: Text(
          "İçerik Detay",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshPost(context),
        child: FutureBuilder(
          future: _postFuture,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: spinkit);
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text("Hata oluştu."),
                );
              } else {
                post = snapshot.data;
                _getCreatorData(context, post.ownerId);

                switch (post.postContentType) {
                  case "Video":
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [buildVideoDetail(), buildCommentBox()],
                      ),
                    );
                    break;
                  case "Görüntü":
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [buildImageDetail(), buildCommentBox()],
                    );
                    break;
                  case "Ses":
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [buildRecordDetail(), buildCommentBox()],
                    );
                    break;
                }
              }
            }
          },
        ),
      ),
    );
  }

  Widget buildVideoDetail() {
    return Container(
      child: Column(children: [
        YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: YoutubePlayer.convertUrlToId(
                post.postContentURL), //Add videoID.
            flags: YoutubePlayerFlags(
              hideControls: false,
              controlsVisibleAtStart: true,
              autoPlay: false,
              mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
        ),
        buildPostBodyPart()
      ]),
    );
  }

  Widget buildImageDetail() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(post.postContentURL),
            )),
          ),
          buildPostBodyPart(),
        ],
      ),
    );
  }

  Widget buildRecordDetail() {}

  Widget buildPostBodyPart() {
    return Column(
      children: [
        ListTile(
            leading: InkWell(
              onTap: () {
                navigateToOwnerProfile();
              },
              child: CircleAvatar(
                backgroundImage: _creator != null
                    ? NetworkImage(_creator.profilePictureURL)
                    : null,
              ),
            ),
            title: Center(child: Text(post.postTitle)),
            subtitle: _creator != null
                ? Center(child: Text(_creator.nameSurname))
                : null,
            trailing: post.supportersId.length != null
                ? Text("${post.supportersId.length} Dod")
                : null),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.amberAccent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("İçerik Açıklaması",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20, color: Colors.grey)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    post.postDescription,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
        CommentsPart(post.postId),
      ],
    );
  }

  Widget buildCommentBox() {
    return Container(
        alignment: Alignment(0.0, -1.0),
        height: 70,
        child: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFieldContainer(
                child: FormBuilderTextField(
                  textInputAction: TextInputAction.next,
                  focusNode: focusNode,
                  controller: commentController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: "postDescription",
                  onSubmitted: (_) {
                    commentController.text = "";
                  },
                  maxLines: 3,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.people_alt_sharp,
                        color: kPrimaryColor,
                      ),
                      hintText: "Harika bir içerik!",
                      border: InputBorder.none,
                      errorStyle:
                          Theme.of(context).inputDecorationTheme.errorStyle),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context,
                          errorText: "Bu alan boş bırakılamaz.")
                    ],
                  ),
                ),
              ),
              CircleAvatar(
                  child: IconButton(
                      icon: Icon(FontAwesome5Regular.paper_plane),
                      onPressed: () async {
                        await submitComment(context);
                      }))
            ],
          ),
        ));
  }

  void submitComment(BuildContext context) async {
    var commentProvider = Provider.of<CommentProvider>(context, listen: false);
    CommentModel newComment = new CommentModel();
    newComment.comment = commentController.text;
    newComment.authorId = authProvider.currentUser.uid;
    newComment.commentDate = DateTime.now();

    await commentProvider.saveComment(newComment, widget.postId);
  }

  void navigateToOwnerProfile() {
    if (post.ownerType == "User") {
      if (post.ownerId == authProvider.currentUser.uid) {
        return null;
      } else {
        NavigationService.instance
            .navigate(k_ROUTE_OTHERS_PROFILE_PAGE, args: post.ownerId);
      }
    } else {
      NavigationService.instance
          .navigate(k_ROUTE_GROUP_DETAIL, args: post.ownerId);
    }
  }

  Future<void> _showDeletePostDialog() async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu içeriği silmek istediğinizden emin misiniz?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await _deletePost();
        });
  }

  Future<void> _showEditPostDialog() async {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.info,
      text: "SALİH AĞLAMA GUZUM",
      confirmBtnText: "Evet",
      cancelBtnText: "Vazgeç",
      title: "SALİHA AĞLAMA",
      onCancelBtnTap: () {
        NavigationService.instance.pop();
      },
    );
  }

  Future<void> _deletePost() async {
//TODO: Bunlardan herhangi birisi patlarsa ne yapacağız?

    bool isLocatedInStorage = !post.isLocatedInYoutube;

    //POST ENTRY SİL - STORAGE ELEMANLARINI SİL
    CommonMethods().showLoaderDialog(context, "İşleminiz gerçekleştiriliyor.");

    await Provider.of<PostProvider>(context, listen: false)
        .deletePost(post.postId, isLocatedInStorage);

    //KULLANICININ / GRUBUN POSTIDS den SİL
    if (post.ownerType == "User") {
      await Provider.of<AuthProvider>(context, listen: false)
          .editUserPostDetail(post.postId, post.ownerId, false);
    } else if (post.ownerType == "Group") {
      await Provider.of<GroupProvider>(context, listen: false)
          .editGroupPostList(post.postId, post.ownerId, false);
    }

    //REQUESTİNİ SİL
    await Provider.of<RequestProvider>(context, listen: false)
        .deleteRequest(post.postId);

    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
    //
  }
}

class CommentsPart extends StatefulWidget {
  String postId;
  CommentsPart(this.postId);
  @override
  _CommentsPartState createState() => _CommentsPartState();
}

class _CommentsPartState extends BaseState<CommentsPart> {
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

    if (commentProvider.comments.isEmpty) {
      return Center(child: spinkit);
    } else {
      return Container(
        height: 220,
        child: ListView.builder(
            itemCount: commentProvider.comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(),
                title: Text(commentProvider.comments[index].comment),
                subtitle: Text(commentProvider.comments[index].authorId),
                trailing: Column(
                  children: [
                    Text(DateFormat("dd:MM hh:MM")
                        .format(commentProvider.comments[index].commentDate)),
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
              );
            }),
      );
    }
  }
}
