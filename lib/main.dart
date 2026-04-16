import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:masr_al_qsariya/core/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:masr_al_qsariya/core/theme/app_theme.dart';
import 'package:masr_al_qsariya/core/navigation/app_router.dart';
import 'package:masr_al_qsariya/core/l10n/locale_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MasrAlQsariyaApp(),
    ),
  );
}

class MasrAlQsariyaApp extends StatelessWidget {
  const MasrAlQsariyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Masr Al-Qsariya',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.splash,
    );
  }
}
