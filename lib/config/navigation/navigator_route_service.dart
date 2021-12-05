import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/ui/auth/forgot_password.dart';
import 'package:dodact_v1/ui/auth/login_page.dart';
import 'package:dodact_v1/ui/auth/signup/signup_detail/signup_detail.dart';
import 'package:dodact_v1/ui/auth/signup/signup_page.dart';
import 'package:dodact_v1/ui/auth/welcome_page.dart';
import 'package:dodact_v1/ui/chatrooms/screens/chatroom_page.dart';
import 'package:dodact_v1/ui/chatrooms/screens/create_chat_page.dart';
import 'package:dodact_v1/ui/chatrooms/screens/user_chatrooms_page.dart';
import 'package:dodact_v1/ui/common/screens/about_dodact_page.dart';
import 'package:dodact_v1/ui/common/screens/agreements.dart';
import 'package:dodact_v1/ui/creation/creation_landing_page.dart';
import 'package:dodact_v1/ui/creation/creation_menu_page.dart';
import 'package:dodact_v1/ui/creation/subpages/creator_application_page.dart';
import 'package:dodact_v1/ui/creation/subpages/event_creation_page.dart';
import 'package:dodact_v1/ui/creation/subpages/group_application_page.dart';
import 'package:dodact_v1/ui/creation/subpages/post_creation_page.dart';
import 'package:dodact_v1/ui/creation/subpages/stream_creation_page.dart';
import 'package:dodact_v1/ui/creation/subpages/streamer_application_page.dart';
import 'package:dodact_v1/ui/creation/user_application_page.dart';
import 'package:dodact_v1/ui/detail/podcast_detail.dart';
import 'package:dodact_v1/ui/detail/post_detail.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_comments/post_detail_comments_part.dart';
import 'package:dodact_v1/ui/discover/discover_page.dart';
import 'package:dodact_v1/ui/event/event_detail.dart';
import 'package:dodact_v1/ui/event/events_page.dart';
import 'package:dodact_v1/ui/general/subpages/acik_sahne_page.dart';
import 'package:dodact_v1/ui/general/subpages/spinner_page.dart';
import 'package:dodact_v1/ui/group/screens/group_detail_page.dart';
import 'package:dodact_v1/ui/group/screens/groups_page.dart';
import 'package:dodact_v1/ui/group/subpages/group_add_member_page.dart';
import 'package:dodact_v1/ui/group/subpages/group_event_management_page.dart';
import 'package:dodact_v1/ui/group/subpages/group_interest_managment_page.dart';
import 'package:dodact_v1/ui/group/subpages/group_invitations_page.dart';
import 'package:dodact_v1/ui/group/subpages/group_management_page.dart';
import 'package:dodact_v1/ui/group/subpages/group_media_management_page.dart';
import 'package:dodact_v1/ui/group/subpages/group_member_management_page.dart';
import 'package:dodact_v1/ui/group/subpages/group_post_management_page.dart';
import 'package:dodact_v1/ui/group/subpages/group_profile_management_page.dart';
import 'package:dodact_v1/ui/home_page.dart';
import 'package:dodact_v1/ui/interest/insterests_page.dart';
import 'package:dodact_v1/ui/interest/interest_registration_page.dart';
import 'package:dodact_v1/ui/landing_page.dart';
import 'package:dodact_v1/ui/onboarding/onboarding_page.dart';

import 'package:dodact_v1/ui/profile/screens/drawer_pages/calendar_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/dod_card_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/favorites_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/notifications_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/personal_profile_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/privacy_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/profile_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/security_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/subpages/social_accounts_settings_page.dart';
import 'package:dodact_v1/ui/profile/screens/drawer_pages/user_form_page.dart';

