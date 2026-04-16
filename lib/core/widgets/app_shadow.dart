import 'package:flutter/material.dart';

class AppShadow {
  static List<BoxShadow> boxShadow(BuildContext context) => [BoxShadow(
    offset: const Offset(0, 2),
    color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.1),
    blurRadius: 4,
    spreadRadius: 0,
  )];
}