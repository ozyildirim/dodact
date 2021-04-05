import 'package:flutter/material.dart';

class NavigationService {
  static NavigationService _instance;

  static NavigationService get instance {
    if (_instance == null) {
      _instance = NavigationService._init();
    }
    return _instance;
  }

  NavigationService._init();

  final removeAllOldRoutes = (Route<dynamic> route) => false;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future navigate(String path, {Object args}) async {
    return await navigatorKey.currentState.pushNamed(path, arguments: args);
  }

  Future navigateToReset(String path, {Object args}) async {
    return await navigatorKey.currentState
        .pushNamedAndRemoveUntil(path, removeAllOldRoutes, arguments: args);
  }

  Future navigateReplacement(String path, {Object args}) async {
    return await navigatorKey.currentState.pushReplacementNamed(path);
  }

  void pop() {
    return navigatorKey.currentState.pop();
  }

  void popWithArgs(Object args) {
    return navigatorKey.currentState.pop(args);
  }

  void popUntil(String route) {
    return navigatorKey.currentState.popUntil(ModalRoute.withName(route));
  }
}
