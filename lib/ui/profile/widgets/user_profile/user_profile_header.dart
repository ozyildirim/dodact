import 'package:cached_network_image/cached_network_image.dart';
import 'package:dodact_v1/common/methods.dart';
import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';

class UserProfileHeader extends StatefulWidget {
  @override
  _UserProfileHeaderState createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends BaseState<UserProfileHeader> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    final mediaQuery = MediaQuery.of(context);

    // return Center(
    //   child: Column(
    //     children: [
    //       Container(
    //         height: mediaQuery.size.height * 0.3,
    //         width: mediaQuery.size.width * 0.8,
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(15),
    //           child: PageView(
    //             onPageChanged: (int index) {
    //               _currentPageNotifier.value = index;
    //             },
    //             scrollDirection: Axis.horizontal,
    //             controller: _controller,
    //             children: [
    //               _picturePage(authProvider.currentUser.profilePictureURL),
    //               Card(
    //                 elevation: 8,
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(15.0),
    //                 ),
    //                 child: Center(
    //                   child: _firstPage(),
    //                 ),
    //               ),
    //               _secondPage(),
    //               Center(
    //                 child: _thirdPage(),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Container(
    //         child: _buildCircleIndicator(),
    //       )
    //     ],
    //   ),
    // );

    return Column(
      children: [
        Center(
          child: CachedNetworkImage(
            imageUrl: authProvider.currentUser.profilePictureURL,
            imageBuilder: (context, imageProvider) {
              return CircleAvatar(
                backgroundColor: Colors.black,
                radius: 100,
                child: CircleAvatar(
                  radius: 95,
                  backgroundImage:
                      NetworkImage(authProvider.currentUser.profilePictureURL),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "@" + authProvider.currentUser.username,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  showProfilePictureContainer(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 350,
          width: 350,
          child: PinchZoom(
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
