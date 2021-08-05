import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/comment_model.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/request_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:dodact_v1/ui/common_widgets/text_field_container.dart';
import 'package:dodact_v1/ui/detail/widgets/post_detail_comments_part.dart';
import 'package:dodact_v1/ui/detail/widgets/post_detail_info_part.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
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
  bool isFavorite;

  final formKey = GlobalKey<FormBuilderState>();
  final TextEditingController commentController = TextEditingController();

  FocusNode focusNode = new FocusNode();

  bool isCurrentUserPostOwner() {
    if (authProvider.currentUser.postIDs != null &&
        authProvider.currentUser.postIDs.contains(widget.postId)) {
      return true;
    }
    return false;
  }

  bool isPostFavorited() {
    if (authProvider.currentUser.favoritedPosts.contains(post.postId)) {
      return true;
    }
    return false;
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
    await Provider.of<UserProvider>(context).getOtherUser(creatorId);
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
            : [
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                                leading: Icon(FontAwesome5Regular.flag),
                                title: Text("Bildir"),
                                onTap: () async {
                                  await _showReportPostDialog();
                                }),
                          ),
                          isPostFavorited()
                              ? PopupMenuItem(
                                  child: ListTile(
                                      leading: Icon(
                                        FontAwesome5Solid.star,
                                        color: Colors.yellow,
                                      ),
                                      title: Text("Favorilerden Çıkar"),
                                      onTap: () async {
                                        await removeFavorite();
                                      }),
                                )
                              : PopupMenuItem(
                                  child: ListTile(
                                      leading: Icon(FontAwesome5Regular.star),
                                      title: Text("Favorilere Ekle"),
                                      onTap: () async {
                                        await addFavorite();
                                      }),
                                ),
                        ])
              ],
        centerTitle: true,
        title: Text(
          "İçerik Detay",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 8,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshPost(context),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
          ),
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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildHeaderVideo(),
                          buildPostBodyPart(),
                          buildCommentBox()
                        ],
                      );
                      break;
                    case "Görüntü":
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              buildHeaderImage(),
                              buildPostBodyPart(),
                            ],
                          ),
                          buildCommentBox()
                        ],
                      );
                      break;
                    case "Ses":
                      return Column(
                        children: [
                          buildHeaderAudio(),
                          buildPostBodyPart(),
                          buildCommentBox()
                        ],
                      );
                      break;
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildPostBodyPart() {
    return Column(
      children: [
        PostDetailInfoPart(),
        buildPostDescriptionCard(),
        PostCommentsPart(post.postId, post.ownerId),
      ],
    );
  }

  Widget buildPostDescriptionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.amberAccent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 80,
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
                  focusNode: focusNode,
                  controller: commentController,
                  name: "comment",
                  maxLines: 3,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                      icon: Icon(
                        FontAwesome5Regular.comment_dots,
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

  Widget buildHeaderVideo() {
    return Container(
      child: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId:
              YoutubePlayer.convertUrlToId(post.postContentURL), //Add videoID.
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
    );
  }

  Widget buildHeaderImage() {
    return Container(
      height: 250,
      width: double.infinity,
      child: PinchZoom(
        child: CachedNetworkImage(
          imageUrl: post.postContentURL,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        resetDuration: const Duration(milliseconds: 100),
        maxScale: 2.5,
        onZoomStart: () {
          print('Start zooming');
        },
        onZoomEnd: () {
          print('Stop zooming');
        },
      ),
    );

    /*

return CachedNetworkImage(
      imageUrl: thumbnailURL,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => NavigationService.instance
              .navigate(k_ROUTE_POST_DETAIL, args: post.postId),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
    */
  }

  /*
BoxDecoration(
          image: DecorationImage(
        image: NetworkImage(post.postContentURL),
      )),

  */

  Widget buildHeaderAudio() {
    //TODO: Ses player eklenecek.
  }

  //Fonksiyonlar

  void submitComment(BuildContext context) async {
    formKey.currentState.saveAndValidate();
    var commentProvider = Provider.of<CommentProvider>(context, listen: false);
    CommentModel newComment = new CommentModel();
    newComment.comment = commentController.text;
    newComment.authorId = authProvider.currentUser.uid;
    newComment.commentDate = DateTime.now();

    await commentProvider.saveComment(newComment, widget.postId);

    commentController.text = "";
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

  Future<void> _showReportPostDialog() async {
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
          await reportPost(post.postId);
          NavigationService.instance.pop();
        });
  }

  Future<void> reportPost(String postId) async {
    CommonMethods().showLoaderDialog(context, "İşleminiz gerçekleştiriliyor.");
    await FirebaseReportService()
        .reportPost(authProvider.currentUser.uid, postId)
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
          .editUserPostIDs(post.postId, post.ownerId, false);
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

  Future<void> addFavorite() async {
    await authProvider.addFavoritePost(post.postId);
  }

  Future<void> removeFavorite() async {
    await authProvider.removeFavoritePost(post.postId);
  }
}
