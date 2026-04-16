import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(Locale(sl<Storage>().getLang()));

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    await sl<Storage>().storeLang(langCode: locale.languageCode);
    sl<ApiBaseHelper>().updateLocaleInHeaders(locale.languageCode);
    emit(locale);
  }
}

