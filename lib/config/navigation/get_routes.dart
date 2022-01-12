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
import 'package:dodact_v1/ui/creation/subpages/application_history_page.dart';
import 'package:dodact_v1/ui/creation/subpages/content_creator_application_page.dart';
import 'package:dodact_v1/ui/creation/subpages/event_creation_page.dart';
import 'package:dodact_v1/ui/creation/subpages/event_creator_application_page.dart';
import 'package:dodact_v1/ui/creation/subpages/group_application_page.dart';
import 'package:dodact_v1/ui/creation/subpages/post_creation_page.dart';
import 'package:dodact_v1/ui/creation/subpages/stream_creation_page.dart';
import 'package:dodact_v1/ui/creation/subpages/streamer_application_page.dart';
import 'package:dodact_v1/ui/creation/user_application_page.dart';
import 'package:dodact_v1/ui/detail/podcast_detail.dart';
import 'package:dodact_v1/ui/detail/post_detail.dart';
import 'package:dodact_v1/ui/detail/post_edit_page.dart';
import 'package:dodact_v1/ui/detail/widgets/post/post_comments/post_comments_part.dart';
import 'package:dodact_v1/ui/discover/discover_page.dart';
import 'package:dodact_v1/ui/event/event_detail.dart';
import 'package:dodact_v1/ui/event/event_edit_page.dart';
import 'package:dodact_v1/ui/event/events_page.dart';
import 'package:dodact_v1/ui/general/subpages/acik_sahne_page.dart';
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
import 'package:get/route_manager.dart';

