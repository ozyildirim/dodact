import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum PostStatus { waiting, approved, rejected }

class UserRequestsStatusPage extends StatefulWidget {
  @override
  _UserRequestsStatusPageState createState() => _UserRequestsStatusPageState();
}

class _UserRequestsStatusPageState extends BaseState<UserRequestsStatusPage> {
  PostProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<PostProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "İsteklerim",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("İçerik İsteklerim", style: TextStyle(fontSize: 24)),
            Divider(),
            Container(
              height: 400,
              child: _userPostRequestsPart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userPostRequestsPart() {
    List<PostModel> userPosts = provider.userPosts;
    PostStatus postStatus;

    // ignore: missing_return
    return ListView.builder(
        itemCount: userPosts.length,
        // ignore: missing_return
        itemBuilder: (context, index) {
          PostModel post = userPosts[index];

          if (post.isExamined == false) {
            postStatus = PostStatus.waiting;
          } else if (post.isExamined == true && post.approved == true) {
            postStatus = PostStatus.approved;
          } else if (post.isExamined == true && post.approved == false) {
            postStatus = PostStatus.rejected;
          }

          switch (postStatus) {
            case PostStatus.waiting:
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    FontAwesome5Solid.hourglass_start,
                    color: Colors.grey,
                  ),
                ),
                title: Text(post.postTitle),
                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                    .format(post.postDate)
                    .toString()),
              );

            case PostStatus.approved:
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    FontAwesome5Solid.check,
                    color: Colors.green,
                  ),
                ),
                title: Text(post.postTitle),
                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                    .format(post.postDate)
                    .toString()),
              );

            case PostStatus.rejected:
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    FontAwesome5Solid.times,
                    color: Colors.red,
                  ),
                ),
                title: Text(post.postTitle),
                subtitle: Text(DateFormat("dd-MM-yyyy hh-mm")
                    .format(post.postDate)
                    .toString()),
                trailing: IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      CommonMethods().showInfoDialog(
                          context,
                          "İçeriğiniz reddedilmiştir.\nSebebi: ${post.rejectionMessage}",
                          "Bilgilendirme");
                    }),
              );
          }
        });
  }
}
