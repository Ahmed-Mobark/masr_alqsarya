import 'package:masr_al_qsariya/core/toast/toast_service.dart';
import 'package:flutter/material.dart';

Future<void> appToast({
  required context,
  required ToastType type,
  required String message,
  String? description,
  TextStyle? messageStyle,
  TextStyle? descriptionStyle,
  Curve? slideCurve,
  bool? topView,
  bool? isClosable,
  double? expandedHeight,
  Curve? positionCurve,
  ToastLength? length,
  DismissDirection? dismissDirection,
}) => ToastService.showToast(
  context,
  type: type,
  message: message,
  description: description,
  messageStyle: messageStyle,
  descriptionStyle: descriptionStyle,
  slideCurve: slideCurve,
  topView: topView,
  isClosable: isClosable,
  expandedHeight: expandedHeight,
  positionCurve: positionCurve,
  length: length,
  dismissDirection: dismissDirection,
);

enum ToastType {
  success,
  error,
  warning,
}