var getPages = [
  GetPage(
    name: k_ROUTE_ONBOARDING,
    page: () => OnBoardingPage(),
  ),
  GetPage(
    name: k_ROUTE_VERSION_CONTROL_PAGE,
    page: () => VersionControlPage(),
  ),
  GetPage(
    name: k_ROUTE_LANDING,
    page: () => LandingPage(),
  ),
  GetPage(
    name: k_ROUTE_WELCOME,
    page: () => WelcomePage(),
  ),
  GetPage(
    name: k_ROUTE_ABOUT_DODACT,
    page: () => AboutDodactPage(),
  ),
  GetPage(
    name: k_ROUTE_LOGIN,
    page: () => LogInPage(),
  ),
  GetPage(
    name: k_ROUTE_REGISTER,
    page: () => SignUpPage(),
  ),
  GetPage(
    name: k_ROUTE_REGISTER_DETAIL,
    page: () => SignUpDetail(),
  ),
  GetPage(
    name: k_ROUTE_INTEREST_REGISTRATION,
    page: () => InterestRegistrationPage(),
  ),
  GetPage(
    name: k_ROUTE_INTERESTS_CHOICE,
    page: () => InterestsPage(),
  ),
  GetPage(
    name: k_ROUTE_HOME,
    page: () => HomePage(),
  ),
  GetPage(
    name: k_ROUTE_CREATION_MENU,
    page: () => CreationLandingPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_APPLICATION_MENU,
    page: () => UserApplicationMenuPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_APPLICATION_HISTORY,
    page: () => UserApplicationHistoryPage(),
  ),
  GetPage(
    name: k_ROUTE_STREAMER_APPLICATION,
    page: () => StreamerApplicationPage(),
  ),
  GetPage(
    name: k_ROUTE_CONTENT_CREATOR_APPLICATION,
    page: () => ContentCreatorApplicationPage(),
  ),
  GetPage(
    name: k_ROUTE_EVENT_CREATOR_APPLICATION,
    page: () => EventCreatorApplicationPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_APPLICATION,
    page: () => GroupApplicationPage(),
  ),
  GetPage(
    name: k_ROUTE_CREATION_MENU,
    page: () => CreationMenuPage(),
  ),
  GetPage(
    name: k_ROUTE_CREATE_POST_PAGE,
    page: () => PostCreationPage(),
  ),
  GetPage(
    name: k_ROUTE_CREATE_EVENT_PAGE,
    page: () => EventCreationPage(),
  ),
  GetPage(
    name: k_ROUTE_CREATE_USER_STREAM_PAGE,
    page: () => StreamCreationPage(),
  ),
  GetPage(
    name: k_ROUTE_SEARCH,
    page: () => SearchPage(),
  ),
  GetPage(
    name: k_ROUTE_FORGOT_PASSWORD,
    page: () => ForgotPasswordPage(),
  ),
  GetPage(
    name: k_ROUTE_DISCOVER,
    page: () => DiscoverPage(),
  ),
  GetPage(
    name: k_ROUTE_POST_DETAIL,
    page: () => PostDetail(),
  ),
  GetPage(
    name: k_ROUTE_POST_EDIT_PAGE,
    page: () => PostEditPage(),
  ),
  GetPage(
    name: k_ROUTE_POST_COMMENTS,
    page: () => PostCommentsPage(),
  ),
  GetPage(
    name: k_ROUTE_PODCAST_DETAIL,
    page: () => PodcastDetail(),
  ),
  GetPage(
    name: k_ROUTE_EVENTS_PAGE,
    page: () => EventsPage(),
  ),
  GetPage(
    name: k_ROUTE_EVENT_DETAIL,
    page: () => EventDetailPage(),
  ),
  GetPage(
    name: k_ROUTE_EVENT_EDIT_PAGE,
    page: () => EventEditPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUPS_PAGE,
    page: () => GroupsPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_DETAIL,
    page: () => GroupDetailPage(),
  ),
  GetPage(
    name: k_ROUTE_ACIK_SAHNE_PAGE,
    page: () => AcikSahnePage(),
  ),
  GetPage(
    name: k_ROUTE_USER_PROFILE,
    page: () => ProfilePage(),
  ),
  GetPage(
    name: k_ROUTE_OTHERS_PROFILE_PAGE,
    page: () => OthersProfilePage(),
  ),
  GetPage(
    name: k_ROUTE_USER_OPTIONS,
    page: () => UserOptionsPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_FAVORITES,
    page: () => FavoritesPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_CALENDAR_PAGE,
    page: () => UserCalendarPage(),
  ),
  GetPage(
    name: k_ROUTE_DOD_CARD,
    page: () => DodCardPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_FORM_PAGE,
    page: () => UserFormPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_NOTIFICATIONS,
    page: () => UserNotificationsPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_CHATROOMS,
    page: () => UserChatroomsPage(),
  ),
  GetPage(
    name: k_ROUTE_CHATROOM_PAGE,
    page: () => ChatroomPage(),
  ),
  GetPage(
    name: k_ROUTE_CREATE_CHAT_PAGE,
    page: () => CreateChatPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_INVITATIONS_PAGE,
    page: () => UserInvitationsPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_NOTIFICATON_SETTINGS,
    page: () => NotificationsSettingsPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_PRIVACY_SETTINGS,
    page: () => PrivacySettingsPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_SECURITY_SETTINGS,
    page: () => SecuritySettingsPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_PROFILE_SETTINGS,
    page: () => ProfileSettingsPage(),
  ),
  GetPage(
    name: k_ROUTE_USER_SOCIAL_ACCOUNTS_SETTINGS,
    page: () => UserSocialAccountsSettings(),
  ),
  GetPage(
    name: k_ROUTE_USER_PERSONAL_PROFILE_SETTINGS,
    page: () => UserPersonalProfileSettingsPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_MANAGEMENT_PAGE,
    page: () => GroupManagementPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_PROFILE_MANAGEMENT_PAGE,
    page: () => GroupProfileManagementPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_MEMBER_MANAGEMENT_PAGE,
    page: () => GroupMemberManagementPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_INVITATIONS_PAGE,
    page: () => GroupMemberInvitationsPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_ADD_MEMBER_PAGE,
    page: () => GroupAddMemberPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_EVENT_MANAGEMENT_PAGE,
    page: () => GroupEventManagementPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_POST_MANAGEMENT_PAGE,
    page: () => GroupPostManagementPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_INTEREST_MANAGEMENT_PAGE,
    page: () => GroupInterestManagementPage(),
  ),
  GetPage(
    name: k_ROUTE_GROUP_MEDIA_MANAGEMENT_PAGE,
    page: () => GroupMediaManagementPage(),
  ),
  GetPage(
    name: k_ROUTE_PRIVACY_POLICY,
    page: () => PrivacyPolicyPage(),
  ),
];
