import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/translation/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this)!;
}