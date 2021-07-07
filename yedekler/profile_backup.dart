/*
  Consumer<PostProvider> postsPart() {
    return Consumer<PostProvider>(
      builder: (_, provider, child) {
        if (provider.usersPosts != null) {
          if (provider.usersPosts.isNotEmpty) {
            print(provider.usersPosts.length);
            return Container(
              color: kBackgroundColor,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: provider.usersPosts.length,
                itemBuilder: (context, index) {
                  var postItem = provider.usersPosts[index];
                  var thumbnailURL =
                      createThumbnailURL(postItem.postContentURL);
                  return GestureDetector(
                    onTap: () {
                      NavigationService.instance
                          .navigate('/post', args: postItem);
                    },
                    child: Container(
                      width: dynamicWidth(1),
                      child: Column(
                        children: [
                          Container(
                            width: dynamicWidth(1),
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(thumbnailURL),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(60),
                                    topRight: Radius.circular(60))),
                            child: Center(
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: 70,
                            width: dynamicWidth(1),
                            decoration: BoxDecoration(
                                color: Colors.pinkAccent,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50))),
                            child: ListTile(
                              title: Text(
                                postItem.postTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Text(
                                postItem.postDate.day.toString() +
                                    " " +
                                    convertMonth(postItem.postDate.month) +
                                    " " +
                                    postItem.postDate.year.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  );
                },
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: spinkit,
              ),
            );
          }
        } else {
          return Center(
            child: spinkit,
          );
        }
      },
    );
  }

  Container informationPart() {
    return Container(
      width: dynamicWidth(1),
      height: 110,
      decoration: BoxDecoration(
          boxShadow: [
            // BoxShadow(
            //   color: Colors.grey,
            //   blurRadius: 10.0,
            //   spreadRadius: 3.0,
            //   offset: Offset(10.0, 10.0),
            // ),
          ],
          color: kBackgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(100),
          )),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                authProvider.currentUser.nameSurname,
                style: TextStyle(
                    fontFamily: kFontFamily,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "@" + authProvider.currentUser.username,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: kFontFamily,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [],
            )
          ],
        ),
      ),
    );
  }

  Rozet kısmı
  Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Kazandığı Rozetler",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                          width: dynamicWidth(0.90),
                        ),
                      ),
                      Container(
                        height: 150.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar2.jpg?alt=media&token=68b5edcd-30e5-436e-84a3-990156fcfae5"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/dodact-7ccd3.appspot.com/o/rozetler%2Fguitar.jpeg?alt=media&token=a9eef8bb-42f2-408b-835c-3534cf757d15"),
                              ),
                            ),
                          ],
                        ),
                      ),

 */