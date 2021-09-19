import 'package:dodact_v1/config/base/base_state.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/provider/podcast_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/ui/auth/signup/signup_detail/signup_detail.dart';
import 'package:dodact_v1/ui/auth/welcome_page.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends BaseState<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, model, child) {
        if (model.isLoading == false) {
          if (model.currentUser == null) {
            return WelcomePage();
          }
          if (model.currentUser.newUser) {
            return SignUpDetail();
          }
          fetchAppContent();
          return HomePage();
        }
        //If state is "Busy"
        return Scaffold(
          body: Center(
            child: spinkit,
          ),
        );
      },
    );
  }

  bool isNewUser() {
    if (authProvider.currentUser.username == null ||
        authProvider.currentUser.profilePictureURL == null) {
      return true;
    } else {
      return false;
    }
  }

  fetchAppContent() {
    // var userProvider = Provider.of<UserProvider>(context, listen: false);
    var postProvider = Provider.of<PostProvider>(context, listen: false);
    var eventProvider = Provider.of<EventProvider>(context, listen: false);
    var podcastProvider = Provider.of<PodcastProvider>(context, listen: false);

    postProvider.getTopPosts();
    eventProvider.getSpecialEvents();
    postProvider.getUserPosts(authProvider.currentUser);
    eventProvider.getUserEvents(authProvider.currentUser);
    podcastProvider.getPodcastList();
  }
}
