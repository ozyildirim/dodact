  // GestureDetector yedek() {
  //   return GestureDetector(
  //     onTap: () {
  //       NavigationService.instance.navigate('/post', args: postItem);
  //     },
  //     child: Container(
  //       width: dynamicWidth(1),
  //       child: Column(
  //         children: [
  //           Container(
  //             width: dynamicWidth(1),
  //             height: 200,
  //             decoration: BoxDecoration(
  //                 image: DecorationImage(
  //                     image: NetworkImage(thumbnailURL), fit: BoxFit.cover),
  //                 borderRadius: BorderRadius.only(
  //                     bottomRight: Radius.circular(60),
  //                     topRight: Radius.circular(60))),
  //             child: Center(
  //               child: CircleAvatar(
  //                 child: Icon(
  //                   Icons.play_arrow,
  //                   color: Colors.black,
  //                 ),
  //                 backgroundColor: Colors.white,
  //               ),
  //             ),
  //           ),
  //           Container(
  //             height: 70,
  //             width: dynamicWidth(1),
  //             decoration: BoxDecoration(
  //                 color: Colors.tealAccent,
  //                 borderRadius: BorderRadius.all(Radius.circular(50))),
  //             child: ListTile(
  //               leading: CircleAvatar(
  //                 backgroundImage: NetworkImage(
  //                     'https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/90E78C2B-D798-480E-8534-5A2751ACAB1F.jpg?alt=media&token=e7715a69-e2eb-4d28-be8f-ae724eefe439'),
  //               ),
  //               title: Text(
  //                 postItem.postTitle,
  //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //               ),
  //               subtitle: Text(
  //                 postItem.postDate.day.toString() +
  //                     " " +
  //                     convertMonth(postItem.postDate.month) +
  //                     " " +
  //                     postItem.postDate.year.toString(),
  //                 style: TextStyle(fontSize: 12),
  //               ),
  //               trailing: Icon(Icons.arrow_forward),
  //             ),
  //           )
  //         ],
  //       ),
  //       padding: EdgeInsets.all(10),
  //     ),
  //   );
  // }