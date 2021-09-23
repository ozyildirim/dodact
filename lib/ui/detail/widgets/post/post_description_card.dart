import 'package:dodact_v1/model/post_model.dart';
import 'package:flutter/material.dart';

class PostDescriptionCard extends StatelessWidget {
  PostModel post;

  PostDescriptionCard({this.post});

  @override
  Widget build(BuildContext context) {
    // return Card(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //   color: Colors.cyan[200],
    //   child: Container(
    //     width: MediaQuery.of(context).size.width * 0.9,
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             post.postTitle,
    //             style: TextStyle(fontSize: 22),
    //           ),
    //           SizedBox(
    //             height: 16,
    //           ),
    //           Text(
    //             post.postDescription,
    //             // overflow: TextOverflow.ellipsis,
    //             style: TextStyle(fontSize: 16),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(post.postTitle, style: TextStyle(fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(post.postDescription, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
