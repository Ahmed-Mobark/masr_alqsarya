import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/features/splash/presentation/view/splash_view.dart';
import 'package:masr_al_qsariya/features/language/presentation/view/language_view.dart';
import 'package:masr_al_qsariya/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/login_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/sign_up_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/verification_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/role_options_view.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/view/main_nav_view.dart';
import 'package:masr_al_qsariya/features/messages/presentation/view/chat_view.dart';
import 'package:masr_al_qsariya/features/expense/presentation/view/add_expense_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/profile_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/account_security_view.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/family_info_view.dart';
import 'package:masr_al_qsariya/features/settings/presentation/view/settings_view.dart';
import 'package:masr_al_qsariya/features/settings/presentation/view/language_settings_view.dart';
import 'package:masr_al_qsariya/features/notifications/presentation/view/notifications_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String verification = '/verification';
  static const String roleOptions = '/role-options';

  static const String home = '/home';
  static const String chat = '/chat';
  static const String addExpense = '/add-expense';

  static const String profile = '/profile';
  static const String accountSecurity = '/account-security';
  static const String familyInfo = '/family-info';
  static const String settings = '/settings';
  static const String languageSettings = '/language-settings';
  static const String notifications = '/notifications';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _build(settings, const SplashView());
      case AppRoutes.language:
        return _build(settings, const LanguageView());
      case AppRoutes.onboarding:
        return _build(settings, const OnboardingView());
      case AppRoutes.login:
        return _build(settings, const LoginView());
      case AppRoutes.signUp:
        return _build(settings, const SignUpView());
      case AppRoutes.verification:
        return _build(settings, const VerificationView());
      case AppRoutes.roleOptions:
        return _build(settings, const RoleOptionsView());
      case AppRoutes.home:
        return _build(settings, const MainNavView());
      case AppRoutes.chat:
        final args = settings.arguments as Map<String, dynamic>?;
        return _build(settings, ChatView(
          name: args?['name'] ?? '',
          avatarUrl: args?['avatarUrl'] ?? '',
        ));
      case AppRoutes.addExpense:
        return _build(settings, const AddExpenseView());
      case AppRoutes.profile:
        return _build(settings, const ProfileView());
      case AppRoutes.accountSecurity:
        return _build(settings, const AccountSecurityView());
      case AppRoutes.familyInfo:
        return _build(settings, const FamilyInfoView());
      case AppRoutes.settings:
        return _build(settings, const SettingsView());
      case AppRoutes.languageSettings:
        return _build(settings, const LanguageSettingsView());
      case AppRoutes.notifications:
        return _build(settings, const NotificationsView());
      default:
        return _build(
          settings,
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute _build(RouteSettings settings, Widget page) {
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}
