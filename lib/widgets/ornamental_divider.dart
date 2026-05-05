import 'package:flutter/material.dart';

class OrnamentalDivider extends StatelessWidget {
  final double height;
  final Color color;

  const OrnamentalDivider({
    super.key,
    this.height = 60,
    this.color = const Color(0xFFd4af37),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: height,
      child: CustomPaint(
        painter: _DiamondPainter(color: color),
      ),
    );
  }
}

class _DiamondPainter extends CustomPainter {
  final Color color;
  _DiamondPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const ds = 8.0; // diamond half-size

    // Glow
    canvas.drawPath(
      _diamond(cx, cy, ds + 3),
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Fill
    canvas.drawPath(
      _diamond(cx, cy, ds),
      Paint()..color = color..style = PaintingStyle.fill,
    );

    // Inner highlight
    canvas.drawPath(
      _diamond(cx, cy, ds * 0.38),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill,
    );
  }

  Path _diamond(double cx, double cy, double size) {
    return Path()
      ..moveTo(cx, cy - size)
      ..lineTo(cx + size, cy)
      ..lineTo(cx, cy + size)
      ..lineTo(cx - size, cy)
      ..close();
  }

  @override
  bool shouldRepaint(_DiamondPainter old) => old.color != color;
}