import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/navigation/route_observer.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/config/styles/font_utils.dart';
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
    AppFont.setLocale(locale.languageCode);
    await sl<Storage>().storeLang(langCode: locale.languageCode);
    sl<ApiBaseHelper>().updateLocaleInHeaders(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    AppFont.setLocale(_locale.languageCode);
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) => AdaptiveTheme(
        light: AppTheme.appLightTheme,
        dark: AppTheme.appDarkTheme,
        initial: AdaptiveThemeMode.light,
        debugShowFloatingThemeButton: false,
        builder: (theme, darkTheme) {
          final isArabic = _locale.languageCode == 'ar';
          final effectiveTheme = isArabic
              ? theme.copyWith(
                  textTheme: GoogleFonts.rubikTextTheme(theme.textTheme),
                  primaryTextTheme:
                      GoogleFonts.rubikTextTheme(theme.primaryTextTheme),
                )
              : theme;
          final effectiveDarkTheme = isArabic
              ? darkTheme.copyWith(
                  textTheme: GoogleFonts.rubikTextTheme(darkTheme.textTheme),
                  primaryTextTheme:
                      GoogleFonts.rubikTextTheme(darkTheme.primaryTextTheme),
                )
              : darkTheme;

          return MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: const ScrollBehavior()
              .copyWith(physics: const BouncingScrollPhysics()),
          theme: effectiveTheme,
          darkTheme: effectiveDarkTheme,
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
          );
        },
      ),
    );
  }
}