import 'package:dodact_v1/ui/profile/screens/drawer_pages/user_options_page.dart';
import 'package:dodact_v1/ui/profile/screens/notifications/user_invitations_page.dart';
import 'package:dodact_v1/ui/profile/screens/notifications/user_notifications_page.dart';
import 'package:dodact_v1/ui/profile/screens/others_profile_page.dart';
import 'package:dodact_v1/ui/profile/screens/profile_page.dart';
import 'package:dodact_v1/ui/search/search_page.dart';
import 'package:dodact_v1/ui/version_control_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationRouteManager {
  static Route<dynamic> onRouteGenerate(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case k_ROUTE_ONBOARDING:
        return _navigateToDefault(OnBoardingPage(), settings);
      case k_ROUTE_VERSION_CONTROL_PAGE:
        return _navigateToDefault(VersionControlPage(), settings);
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

      case k_ROUTE_REGISTER_DETAIL:
        return _navigateToDefault(SignUpDetail(), settings);

      case k_ROUTE_INTEREST_REGISTRATION:
        return _navigateToDefault(InterestRegistrationPage(), settings);

      case k_ROUTE_INTERESTS_CHOICE:
        return _navigateToDefault(InterestsPage(), settings);

      case k_ROUTE_HOME:
        return _navigateToDefault(HomePage(), settings);

      case k_ROUTE_CREATION_LANDING:
        return _navigateToDefault(CreationLandingPage(), settings);

      //Application Routes

      case k_ROUTE_USER_APPLICATION_MENU:
        return _navigateToDefault(UserApplicationMenuPage(), settings);

      case k_ROUTE_STREAMER_APPLICATION:
        return _navigateToDefault(StreamerApplicationPage(), settings);

      case k_ROUTE_CREATOR_APPLICATION:
        return _navigateToDefault(CreatorApplicationPage(), settings);

      case k_ROUTE_GROUP_APPLICATION:
        return _navigateToDefault(GroupApplicationPage(), settings);

      //Creation Routes
      case k_ROUTE_CREATION_MENU:
        return _navigateToDefault(CreationMenuPage(groupId: args), settings);

      case k_ROUTE_CREATE_POST_PAGE:
        List<dynamic> args = settings.arguments;
        return _navigateToDefault(
            PostCreationPage(
                postType: args[0], postCategory: args[1], groupId: args[2]),
            settings);

      case k_ROUTE_CREATE_EVENT_PAGE:
        List<dynamic> args = settings.arguments;
        return _navigateToDefault(
            EventCreationPage(
                eventCategory: args[0],
                eventType: args[1],
                eventPlatform: args[2]),
            settings);

      case k_ROUTE_CREATE_USER_STREAM_PAGE:
        return _navigateToDefault(StreamCreationPage(), settings);

      //////

      case k_ROUTE_SEARCH:
        return _navigateToDefault(SearchPage(), settings);

      case k_ROUTE_FORGOT_PASSWORD:
        return _navigateToDefault(ForgotPasswordPage(), settings);
      case k_ROUTE_DISCOVER:
        return _navigateToDefault(DiscoverPage(), settings);
      case k_ROUTE_POST_DETAIL:
        return _navigateToDefault(
            PostDetail(
              post: args,
            ),
            settings);

      case k_ROUTE_POST_COMMENTS:
        List<dynamic> args = settings.arguments;
        return _navigateToDefault(
            PostCommentsPage(
              postId: args[0],
              postOwnerId: args[1],
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
        return _navigateToDefault(GroupDetailPage(group: args), settings);

      case k_ROUTE_SPINNER_PAGE:
        return _navigateToDefault(SpinnerPage(), settings);

      case k_ROUTE_ACIK_SAHNE_PAGE:
        return _navigateToDefault(AcikSahnePage(), settings);

      case k_ROUTE_USER_PROFILE:
        return _navigateToDefault(ProfilePage(), settings);

      case k_ROUTE_OTHERS_PROFILE_PAGE:
        return _navigateToDefault(
            OthersProfilePage(
              otherUser: args,
            ),
            settings);

      //USER DRAWER PAGES

      case k_ROUTE_USER_OPTIONS:
        return _navigateToDefault(UserOptionsPage(), settings);

      case k_ROUTE_USER_FAVORITES:
        return _navigateToDefault(FavoritesPage(), settings);

      case k_ROUTE_USER_CALENDAR_PAGE:
        return _navigateToDefault(UserCalendarPage(), settings);

      case k_ROUTE_DOD_CARD:
        return _navigateToDefault(DodCardPage(), settings);

      case k_ROUTE_USER_FORM_PAGE:
        return _navigateToDefault(UserFormPage(), settings);

      //

      case k_ROUTE_USER_NOTIFICATIONS:
        return _navigateToDefault(UserNotificationsPage(), settings);

      case k_ROUTE_USER_CHATROOMS:
        return _navigateToDefault(UserChatroomsPage(), settings);

      case k_ROUTE_CHATROOM_PAGE:
        List<dynamic> args = settings.arguments;
        return _navigateToDefault(
            ChatroomPage(currentUserId: args[0], otherUserObject: args[1]),
            settings);

      case k_ROUTE_CREATE_CHAT_PAGE:
        return _navigateToDefault(CreateChatPage(), settings);

      case k_ROUTE_USER_INVITATIONS_PAGE:
        return _navigateToDefault(UserInvitationsPage(), settings);

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

      //GROUP SETTINGS
      case k_ROUTE_GROUP_MANAGEMENT_PAGE:
        return _navigateToDefault(GroupManagementPage(), settings);

      case k_ROUTE_GROUP_PROFILE_MANAGEMENT_PAGE:
        return _navigateToDefault(GroupProfileManagementPage(), settings);

      case k_ROUTE_GROUP_MEMBER_MANAGEMENT_PAGE:
        return _navigateToDefault(GroupMemberManagementPage(), settings);

      case k_ROUTE_GROUP_INVITATIONS_PAGE:
        return _navigateToDefault(GroupMemberInvitationsPage(), settings);

      case k_ROUTE_GROUP_ADD_MEMBER_PAGE:
        return _navigateToDefault(GroupAddMemberPage(), settings);

      case k_ROUTE_GROUP_EVENT_MANAGEMENT_PAGE:
        return _navigateToDefault(GroupEventManagementPage(), settings);

      case k_ROUTE_GROUP_POST_MANAGEMENT_PAGE:
        return _navigateToDefault(GroupPostManagementPage(), settings);

      case k_ROUTE_GROUP_INTEREST_MANAGEMENT_PAGE:
        return _navigateToDefault(GroupInterestManagementPage(), settings);

      case k_ROUTE_GROUP_MEDIA_MANAGEMENT_PAGE:
        return _navigateToDefault(GroupMediaManagementPage(), settings);

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
