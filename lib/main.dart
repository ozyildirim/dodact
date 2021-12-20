import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dodact_v1/config/constants/providers_list.dart';
import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/config/navigation/navigator_route_service.dart';
import 'package:dodact_v1/localizations/app_localizations.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/services/concrete/firebase_dynamic_link_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;

//background handler
Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  initScreen = _prefs.getInt("initScreen");
  await _prefs.setInt('initScreen', 1);
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          icon: 'resource://drawable/notification_logo',
          enableLights: true,
          onlyAlertOnce: true,
          channelKey: 'basic_channel',
          channelName: 'Genel Bildirimler',
          channelDescription: 'Uygulama içi genel bildirimler',
          importance: NotificationImportance.High,
          // defaultColor: Color(0xFF9D50DD),
          // ledColor: Colors.white,
        ),
      ],
      debug: true);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print("main 2. çalıştı");
    // print("DATA: " + message.data.toString());
    // print("CONTENT: " + message.data['content']);

    var data = message.data['content'];
    var contentMap = jsonDecode(data);

    // if (changedMap is Map) {
    //   print("data is Map");
    // }
    // print(changedMap['payload']);

    String activeChattingUser = _prefs.getString("activeChattingUser");

    //Eğer gelen bildirim chat için ise böyle bir sınıflandırmaya sok, değil ise normal bildirim oluştur.
    if (contentMap['payload']['type'] == "message") {
      if (activeChattingUser != null &&
          contentMap['payload']['from'] == activeChattingUser) {
        print("konuşulan kullanıcıdan mesaj geldi");
      } else {
        AwesomeNotifications().createNotificationFromJsonData(message.data);
      }
    } else {
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    }

    // AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: 10,
    //     icon: 'resource://drawable/notification_logo',
    //     channelKey: 'basic_channel',
    //     title: message.data['title'],
    //     body: message.data['body'],
    //   ),
    // );
  });

  // TODO: Notification'a tiklanma olayi bu fonksiyon. Kullanici giris yapmis mi vs kontrolleri et dene oyle koyalim.
  AwesomeNotifications().actionStream.listen((receivedNotification) {
    if (receivedNotification.buttonKeyPressed == 'REPLY') {
      //REPLY butonuna yazi girip gondere basarsa calisir.
      String message = receivedNotification.buttonKeyInput;
      NavigationService.instance.navigate(k_ROUTE_USER_CHATROOMS, args: {
        'reply': message,
        'from': receivedNotification.payload['from'],
      });
    }
    if (receivedNotification.payload['type'] == 'message') {
      NavigationService.instance.navigate(k_ROUTE_USER_CHATROOMS);
    } else if (receivedNotification.payload['type'] == 'group_invitation') {
      NavigationService.instance.navigate(k_ROUTE_USER_NOTIFICATIONS);
    }
  });

  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print('User granted permission');
  // } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  //   print('User granted provisional permission');
  // } else {
  //   print('User declined or has not accepted permission');
  // }

  setupLocator();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));

  // runApp(
  //   DevicePreview(
  //     // enabled: true,
  //     builder: (context) => MyApp(),
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FirebaseDynamicLinkService _dynamicLinkService =
      FirebaseDynamicLinkService();

  Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          _dynamicLinkService.initDynamicLinks(context);
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initializeDateFormatting('tr_TR', null);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child),
        supportedLocales: [
          Locale('en', 'US'), // Amerikan İngilizcesi
          Locale('tr', 'TR'), // Türkçe
        ],
        localizationsDelegates: [
          /// Uygulama için kendi oluşturduğumuz delegate
          AppLocalizations.delegate,

          /// Material widget kütüphanesi için delegate
          GlobalMaterialLocalizations.delegate,

          /// Widgetlar için Locale değerine göre metin yönünü belirler
          /// [TextDirection.ltr] Metin Yönü - Soldan sağa (left to right) (Varsayılan)
          /// [TextDirection.rtl] Metin Yönü - Sağdan sola(right to left)
          GlobalWidgetsLocalizations.delegate,

          /// Cupertino widget kütüphanesi için delegate
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback:
            (Locale locale, Iterable<Locale> supportedLocales) {
          /// [locale]: Cihazın dili null değilse
          if (locale != null) {
            debugPrint(
                "Algılanan cihaz dili: Dil Kodu: ${locale.languageCode}, Ülke Kodu: ${locale.countryCode}");
            for (var supportedLocale in supportedLocales) {
              /// Cihazın dil kodu desteklenen diller arasındaki dil kodlarının içinde var mı?
              if (supportedLocale.languageCode == locale.languageCode) {
                /// Varsa desteklenen dili döndür
                return supportedLocale;
              }
            }
          }
          debugPrint(
              "Algılanan cihaz dili desteklenen diller arasında bulunmuyor.");

          /// [locale]: Cihazın dili null ise
          /// Yoksa [supportedLocales] Listesindeki ilk sonucu döndür.
          debugPrint(
              "Uygulamanın başlatılması istenen dil: Dil Kodu: ${supportedLocales.first.languageCode}, Ülke Kodu: ${supportedLocales.first.countryCode}");
          return supportedLocales.first;
        },
        useInheritedMediaQuery: true,
        onGenerateRoute: NavigationRouteManager.onRouteGenerate,
        onUnknownRoute: NavigationRouteManager.onUnknownRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        initialRoute: initScreen == null
            ? k_ROUTE_ONBOARDING
            : k_ROUTE_VERSION_CONTROL_PAGE,

        // initialRoute: k_ROUTE_ONBOARDING,
        title: "Dodact",
        theme: appTheme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
