import 'package:flutter/material.dart';

// ── Martini Glass (Genie Suggests) ──────────────────────────────────────────
class MartiniGlassIcon extends StatelessWidget {
  final Color color;
  final double size;
  const MartiniGlassIcon({super.key, required this.color, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _MartiniPainter(color: color),
    );
  }
}

class _MartiniPainter extends CustomPainter {
  final Color color;
  _MartiniPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glow = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Bowl — triangle shape
    final bowl = Path()
      ..moveTo(w * 0.08, h * 0.12)
      ..lineTo(w * 0.92, h * 0.12)
      ..lineTo(w * 0.50, h * 0.58)
      ..close();

    // Stem
    final stem = Path()
      ..moveTo(w * 0.50, h * 0.58)
      ..lineTo(w * 0.50, h * 0.85);

    // Base
    final base = Path()
      ..moveTo(w * 0.25, h * 0.85)
      ..lineTo(w * 0.75, h * 0.85);

    // Liquid fill
    final liquid = Path()
      ..moveTo(w * 0.22, h * 0.30)
      ..lineTo(w * 0.78, h * 0.30)
      ..lineTo(w * 0.50, h * 0.58)
      ..close();

    canvas.drawPath(liquid, Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill);

    for (final path in [bowl, stem, base]) {
      canvas.drawPath(path, glow);
      canvas.drawPath(path, paint);
    }

    // Olive
    canvas.drawCircle(Offset(w * 0.55, h * 0.22), w * 0.055,
        Paint()..color = color..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(w * 0.55, h * 0.22), w * 0.055,
        Paint()..color = color.withValues(alpha: 0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_MartiniPainter old) => old.color != color;
}

// ── Hurricane Glass (Crazy Cocktail) ────────────────────────────────────────
class HurricaneGlassIcon extends StatelessWidget {
  final Color color;
  final double size;
  const HurricaneGlassIcon({super.key, required this.color, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HurricanePainter(color: color),
    );
  }
}

class _HurricanePainter extends CustomPainter {
  final Color color;
  _HurricanePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glow = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Hurricane glass outline — curves in at middle, wide at top and bottom
    final glass = Path()
      ..moveTo(w * 0.20, h * 0.08)
      ..cubicTo(w * 0.35, h * 0.08, w * 0.38, h * 0.42, w * 0.32, h * 0.55)
      ..cubicTo(w * 0.26, h * 0.68, w * 0.20, h * 0.80, w * 0.18, h * 0.88)
      ..lineTo(w * 0.82, h * 0.88)
      ..cubicTo(w * 0.80, h * 0.80, w * 0.74, h * 0.68, w * 0.68, h * 0.55)
      ..cubicTo(w * 0.62, h * 0.42, w * 0.65, h * 0.08, w * 0.80, h * 0.08)
      ..close();

    // Liquid
    final liquid = Path()
      ..moveTo(w * 0.22, h * 0.30)
      ..cubicTo(w * 0.36, h * 0.30, w * 0.38, h * 0.48, w * 0.33, h * 0.58)
      ..cubicTo(w * 0.28, h * 0.68, w * 0.22, h * 0.78, w * 0.20, h * 0.88)
      ..lineTo(w * 0.80, h * 0.88)
      ..cubicTo(w * 0.78, h * 0.78, w * 0.72, h * 0.68, w * 0.67, h * 0.58)
      ..cubicTo(w * 0.62, h * 0.48, w * 0.64, h * 0.30, w * 0.78, h * 0.30)
      ..close();

    canvas.drawPath(liquid, Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill);

    // Base line
    final base = Path()
      ..moveTo(w * 0.12, h * 0.88)
      ..lineTo(w * 0.88, h * 0.88);

    canvas.drawPath(glass, glow);
    canvas.drawPath(glass, paint);
    canvas.drawPath(base, glow);
    canvas.drawPath(base, paint);

    // Straw
    final straw = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.62, h * 0.88), Offset(w * 0.72, h * 0.15), straw);

    // Cherry
    canvas.drawCircle(Offset(w * 0.73, h * 0.13), w * 0.06,
        Paint()..color = color..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_HurricanePainter old) => old.color != color;
}

// ── Champagne Flute (Ask Genie) ─────────────────────────────────────────────
class ChampagneFluteIcon extends StatelessWidget {
  final Color color;
  final double size;
  const ChampagneFluteIcon({super.key, required this.color, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FlutePainter(color: color),
    );
  }
}

class _FlutePainter extends CustomPainter {
  final Color color;
  _FlutePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glow = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Flute — narrow tall glass
    final glass = Path()
      ..moveTo(w * 0.32, h * 0.08)
      ..cubicTo(w * 0.28, h * 0.08, w * 0.25, h * 0.30, w * 0.28, h * 0.60)
      ..lineTo(w * 0.28, h * 0.78)
      ..lineTo(w * 0.72, h * 0.78)
      ..lineTo(w * 0.72, h * 0.60)
      ..cubicTo(w * 0.75, h * 0.30, w * 0.72, h * 0.08, w * 0.68, h * 0.08)
      ..close();

    // Liquid
    final liquid = Path()
      ..moveTo(w * 0.32, h * 0.30)
      ..cubicTo(w * 0.29, h * 0.30, w * 0.27, h * 0.48, w * 0.28, h * 0.60)
      ..lineTo(w * 0.28, h * 0.78)
      ..lineTo(w * 0.72, h * 0.78)
      ..lineTo(w * 0.72, h * 0.60)
      ..cubicTo(w * 0.73, h * 0.48, w * 0.71, h * 0.30, w * 0.68, h * 0.30)
      ..close();

    canvas.drawPath(liquid, Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill);

    canvas.drawPath(glass, glow);
    canvas.drawPath(glass, paint);

    // Stem
    final stem = Path()
      ..moveTo(w * 0.50, h * 0.78)
      ..lineTo(w * 0.50, h * 0.88);
    canvas.drawPath(stem, glow);
    canvas.drawPath(stem, paint);

    // Base
    final base = Path()
      ..moveTo(w * 0.28, h * 0.88)
      ..lineTo(w * 0.72, h * 0.88);
    canvas.drawPath(base, glow);
    canvas.drawPath(base, paint);

    // Bubbles
    final bubblePaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.42, h * 0.65), 1.5, bubblePaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.52), 1.5, bubblePaint);
    canvas.drawCircle(Offset(w * 0.58, h * 0.40), 1.5, bubblePaint);
    canvas.drawCircle(Offset(w * 0.45, h * 0.38), 1.2, bubblePaint);
  }

  @override
  bool shouldRepaint(_FlutePainter old) => old.color != color;
}