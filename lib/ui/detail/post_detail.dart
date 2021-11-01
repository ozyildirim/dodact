import 'package:cool_alert/cool_alert.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_description_card.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_detail_info_part.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_headers/audio_post_header.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_headers/image_post_header.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_headers/video_post_header.dart';
import 'package:dodact_v1/utilities/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class PostDetail extends StatefulWidget {
  final PostModel post;

  PostDetail({this.post});

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends BaseState<PostDetail> {
  String videoId;
  PostModel post;
  PostProvider postProvider;

  bool isFavorite = false;
  bool canUserManagePost = false;

  final formKey = GlobalKey<FormBuilderState>();
  FocusNode focusNode = new FocusNode();

  // ignore: missing_return
  bool canUserManagePostMethod() {
    if (post.ownerType == 'User') {
      if (post.ownerId == userProvider.currentUser.uid) {
        return true;
      }
      return false;
    }
  }

  bool isPostFavorited() {
    if (userProvider.currentUser.favoritedPosts.contains(post.postId)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    post = widget.post;
    postProvider = getProvider<PostProvider>();
    Provider.of<PostProvider>(context, listen: false).setPost(post);
    canUserManagePost = canUserManagePostMethod();

    isFavorite = isPostFavorited();
    Provider.of<PostProvider>(context, listen: false).getDodders(post.postId);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    var appBar = AppBar(
      actions: buildAppbarActions(),
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
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(kBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              HeaderPart(post: post),
              PostDetailInfoPart(post: post),
              SizedBox(height: 10),
              PostDescriptionCard(post: post),
              Expanded(
                child: Container(),
              ),
              buildPostCommentsNavigator(),
            ],
          ),
        ),
      ),
    );
  }

  buildAppbarActions() {
    return canUserManagePost == true
        ? [
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                            leading: Icon(FontAwesome5Regular.trash_alt),
                            title: Text("Sil"),
                            onTap: () async {
                              await showDeletePostDialog();
                            }),
                      ),
                      // PopupMenuItem(
                      //   child: ListTile(
                      //     enabled: false,
                      //     leading: Icon(FontAwesome5Solid.cogs),
                      //     title: Text("Düzenle"),
                      //     onTap: () async {
                      //       await showEditPostDialog();
                      //     },
                      //   ),
                      // ),
                    ])
          ]
        : [
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                            leading: Icon(FontAwesome5Regular.flag),
                            title: Text("Bildir"),
                            onTap: () async {
                              await showReportPostDialog();
                            }),
                      ),
                      isFavorite
                          ? PopupMenuItem(
                              child: ListTile(
                                  leading: Icon(
                                    FontAwesome5Solid.star,
                                    color: Colors.orangeAccent,
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
          ];
  }

  Widget HeaderPart({PostModel post}) {
    switch (post.postContentType) {
      case "Video":
        return VideoPostHeader(post: post);
        break;
      case "Görüntü":
        return ImagePostHeader(post: post);
        break;
      case "Ses":
        return AudioPostHeader(post: post);
        break;
    }
  }

  //Fonksiyonlar

  Future<void> showDeletePostDialog() async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu içeriği silmek istediğinden emin misin?",
        confirmBtnText: "Evet",
        cancelBtnText: "Vazgeç",
        title: "",
        onCancelBtnTap: () {
          NavigationService.instance.pop();
        },
        onConfirmBtnTap: () async {
          await deletePost();
        });
  }

  Future<void> showEditPostDialog() async {
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

  Future<void> showReportPostDialog() async {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        text: "Bu içeriği bildirmek istediğinden emin misin?",
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
      CommonMethods().showLoaderDialog(context, "İşlemin gerçekleştiriliyor.");
      await FirebaseReportService()
          .reportPost(userProvider.currentUser.uid, postId, reportReason)
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

  Future<void> deletePost() async {
    CommonMethods().showLoaderDialog(context, "İşlemin gerçekleştiriliyor.");

    await Provider.of<PostProvider>(context, listen: false)
        .deletePost(post.postId);

    NavigationService.instance.navigateToReset(k_ROUTE_HOME);
    //
  }

  Future<void> addFavorite() async {
    await userProvider.addFavoritePost(post.postId).then((value) {
      setState(() {
        isFavorite = true;
      });
      NavigationService.instance.pop();
    });
  }

  Future<void> removeFavorite() async {
    await userProvider.removeFavoritePost(post.postId).then((value) {
      setState(() {
        isFavorite = false;
      });
      NavigationService.instance.pop();
    });
  }

  //Post onay durumundan önce

  buildPostCommentsNavigator() {
    return ListTile(
      title: Text("Yorumları Görüntüle", style: TextStyle(fontSize: 18)),
      trailing: Icon(Icons.forward),
      onTap: () {
        NavigationService.instance
            .navigate(k_ROUTE_POST_COMMENTS, args: [post.postId, post.ownerId]);
      },
    );
  }
}
