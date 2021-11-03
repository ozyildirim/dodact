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

//background handler
Future<void> _messageHandler(RemoteMessage message) async {
  AwesomeNotifications().createNotificationFromJsonData(message.data);
  print("message handler çalıştı");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  initScreen = _prefs.getInt("initScreen");
  await _prefs.setInt('initScreen', 1);
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );

  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }

  // AwesomeNotifications().initialize(
  //     'resource://drawable/notification_logo',
  //     [
  //       NotificationChannel(
  //         // icon: 'resource://drawable/notification_logo',
  //         enableLights: true, onlyAlertOnce: true,

  //         channelKey: 'basic_channel',
  //         channelName: 'Basic notifications',
  //         channelDescription: 'Notification channel for basic tests',
  //         // defaultColor: Color(0xFF9D50DD),
  //         // ledColor: Colors.white,
  //       ),
  //     ],
  //     debug: true);

  // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //   if (!isAllowed) {
  //     AlertDialog(
  //       title: Text("Bildirimler İçin İzin ?"),
  //       actions: [
  //         FlatButton(
  //           child: Text("Evet"),
  //           onPressed: () {
  //             AwesomeNotifications().requestPermissionToSendNotifications();
  //           },
  //         ),
  //         FlatButton(
  //           child: Text("Hayır"),
  //           onPressed: () {},
  //         ),
  //       ],
  //     );
  //   }
  // });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("main 2. çalıştı");
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      icon: 'resource://drawable/notification_logo',
      channelKey: 'basic_channel',
      title: message.notification.title,
      body: message.notification.body,
    ));
  });

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
