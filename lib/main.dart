import 'package:dodact_v1/config/constants/route_constants.dart';
import 'package:dodact_v1/config/constants/theme_constants.dart';
import 'package:dodact_v1/config/navigation/navigation_service.dart';
import 'package:dodact_v1/config/navigation/navigator_route_service.dart';
import 'package:dodact_v1/locator.dart';
import 'package:dodact_v1/provider/announcement_provider.dart';
import 'package:dodact_v1/provider/auth_provider.dart';
import 'package:dodact_v1/provider/comment_provider.dart';
import 'package:dodact_v1/provider/event_provider.dart';
import 'package:dodact_v1/provider/group_provider.dart';
import 'package:dodact_v1/provider/post_provider.dart';
import 'package:dodact_v1/provider/request_provider.dart';
import 'package:dodact_v1/provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  initScreen = _prefs.getInt("initScreen");
  // await _prefs.setInt('initScreen', 1);
  // print('initScreen $initScreen');
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
      ],
      child: MaterialApp(
        onGenerateRoute: NavigationRouteManager.onRouteGenerate,
        onUnknownRoute: NavigationRouteManager.onUnknownRoute,
        navigatorKey: NavigationService.instance.navigatorKey,
        initialRoute: initScreen == null ? k_ROUTE_ONBOARDING : k_ROUTE_LANDING,
        // initialRoute: k_ROUTE_ONBOARDING,
        title: "Dodact",
        theme: appTheme,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
