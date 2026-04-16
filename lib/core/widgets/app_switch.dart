import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  const AppSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: value,
      activeTrackColor: Theme.of(context).primaryColor,
      inactiveTrackColor: Theme.of(context).scaffoldBackgroundColor,
      onChanged: onChanged,
    );
  }
}