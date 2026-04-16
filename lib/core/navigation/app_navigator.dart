import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_page_route.dart';

class AppNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _log(String action, Widget screen) {
    if (kDebugMode) {
      log('Navigation: $action -> ${screen.runtimeType}');
    }
  }

  Future<void> push({
    required Widget screen,
    NavAnimation animation = NavAnimation.fade,
  }) async {
    _log('PUSH', screen);
    await navigatorKey.currentState!.push(
      AppPageRoute.build(
        screen: screen,
        animation: animation,
      ),
    );
  }

  Future<void> pushReplacement({
    required Widget screen,
    NavAnimation animation = NavAnimation.fade,
  }) async {
    _log('PUSH_REPLACEMENT', screen);
    await navigatorKey.currentState!.pushReplacement(
      AppPageRoute.build(
        screen: screen,
        animation: animation,
      ),
    );
  }

  Future<void> pushAndRemoveUntil({
    required Widget screen,
    NavAnimation animation = NavAnimation.fade,
  }) async {
    _log('PUSH_AND_REMOVE_UNTIL', screen);
    await navigatorKey.currentState!.pushAndRemoveUntil(
      AppPageRoute.build(
        screen: screen,
        animation: animation,
      ),
      (_) => false,
    );
  }

  void pop<T extends Object?>([T? result]) {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop(result);
    }
  }

  void popToFirst() {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
