import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/navigation/route_observer.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/theme/app_theme.dart';
import 'package:masr_al_qsariya/core/translation/app_localizations.dart';
import 'package:masr_al_qsariya/features/splash/presentation/view/splash_view.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale _locale = Locale(sl<Storage>().getLang());

  Future<void> setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    await sl<Storage>().storeLang(langCode: locale.languageCode);
    sl<ApiBaseHelper>().updateLocaleInHeaders(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) => AdaptiveTheme(
        light: AppTheme.appLightTheme,
        dark: AppTheme.appDarkTheme,
        initial: AdaptiveThemeMode.light,
        debugShowFloatingThemeButton: false,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: const ScrollBehavior()
              .copyWith(physics: const BouncingScrollPhysics()),
          theme: theme,
          darkTheme: darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [ObserverUtils.routeObserver],
          locale: _locale,
          navigatorKey: sl<AppNavigator>().navigatorKey,
          builder: (context, child) {
            final textDirection = _locale.languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr;
            return Directionality(
              textDirection: textDirection,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const SplashView(),
        ),
      ),
    );
  }
}