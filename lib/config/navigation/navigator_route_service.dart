import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/ui/auth/forgot_password.dart';
import 'package:dodact_v1/ui/auth/login_page.dart';
import 'package:dodact_v1/ui/auth/signup/signup_detail/signup_detail_2.dart';
import 'package:dodact_v1/ui/auth/signup/signup_page.dart';
import 'package:dodact_v1/ui/auth/welcome_page.dart';
import 'package:dodact_v1/ui/common_widgets/about_dodact_page.dart';
import 'package:dodact_v1/ui/community/communities_page.dart';
import 'package:dodact_v1/ui/community/community_detail.dart';
import 'package:dodact_v1/ui/creation/creation_page.dart';
import 'package:dodact_v1/ui/creation/subpages/post_creation_page.dart';
import 'package:dodact_v1/ui/detail/post_detail.dart';
import 'package:dodact_v1/ui/discover/discover_page.dart';
import 'package:dodact_v1/ui/discover/widgets/story_components/story_page_view.dart';
import 'package:dodact_v1/ui/event/event_detail.dart';
import 'package:dodact_v1/ui/event/events_page.dart';
import 'package:dodact_v1/ui/group/group_detail.dart';
import 'package:dodact_v1/ui/group/groups_page.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:dodact_v1/ui/interest/insterests_page.dart';
import 'package:dodact_v1/ui/landing_page.dart';
import 'package:dodact_v1/ui/onboarding/onboarding_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/user_options_page.dart';
import 'package:dodact_v1/ui/profile/screens/others_profile_page.dart';
import 'package:dodact_v1/ui/profile/screens/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationRouteManager {
  static Route<dynamic> onRouteGenerate(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case k_ROUTE_ONBOARDING:
        return _navigateToDefault(OnBoardingPage(), settings);
      case k_ROUTE_LANDING:
        return _navigateToDefault(LandingPage(), settings);
      case k_ROUTE_WELCOME:
        return _navigateToDefault(WelcomePage(), settings);
      case k_ROUTE_ABOUT:
        return _navigateToDefault(AboutDodactPage(), settings);
      case k_ROUTE_LOGIN:
        return _navigateToDefault(LogInPage(), settings);
      case k_ROUTE_REGISTER:
        return _navigateToDefault(SignUpPage(), settings);
      case k_ROUTE_REGISTER_DETAIL_2:
        return _navigateToDefault(SignUpDetail_2(), settings);
      case k_ROUTE_INTERESTS_CHOICE:
        return _navigateToDefault(InterestsPage(), settings);
      case k_ROUTE_HOME:
        return _navigateToDefault(HomePage(), settings);
      case k_ROUTE_CREATION:
        return _navigateToDefault(CreationPage(), settings);
      case k_ROUTE_FORGOT_PASSWORD:
        return _navigateToDefault(ForgotPasswordPage(), settings);
      case k_ROUTE_DISCOVER:
        return _navigateToDefault(DiscoverPage(), settings);
      case k_ROUTE_POST_DETAIL:
        return _navigateToDefault(
            PostDetail(
              postId: args,
            ),
            settings);
      case k_ROUTE_EVENTS_PAGE:
        return _navigateToDefault(EventsPage(), settings);
      case k_ROUTE_EVENT_DETAIL:
        return _navigateToDefault(
            EventDetailPage(
              event: args,
            ),
            settings);
      case k_ROUTE_COMMUNITIES_PAGE:
        return _navigateToDefault(CommunitiesPage(), settings);
      case k_ROUTE_COMMUNITY_DETAIL:
        return _navigateToDefault(
            CommunityDetailPage(communityModel: args), settings);
      case k_ROUTE_GROUPS_PAGE:
        return _navigateToDefault(GroupsPage(), settings);
      case k_ROUTE_GROUP_DETAIL:
        return _navigateToDefault(GroupDetailPage(groupModel: args), settings);
      case k_ROUTE_USER_PROFILE:
        return _navigateToDefault(ProfilePage(), settings);
      case k_ROUTE_USER_OPTIONS:
        return _navigateToDefault(UserOptionsPage(), settings);
      case k_ROUTE_OTHERS_PROFILE_PAGE:
        return _navigateToDefault(
            OthersProfilePage(
              otherUserID: args,
            ),
            settings);
      case k_ROUTE_CREATE_POST_PAGE:
        return _navigateToDefault(PostCreationPage(), settings);

      case k_ROUTE_STORY_VIEW:
        List<dynamic> args = settings.arguments;
        return _navigateToDefault(
            StoryPageView(topic: args[0], stories: args[1]), settings);
    }
  }

  NavigationRouteManager._init();

  static _navigateToDefault(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => page, settings: settings);
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error Route'),
        ),
        body: Center(
          child: Text('Route cannot find.'),
        ),
      );
    });
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Unknown Route'),
        ),
        body: Center(
          child: Text('Route unknown.'),
        ),
      );
    });
  }
}
