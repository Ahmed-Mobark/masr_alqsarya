import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/app/app_body.dart';
import 'core/bloc/bloc_observer.dart';
import 'core/injection/injection_container.dart' as injection;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await ScreenUtil.ensureScreenSize();
  await injection.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}