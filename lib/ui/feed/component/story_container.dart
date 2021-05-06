import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/model/user_model.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:flutter/material.dart';

class StoryContainer extends StatefulWidget {
  @override
  _StoryContainerState createState() => _StoryContainerState();
}

class _StoryContainerState extends BaseState<StoryContainer> {
  UserProvider userProvider;
  Topic storyTopic;

  Future<List<UserObject>> allUsers;

  @override
  void initState() {
    super.initState();
    userProvider = getProvider<UserProvider>();

    allUsers = userProvider.getAllUsers(isNotify: false);
  }

  List<StoryContainerItem> storyItems = [
    StoryContainerItem(
        "Müzik",
        "https://digitalage.com.tr/wp-content/uploads/2020/06/Pandemi-doneminde-degisen-muzik-dinleme-egilimleri.jpg",
        Topic.Muzik),
    StoryContainerItem(
        "Resim",
        "https://klasiksanatlar.com/img/sayfalar/b/1_1598452306_resim.png",
        Topic.Resim),
    StoryContainerItem(
        "Tiyatro",
        "https://im.haberturk.com/2020/09/13/ver1599997191/2802222_1920x1080.jpg",
        Topic.Tiyatro),
    StoryContainerItem(
        "Dans",
        "https://img-s2.onedio.com/id-5e0e1424a181be44523430d9/rev-0/w-635/listing/f-jpg-webp/s-0fdfcc94be25ec0766c3b7daf8bfa2a948e9f4b9.webp",
        Topic.Dans)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: new EdgeInsets.only(left: 10),
        height: 120,
        child: Center(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: storyItems.length,
              itemBuilder: (BuildContext context, int index) {
                var storyItem = storyItems[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => NavigationService.instance
                            .navigate('/story_view', args: storyItem.topic),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(storyItem.coverPhoto),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(storyItem.name)
                    ],
                  ),
                );
              }),
        ));
  }
}

/*

FutureBuilder<List<UserObject>>(
        future: allUsers,
        builder: (context, AsyncSnapshot<List<UserObject>> list) {
          if (list.hasData) {
            if (list.data == null || list.data.length == 0) {
              return Center(child: Text("Veri bulunamadı.."));
            } else {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var userItem = list.data[index];
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(userItem.profilePictureURL),
                        ),
                        SizedBox(
                          width: 7.5,
                        )
                      ],
                    );
                  });
            }
          } else {
            return Container();
          }
        },
      )



 */
enum Topic { Resim, Tiyatro, Dans, Muzik }

class StoryContainerItem {
  String name;
  String coverPhoto;
  Topic topic;

  StoryContainerItem(this.name, this.coverPhoto, this.topic);
}
