import 'package:dodact_v1/model/post_model.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class PostDescriptionCard extends StatelessWidget {
  PostModel post;

  PostDescriptionCard({this.post});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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

    return Expanded(
      flex: 5,
      // fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: Container(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReadMoreText(
                post.postDescription,
                style: TextStyle(color: Colors.black, fontSize: 14),
                trimLines: 4,
                colorClickableText: Colors.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Daha fazla detay',
                trimExpandedText: 'Küçült',
                lessStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                moreStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
        ),
      ),
    );
  }
}
