import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/app/app_body.dart';
import 'core/bloc/bloc_observer.dart';
import 'core/injection/injection_container.dart' as injection;
import 'dart:io';

// Debug-only escape hatch for misconfigured HTTPS certificates.
// Enable ONLY for local dev:
// `flutter run --dart-define=ALLOW_BAD_CERTS=true`
const bool _allowBadCerts =
    bool.fromEnvironment('ALLOW_BAD_CERTS', defaultValue: false);

class _DebugHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  if (kDebugMode && _allowBadCerts) {
    HttpOverrides.global = _DebugHttpOverrides();
  }
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await injection.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
