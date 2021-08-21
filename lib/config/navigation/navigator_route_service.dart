import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/ui/auth/forgot_password.dart';
import 'package:dodact_v1/ui/auth/login_page.dart';
import 'package:dodact_v1/ui/auth/signup/signup_page.dart';
import 'package:dodact_v1/ui/auth/welcome_page.dart';
import 'package:dodact_v1/ui/common/screens/about_dodact_page.dart';
import 'package:dodact_v1/ui/common/screens/privacy_policy_page.dart';
import 'package:dodact_v1/ui/creation/creation_page.dart';
import 'package:dodact_v1/ui/creation/subpages/event_creation_page.dart';
import 'package:dodact_v1/ui/creation/subpages/post_creation_page.dart';
import 'package:dodact_v1/ui/detail/podcast_detail.dart';
import 'package:dodact_v1/ui/detail/post_detail.dart';
import 'package:dodact_v1/ui/detail/widgets/post_detail_comments_part.dart';
import 'package:dodact_v1/ui/discover/discover_page.dart';
import 'package:dodact_v1/ui/event/event_detail.dart';
import 'package:dodact_v1/ui/event/events_page.dart';
import 'package:dodact_v1/ui/group/group_detail.dart';
import 'package:dodact_v1/ui/group/groups_page.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:dodact_v1/ui/interest/temporary_interests_page.dart';
import 'package:dodact_v1/ui/interest/widgets/temporary_registration_interests_page.dart';
import 'package:dodact_v1/ui/landing_page.dart';
import 'package:dodact_v1/ui/onboarding/onboarding_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/calendar_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/favorites_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/requests_status.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/notifications_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/personal_profile_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/privacy_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/profile_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/security_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/social_accounts_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/user_contributions_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/user_options_page.dart';
import 'package:dodact_v1/ui/profile/screens/others_profile_page.dart';
import 'package:dodact_v1/ui/profile/screens/profile_page.dart';
import 'package:dodact_v1/ui/profile/screens/user_notifications_page.dart';
import 'package:dodact_v1/ui/search/search_page.dart';
import 'package:dodact_v1/ui/spinner/spinner_page.dart';
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
      case k_ROUTE_ABOUT_DODACT:
        return _navigateToDefault(AboutDodactPage(), settings);
      case k_ROUTE_LOGIN:
        return _navigateToDefault(LogInPage(), settings);
      case k_ROUTE_REGISTER:
        return _navigateToDefault(SignUpPage(), settings);

      // case k_ROUTE_INTERESTS_CHOICE:
      //   return _navigateToDefault(InterestsPage(), settings);

      case k_ROUTE_TEMPORARY_INTERESTS_CHOICE:
        return _navigateToDefault(TemporaryInterestsPage(), settings);

      case k_ROUTE_TEMPORARY_REGISTRATION_INTERESTS_CHOICE:
        return _navigateToDefault(
            TemporaryRegistrationInterestsPage(), settings);

      case k_ROUTE_HOME:
        return _navigateToDefault(HomePage(), settings);
      case k_ROUTE_CREATION:
        return _navigateToDefault(CreationPage(), settings);

      case k_ROUTE_SEARCH:
        return _navigateToDefault(SearchPage(), settings);

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

      case k_ROUTE_POST_COMMENTS:
        List<dynamic> args = settings.arguments;
        return _navigateToDefault(
            PostCommentsPage(
              postId: args[0],
              ownerId: args[1],
            ),
            settings);

      case k_ROUTE_PODCAST_DETAIL:
        return _navigateToDefault(
            PodcastDetail(
              podcast: args,
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

      case k_ROUTE_GROUPS_PAGE:
        return _navigateToDefault(GroupsPage(), settings);
      case k_ROUTE_GROUP_DETAIL:
        return _navigateToDefault(GroupDetailPage(groupId: args), settings);

      case k_ROUTE_SPINNER_PAGE:
        return _navigateToDefault(SpinnerPage(), settings);

      case k_ROUTE_USER_PROFILE:
        return _navigateToDefault(ProfilePage(), settings);

      case k_ROUTE_OTHERS_PROFILE_PAGE:
        return _navigateToDefault(
            OthersProfilePage(
              otherUserID: args,
            ),
            settings);

      //USER DRAWER PAGES

      case k_ROUTE_USER_OPTIONS:
        return _navigateToDefault(UserOptionsPage(), settings);

      case k_ROUTE_USER_REQUESTS:
        return _navigateToDefault(UserRequestsStatusPage(), settings);

      case k_ROUTE_USER_FAVORITES:
        return _navigateToDefault(FavoritesPage(), settings);

      case k_ROUTE_USER_CALENDAR_PAGE:
        return _navigateToDefault(UserCalendarPage(), settings);

      case k_ROUTE_USER_CONTRIBUTIONS_PAGE:
        return _navigateToDefault(UserContributionsPage(), settings);

      //

      case k_ROUTE_USER_NOTIFICATIONS:
        return _navigateToDefault(UserNotificationsPage(), settings);

      //USER SETTINGS

      case k_ROUTE_USER_NOTIFICATON_SETTINGS:
        return _navigateToDefault(NotificationsSettingsPage(), settings);

      case k_ROUTE_USER_PRIVACY_SETTINGS:
        return _navigateToDefault(PrivacySettingsPage(), settings);

      case k_ROUTE_USER_SECURITY_SETTINGS:
        return _navigateToDefault(SecuritySettingsPage(), settings);

      case k_ROUTE_USER_PROFILE_SETTINGS:
        return _navigateToDefault(ProfileSettingsPage(), settings);

      case k_ROUTE_USER_SOCIAL_ACCOUNTS_SETTINGS:
        return _navigateToDefault(UserSocialAccountsSettings(), settings);

      case k_ROUTE_USER_PERSONAL_PROFILE_SETTINGS:
        return _navigateToDefault(UserPersonalProfileSettingsPage(), settings);

      ///////

      case k_ROUTE_CREATE_POST_PAGE:
        List<dynamic> args = settings.arguments;
        return _navigateToDefault(
            PostCreationPage(
              contentType: args[0],
              postCategory: args[1],
            ),
            settings);

      case k_ROUTE_CREATE_EVENT_PAGE:
        List<dynamic> args = settings.arguments;
        return _navigateToDefault(
            EventCreationPage(
              eventCategory: args[0],
              eventType: args[1],
              eventPlatform: args[2],
            ),
            settings);

      case k_ROUTE_PRIVACY_POLICY:
        return _navigateToDefault(PrivacyPolicyPage(), settings);

      // case k_ROUTE_STORY_VIEW:
      //   List<dynamic> args = settings.arguments;
      //   return _navigateToDefault(
      //       StoryPageView(topic: args[0], stories: args[1]), settings);
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
