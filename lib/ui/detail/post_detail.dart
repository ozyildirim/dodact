import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/request_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
                    return Column(
                      children: [
                        buildVideoDetail(),
                      ],
                    );
                    break;
                  case "Görüntü":
                    return Column(
                      children: [
                        buildImageDetail(),
                      ],
                    );
                    break;
                  case "Ses":
                    return buildRecordDetail();
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
          buildPostBodyPart()
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
            title: Text(post.postTitle),
            subtitle: _creator != null ? Text(_creator.nameSurname) : null,
            trailing: post.supportersId.length != null
                ? Text("${post.supportersId.length} Dod")
                : null),
      ],
    );
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
