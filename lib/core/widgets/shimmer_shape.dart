import 'package:flutter/material.dart';

class ShimmerShape extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  const ShimmerShape({super.key, this.color, this.margin, required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius)
      ),
    );
  }
}