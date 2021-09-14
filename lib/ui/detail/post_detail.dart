import 'package:cached_network_image/cached_network_image.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/request_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:dodact_v1/ui/detail/widgets/audio_player/audio_player_widget.dart';
import 'package:dodact_v1/ui/detail/widgets/post_detail_info_part.dart';
import 'package:dodact_v1/utilities/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostDetail extends StatefulWidget {
  final PostModel post;

  PostDetail({this.post});

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends BaseState<PostDetail> {
  String videoId;
  PostModel post;

  bool isFavorite = false;
  bool canUserManagePost = false;

  final formKey = GlobalKey<FormBuilderState>();
  final TextEditingController commentController = TextEditingController();

  FocusNode focusNode = new FocusNode();

  // ignore: missing_return
  bool canUserManagePostMethod() {
    if (post.ownerType == 'User') {
      if (post.ownerId == authProvider.currentUser.uid) {
        return true;
      }
      return false;
    }
  }

  bool isPostFavorited() {
    if (authProvider.currentUser.favoritedPosts.contains(post.postId)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    post = widget.post;
    Provider.of<PostProvider>(context, listen: false).setPost(post);
    canUserManagePost = canUserManagePostMethod();

    isFavorite = authProvider.currentUser.favoritedPosts.contains(post.postId);
  }

  @override
  void dispose() {
    commentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    var mediaQuery = MediaQuery.of(context);

    var appBar = AppBar(
      actions: canUserManagePost == true
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
                            enabled: false,
                            leading: Icon(FontAwesome5Solid.cogs),
                            title: Text("Düzenle"),
                            onTap: () async {
                              await _showEditPostDialog();
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(FontAwesome5Solid.share),
                            title: Text("Paylaş"),
                            onTap: () async {
                              Share.share("asdads");
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
                        isFavorite
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
                        PopupMenuItem(
                          child: ListTile(
                            leading: Icon(FontAwesome5Solid.share),
                            title: Text("Paylaş"),
                            onTap: () async {
                              Share.share(
                                  'check out my website https://example.com');
                            },
                          ),
                        ),
                      ])
            ],
      centerTitle: true,
      title: Text(
        "İçerik Detayı",
        style: TextStyle(color: Colors.black),
      ),
      elevation: 8,
      iconTheme: IconThemeData(color: Colors.black),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          height: dynamicHeight(1) -
              appBar.preferredSize.height -
              mediaQuery.padding.top,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
          ),
          child: pageView(),
        ),
      ),
    );
  }

  pageView() {
    switch (post.postContentType) {
      case "Video":
        return Column(
          children: [
            buildHeaderVideo(),
            PostDetailInfoPart(post: post),
            buildPostDescriptionCard(),
            Expanded(
              child: Container(),
            ),
            buildPostCommentsNavigator(),
          ],
        );
        break;
      case "Görüntü":
        return Column(
          children: [
            buildHeaderImage(),
            PostDetailInfoPart(post: post),
            buildPostDescriptionCard(),
            Expanded(
              child: Container(),
            ),
            buildPostCommentsNavigator(),
          ],
        );
        break;
      case "Ses":
        return Column(
          children: [
            buildHeaderAudio(),
            PostDetailInfoPart(post: post),
            buildPostDescriptionCard(),
            Expanded(
              child: Container(),
            ),
            buildPostCommentsNavigator(),
          ],
        );
        break;
    }
    ;
  }

  Widget buildPostDescriptionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.cyan[200],
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.postTitle,
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                post.postDescription,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
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
          placeholder: (context, url) =>
              Container(child: Center(child: CircularProgressIndicator())),
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
  }

  Widget buildHeaderAudio() {
    return Container(
      height: 250,
      width: double.infinity,
      child: AudioPlayerWidget(
        contentURL: post.postContentURL,
      ),
    );
  }

  //Fonksiyonlar

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
    var reportReason = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => reportReasonDialog(context),
    );

    if (reportReason != null) {
      CommonMethods()
          .showLoaderDialog(context, "İşleminiz gerçekleştiriliyor.");
      await FirebaseReportService()
          .reportPost(authProvider.currentUser.uid, postId, reportReason)
          .then((value) async {
        await CommonMethods().showSuccessDialog(context,
            "Bildirimin bizlere ulaştı. En kısa sürede inceleyeceğiz.");
        NavigationService.instance.pop();
        NavigationService.instance.pop();
      }).catchError((value) async {
        await CommonMethods()
            .showErrorDialog(context, "İşlem gerçekleştirilirken hata oluştu.");
        NavigationService.instance.pop();
      });
    } else {
      NavigationService.instance.pop();
    }
  }

  Future<void> _deletePost() async {
//TODO: Bunlardan herhangi birisi patlarsa ne yapacağız?

    bool isLocatedInStorage = !post.isLocatedInYoutube;

    //POST ENTRY SİL - STORAGE ELEMANLARINI SİL
    CommonMethods().showLoaderDialog(context, "İşleminiz gerçekleştiriliyor.");

    await Provider.of<PostProvider>(context, listen: false)
        .deletePost(post.postId, isLocatedInStorage);

    //REQUESTİNİ SİL
    await Provider.of<RequestProvider>(context, listen: false)
        .deleteRequest(post.postId);

    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
    //
  }

  Future<void> addFavorite() async {
    await authProvider.addFavoritePost(post.postId).then((value) {
      setState(() {
        isFavorite = true;
      });
      NavigationService.instance.pop();
    });
  }

  Future<void> removeFavorite() async {
    await authProvider.removeFavoritePost(post.postId).then((value) {
      setState(() {
        isFavorite = false;
      });
      NavigationService.instance.pop();
    });
  }

  buildPostCommentsNavigator() {
    return Container(
      color: Colors.white70,
      child: ListTile(
        title: Text("Yorumları Görüntüle", style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.forward),
        onTap: () {
          NavigationService.instance.navigate(k_ROUTE_POST_COMMENTS,
              args: [post.postId, post.ownerId]);
        },
      ),
    );
  }
}
