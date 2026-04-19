import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:flutter/material.dart';

class Validator {
  static BuildContext context = sl<AppNavigator>().navigatorKey.currentState!.context;

  static String? defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    return null;
  }

  static String? dateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    return null;
  }

  static String? checkBox(bool? value) {
    if (value == null || !value) {
      return context.tr.errorFieldRequired;
    }
    return null;
  }

  static String? text(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    if (!RegExp('[a-zA-Z]').hasMatch(value)) {
      return context.tr.errorInvalidName;
    }
    return null;
  }

  static String? hasValidUrl(String? value) {
    const pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?';
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    if (!RegExp(pattern).hasMatch(value)) {
      return context.tr.errorInvalidUrl;
    }
    return null;
  }


  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return context.tr.errorInvalidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    if (value.length < 8 ||
        !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*\-_+=<>.,;:]).{8,}$')
            .hasMatch(value)) {
      return context.tr.errorInvalidPassword;
    }
    return null;
  }

  static String? confirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    if (confirmPassword != password) {
      return context.tr.errorPasswordMismatch;
    }
    return null;
  }

  static String? numbers(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    final sanitizedValue = value.startsWith("+") ? value.replaceFirst("+", "") : value;
    if (int.tryParse(sanitizedValue) == null) {
      return context.tr.errorInvalidNumber;
    }
    return null;
  }


  static String? ibanValidator(String? value, String payment) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }

    final trimmedValue = value.trim().toUpperCase();
    late RegExp regex;

    switch (payment) {
      case "SAUDI_PAY": // Saudi Arabia IBAN
        regex = RegExp(r'^SA\d{22}$');
        break;
      case "BAHRAIN_PAY": // Bahrain IBAN
        regex = RegExp(r'^BH\d{2}[A-Z0-9]{14}$');
        break;
      default:
        return context.tr.errorInvalidIban;
    }

    if (!regex.hasMatch(trimmedValue)) {
      return context.tr.errorInvalidIban;
    }
    return null;
  }


  static String? stcPayMobileValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    const saudiMobilePattern = r'^(05\d{8}|9665\d{8})$';
    if (!RegExp(saudiMobilePattern).hasMatch(value.trim())) {
      return context.tr.errorInvalidMobileNumber;
    }
    return null;
  }

  static String? stcPayIdValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    if (value.length < 10 || value.length > 15 || int.tryParse(value) == null) {
      return context.tr.errorInvalidStcPayId;
    }
    return null;
  }


  static String? nationalIdValidator(String? value, String payment) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }

    final trimmedValue = value.trim();
    late RegExp regex;

    switch (payment) {
      case "SAUDI_PAY": // Saudi Arabia
        regex = RegExp(r'^[12]\d{9}$');
        break;
      case "MOROCCO_PAY": // Morocco
        regex = RegExp(r'^[A-Z]{1,2}\d{4,6}$');
        break;
      case "BAHRAIN_PAY": // Bahrain
        regex = RegExp(r'^\d{9}$');
        break;
      default:
        return context.tr.errorInvalidNationalId;
    }

    if (!regex.hasMatch(trimmedValue)) {
      return context.tr.errorInvalidNationalId;
    }
    return null;
  }

  static String? passportValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr.errorFieldRequired;
    }
    const passportPattern = r'^[a-zA-Z0-9]{6,9}$'; 
    if (!RegExp(passportPattern).hasMatch(value.trim())) {
      return context.tr.errorInvalidPassport;
    }
    return null;
  }

}