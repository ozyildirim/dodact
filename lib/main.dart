import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dodact_v1/config/constants/providers_list.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/config/navigation/navigator_route_service.dart';
import 'package:dodact_v1/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;

Future<void> _messageHandler(RemoteMessage message) async {
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  initScreen = _prefs.getInt("initScreen");
  await _prefs.setInt('initScreen', 1);
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  AwesomeNotifications().initialize(
      'resource://drawable/notification_logo',
      [
        NotificationChannel(
            defaultRingtoneType: DefaultRingtoneType.Notification,
            icon: 'resource://drawable/notification_logo',
            groupAlertBehavior: GroupAlertBehavior.Summary,
            locked: true,
            enableLights: true,
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
        // NotificationChannel(
        //     channelKey: 'badge_channel',
        //     channelName: 'Badge indicator notifications',
        //     channelDescription:
        //         'Notification channel to activate badge indicator',
        //     channelShowBadge: true,
        //     defaultColor: Color(0xFF9D50DD),
        //     ledColor: Colors.yellow),

        // NotificationChannel(
        //     channelKey: 'big_picture',
        //     channelName: 'Big pictures',
        //     channelDescription: 'Notifications with big and beautiful images',
        //     defaultColor: Color(0xFF9D50DD),
        //     ledColor: Color(0xFF9D50DD),
        //     vibrationPattern: lowVibrationPattern),
      ],
      debug: true);

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        onGenerateRoute: NavigationRouteManager.onRouteGenerate,
        onUnknownRoute: NavigationRouteManager.onUnknownRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        // initialRoute: initScreen == null
        //     ? k_ROUTE_ONBOARDING
        //     : k_ROUTE_VERSION_CONTROL_PAGE,
        initialRoute: k_ROUTE_ONBOARDING,
        title: "Dodact",
        theme: appTheme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
