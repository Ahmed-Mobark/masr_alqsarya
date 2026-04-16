import 'package:flutter/material.dart';

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({
    required Color color,
    required double radius,
    this.verticalPadding = 5.0,
  }) : _painter = _CirclePainter(color, radius, verticalPadding);

  final double verticalPadding;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;
  final double verticalPadding;

  _CirclePainter(Color color, this.radius, this.verticalPadding)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    if (cfg.size == null) return;

    final double dx = cfg.size!.width / 2;
    final double dy = cfg.size!.height - radius - verticalPadding;
    final Offset circleOffset = offset + Offset(dx, dy);

    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
