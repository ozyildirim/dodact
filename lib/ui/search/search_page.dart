import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/post_model.dart';
import 'package:dodact_v1/ui/common/widgets/text_field_container.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ara'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(kBackgroundImage), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFieldContainer(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Ara',
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.search)),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                ),
                buildStreamer(context, name),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildStreamer(BuildContext context, String input) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: StreamBuilder<QuerySnapshot>(
        stream: (input != "" && input != null)
            ? FirebaseFirestore.instance
                .collection('posts')
                .where("searchKeywords", arrayContains: name)
                .where('approved', isEqualTo: true)
                .snapshots()
            : FirebaseFirestore.instance
                .collection("posts")
                .where('approved', isEqualTo: true)
                .limit(10)
                .snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: spinkit)
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data.docs[index];
                    PostModel post = PostModel.fromJson(data.data());

                    var thumbnail = CommonMethods.createThumbnailURL(
                        post.isLocatedInYoutube, post.postContentURL);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white70,
                        child: ListTile(
                          onTap: () {
                            NavigationService.instance
                                .navigate(k_ROUTE_POST_DETAIL, args: post);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(thumbnail),
                            radius: 40,
                          ),
                          title: Text(
                            post.postTitle,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(post.postCategory),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
