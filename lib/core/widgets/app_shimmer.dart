import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class AppShimmer extends StatelessWidget {
  final Color? baseColor;
  final Color? highlightColor;
  final Widget child;
  const AppShimmer({super.key, required this.child, this.baseColor, this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Theme.of(context).cardColor,
      highlightColor: highlightColor ?? Theme.of(context).highlightColor,
      child: child
    );
  }
}
