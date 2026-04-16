import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_theme.dart';
import 'package:masr_al_qsariya/core/translation/app_localizations.dart';
import 'package:masr_al_qsariya/features/splash/presentation/view/splash_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      fontSizeResolver: (fontSize, instance) {
        return fontSize * instance.scaleWidth;
      },
      builder: (BuildContext context, Widget? child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: const ScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(),
        ),
        theme: AppTheme.appLightTheme,
        darkTheme: AppTheme.appDarkTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        navigatorKey: sl<AppNavigator>().navigatorKey,
        home: const SplashView(),
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          final scale = mq.textScaler.scale(1.0);
          final clampedScale = scale.clamp(0.85, 1.15);
          final textDirection = 'ar' == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr;
          return Directionality(
            textDirection: textDirection,
            child: MediaQuery(
              data: mq.copyWith(textScaler: TextScaler.linear(clampedScale)),
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
