import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/ui/common/methods/methods.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GroupMediaManagementPage extends StatelessWidget {
  var logger = new Logger();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Topluluk Medya Yönetimi'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage(kBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        width: size.width,
        height: size.height,
        child: GridView.builder(
          itemCount: groupProvider.group.groupMedia.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Center(
                child: InkWell(
                  onTap: () {
                    takePhotoFromGallery(context);
                  },
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width * 0.4,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(height: 15),
                          Text("Yeni Medya Ekle")
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            var media = groupProvider.group.groupMedia[index - 1];
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    CommonMethods.showImagePreviewDialog(context, url: media);
                  },
                  child: Center(
                    child: Card(
                      elevation: 2,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Image.network(
                        media,
                        height: size.height * 0.20,
                        width: size.width * 0.4,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        showRemoveGroupMediaDialog(context, media);
                      },
                      color: Colors.white,
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  showRemoveGroupMediaDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Medya Sil"),
          content: Text("Medya silmek istediğinize emin misiniz?"),
          actions: [
            FlatButton(
              child: Text("Evet"),
              onPressed: () async {
                await removeGroupMedia(context, url);
                //TODO: Check it
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  removeGroupMedia(BuildContext context, String url) async {
    try {
      var groupProvider = Provider.of<GroupProvider>(context, listen: false);
      await groupProvider.removeGroupMedia(url, groupProvider.group.groupId);
      // groupProvider.group.groupMedia.remove(url);
      // await groupProvider.updateGroup(groupProvider.group.groupId, {
      //   'groupMedia': FieldValue.arrayRemove([url]),
      // });
    } catch (e) {
      logger.e(e);
    }
  }

  addGroupMedia(BuildContext context, PickedFile file) async {
    try {
      CommonMethods().showLoaderDialog(context, "Medya Yükleniyor.");
      var groupProvider = Provider.of<GroupProvider>(context, listen: false);
      await groupProvider.addGroupMedia(file, groupProvider.group.groupId);
      NavigationService.instance.pop();
    } catch (e) {
      logger.e(e);
      NavigationService.instance.pop();
    }
  }

  void takePhotoFromGallery(BuildContext context) async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await addGroupMedia(context, image);
    } else {
      print("Kullanıcı fotoğraf seçmekten vazgeçti.");
    }
  }
}
