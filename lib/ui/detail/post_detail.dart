import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/services/concrete/firebase_report_service.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_description_card.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_detail_info_part.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_headers/audio_post_header.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_headers/image_post_header.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_headers/video_post_header.dart';
import 'package:dodact_v1/utilities/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:getwidget/getwidget.dart';
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
      iconTheme: IconThemeData(color: Colors.white),
      actions: buildAppbarActions(),
      centerTitle: true,
      title: Text(
        "Gönderi Detayı",
      ),
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Scaffold(
            appBar: appBar,
            body: Container(
              height: dynamicHeight(1) -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.dstATop),
                  image: AssetImage(kBackgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  HeaderPart(post: post),
                  PostDetailInfoPart(post: post),
                  SizedBox(height: 5),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14.0, left: 14.0, right: 14),
                    child: Text(post.postTitle,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                  ),
                  PostDescriptionCard(post: post),
                  // Expanded(
                  //   child: Container(),
                  // ),
                  // Spacer(),
                  buildPostCommentsNavigator(),
                ],
              ),
            ),
          );
        } else {
          return VideoPostHeader(post: post);
        }
      },
    );
  }

  buildAppbarActions() {
    return canUserManagePost == true
        ? [
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) async {
                  if (value == 0) {
                    await showDeletePostDialog();
                  } else if (value == 1) {
                    NavigationService.instance
                        .navigate(k_ROUTE_POST_EDIT_PAGE, args: post);
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(FontAwesome5Regular.trash_alt,
                                size: 16, color: Colors.black),
                            SizedBox(width: 14),
                            Text("Sil", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(FontAwesome5Solid.cogs,
                                size: 16, color: Colors.black),
                            SizedBox(width: 14),
                            Text("Düzenle", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ])
          ]
        : [
            PopupMenuButton(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (value) async {
                  if (value == 2) {
                    await showReportPostDialog();
                  } else if (value == 3) {
                    await removeFavorite();
                  } else if (value == 4) {
                    await addFavorite();
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(FontAwesome5Regular.flag,
                                size: 16, color: Colors.black),
                            SizedBox(width: 14),
                            Text("Bildir", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      isFavorite
                          ? PopupMenuItem(
                              value: 3,
                              child: Row(
                                children: [
                                  Icon(FontAwesome5Solid.star,
                                      size: 16, color: Colors.orangeAccent),
                                  SizedBox(width: 14),
                                  Text("Favorilerden Çıkar",
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            )
                          : PopupMenuItem(
                              value: 4,
                              child: Row(
                                children: [
                                  Icon(FontAwesome5Regular.star,
                                      size: 16, color: Colors.black),
                                  SizedBox(width: 14),
                                  Text("Favorilere Ekle",
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
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
    // CoolAlert.show(
    //     context: context,
    //     type: CoolAlertType.confirm,
    //     text: "Bu gönderiyi silmek istediğinden emin misin?",
    //     confirmBtnText: "Evet",
    //     cancelBtnText: "Vazgeç",
    //     title: "",
    //     onCancelBtnTap: () {
    //       NavigationService.instance.pop();
    //     },
    //     onConfirmBtnTap: () async {
    //       await deletePost();
    //     });

    CustomMethods.showCustomDialog(
        context: context,
        confirmButtonText: "Evet",
        confirmActions: () async {
          await deletePost();
        },
        title: "Bu gönderiyi silmek istediğinden emin misin?");
  }

  // Future<void> showEditPostDialog() async {
  //   CoolAlert.show(
  //     context: context,
  //     type: CoolAlertType.info,
  //     text: "SALİH AĞLAMA GUZUM",
  //     confirmBtnText: "Evet",
  //     cancelBtnText: "Vazgeç",
  //     title: "SALİHA AĞLAMA",
  //     onCancelBtnTap: () {
  //       NavigationService.instance.pop();
  //     },
  //   );
  // }

  Future<void> showReportPostDialog() async {
    // CoolAlert.show(
    //     context: context,
    //     type: CoolAlertType.confirm,
    //     text: "Bu gönderiyi bildirmek istediğinden emin misin?",
    //     confirmBtnText: "Evet",
    //     cancelBtnText: "Vazgeç",
    //     title: "",
    //     onCancelBtnTap: () {
    //       NavigationService.instance.pop();
    //     },
    //     onConfirmBtnTap: () async {
    //       await reportPost(post.postId);
    //     });

    CustomMethods.showCustomDialog(
        context: context,
        confirmButtonText: "Evet",
        confirmActions: () async {
          await reportPost(post.postId);
        },
        title: "Bu gönderiyi bildirmek istediğinden emin misin?");
  }

  Future<void> reportPost(String postId) async {
    var result = await FirebaseReportService.checkPostHasSameReporter(
        reportedPostId: postId, reporterId: userProvider.currentUser.uid);

    if (result) {
      CustomMethods.showSnackbar(context, "Bu gönderiyi zaten bildirdin.");
      NavigationService.instance.pop();
    } else {
      var reportReason = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => reportReasonDialog(context),
      );

      if (reportReason != null) {
        NavigationService.instance.pop();
        try {
          await FirebaseReportService()
              .reportPost(userProvider.currentUser.uid, postId, reportReason);

          showSnackbar(
              "Bildirimin bizlere ulaştı. En kısa sürede inceleyeceğiz.");
        } catch (e) {
          showSnackbar("İşlem gerçekleştirilirken hata oluştu.");
        }
      } else {
        NavigationService.instance.pop();
      }
    }
  }

  showSnackbar(String message) {
    GFToast.showToast(
      message,
      context,
      toastPosition: GFToastPosition.BOTTOM,
      toastDuration: 4,
    );
  }

  Future<void> deletePost() async {
    CustomMethods().showLoaderDialog(context, "İşlemin Gerçekleştiriliyor.");
    try {
      await Provider.of<PostProvider>(context, listen: false)
          .deletePost(post.postId);

      NavigationService.instance.navigateToReset(k_ROUTE_HOME);
      CustomMethods.showSnackbar(context, "Gönderi başarıyla silindi.");
    } catch (e) {
      NavigationService.instance.pop();
      CustomMethods.showSnackbar(
          context, "Gönderi silinirken bir hata oluştu.");
      NavigationService.instance.pop();
    }
    //
  }

  Future<void> addFavorite() async {
    await userProvider.addFavoritePost(post.postId).then((value) {
      setState(() {
        isFavorite = true;
      });
    });
  }

  Future<void> removeFavorite() async {
    await userProvider.removeFavoritePost(post.postId).then((value) {
      setState(() {
        isFavorite = false;
      });
    });
  }

  //Post onay durumundan önce

  buildPostCommentsNavigator() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Yorumları Görüntüle",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            trailing: Icon(Icons.forward, color: Colors.black),
            onTap: () {
              NavigationService.instance.navigate(k_ROUTE_POST_COMMENTS,
                  args: [post.postId, post.ownerId]);
            },
          ),
        ),
      ),
    );
  }
}
