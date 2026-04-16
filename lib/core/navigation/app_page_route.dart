import 'package:flutter/cupertino.dart';

enum NavAnimation { slide, fade, scale, cupertino }

class AppPageRoute {
  static PageRoute build({
    required Widget screen,
    required NavAnimation animation,
  }) {
    switch (animation) {
      case NavAnimation.fade:
        return _fade(screen);

      case NavAnimation.scale:
        return _scale(screen);

      case NavAnimation.cupertino:
        return CupertinoPageRoute(builder: (_) => screen);

      case NavAnimation.slide:
        return _slide(screen);
    }
  }

  /// =======================
  /// Fade (same as FadePageRoute)
  /// =======================
  static PageRoute _fade(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, animation, __) => screen,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// =======================
  /// Slide (same as SlidePageRoute + createRoute)
  /// Default: from right → center
  /// =======================
  static PageRoute _slide(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, __) => screen,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.ease));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// =======================
  /// Scale (same as ScalePageRoute)
  /// =======================
  static PageRoute _scale(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, __) => screen,
      transitionsBuilder: (_, animation, __, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      },
    );
  }
}
