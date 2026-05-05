import 'dart:math';
import 'package:flutter/material.dart';

class GenieAvatar extends StatefulWidget {
  final VoidCallback? onTap;
  const GenieAvatar({super.key, this.onTap});

  @override
  State<GenieAvatar> createState() => _GenieAvatarState();
}

class _GenieAvatarState extends State<GenieAvatar>
    with TickerProviderStateMixin {

  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  late AnimationController _auraController;
  late Animation<double> _auraAnim;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  late AnimationController _fingerController;
  late Animation<double> _fingerAnim;

  bool _winking = false;
  bool _showJoke = false;
  String? _currentJoke;

  // Lock to prevent multiple taps firing camera multiple times
  bool _busy = false;

  final _random = Random();
  final List<String> _jokes = [
    'I recommend something with rum.',
    'Stir… don\'t anger the spirits.',
    'You look like a margarita person.',
    'Wish granted. Hangover not included.',
    'Ice is just water\'s glow-up.',
  ];

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);
    _auraAnim = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pulseAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 50),
    ]).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _fingerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    _fingerAnim = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _fingerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _auraController.dispose();
    _pulseController.dispose();
    _fingerController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    // Hard lock — ignore all taps while sequence is running
    if (_busy) return;
    _busy = true;

    // 1. Pulse
    _pulseController.forward(from: 0);

    // 2. Wink — crossfade for 600ms
    if (mounted) setState(() => _winking = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _winking = false);

    // 3. Show joke
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() {
        _currentJoke = _jokes[_random.nextInt(_jokes.length)];
        _showJoke = true;
      });
    }

    // 4. Hide joke after 1.8s
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() => _showJoke = false);

    // 5. Open camera — only once
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      _busy = false; // unlock only after camera opens
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [

          // ── Aura glow ────────────────────────────────────────────
          AnimatedBuilder(
            animation: _auraAnim,
            builder: (_, __) => Transform.scale(
              scale: _auraAnim.value,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.cyan.withValues(alpha: 0.22),
                      Colors.cyan.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── Genie — float + pulse + circular clip (no white bg) ──
          AnimatedBuilder(
            animation: Listenable.merge([_floatAnim, _pulseAnim]),
            builder: (_, __) => Transform.translate(
              offset: Offset(0, _floatAnim.value),
              child: Transform.scale(
                scale: _pulseAnim.value,
                child: GestureDetector(
                  onTap: _handleTap,
                  child: SizedBox(
                    width: 240,
                    height: 240,
                    child: ClipOval(
                      // ClipOval removes the white square corners
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Normal genie
                          AnimatedOpacity(
                            opacity: _winking ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 150),
                            child: Image.asset(
                              'assets/images/genie.png',
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          // Winking genie
                          AnimatedOpacity(
                            opacity: _winking ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 150),
                            child: Image.asset(
                              'assets/images/genie_wink.png',
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Mickey hand — bounces up toward genie ────────────────
          Positioned(
            bottom: 10,
            right: 10,
            child: AnimatedBuilder(
              animation: _fingerAnim,
              builder: (_, __) => Transform.translate(
                offset: Offset(0, _fingerAnim.value),
                child: CustomPaint(
                  size: const Size(58, 72),
                  painter: _MickeyHandPainter(),
                ),
              ),
            ),
          ),

          // ── Joke bubble ──────────────────────────────────────────
          if (_showJoke && _currentJoke != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _showJoke ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0d0030).withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.cyan),
                    boxShadow: [BoxShadow(
                      color: Colors.cyan.withValues(alpha: 0.45),
                      blurRadius: 14,
                    )],
                  ),
                  child: Text(
                    '🧞 $_currentJoke',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Mickey Mouse glove hand pointing UP ──────────────────────────────────────

class _MickeyHandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final outline = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Palm
    canvas.drawPath(
      Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.52, w * 0.68, h * 0.33),
        const Radius.circular(14),
      )),
      fill,
    );
    canvas.drawPath(
      Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.52, w * 0.68, h * 0.33),
        const Radius.circular(14),
      )),
      outline,
    );

    // Wrist cuff
    canvas.drawPath(
      Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.20, h * 0.82, w * 0.58, h * 0.14),
        const Radius.circular(7),
      )),
      fill,
    );
    canvas.drawPath(
      Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.20, h * 0.82, w * 0.58, h * 0.14),
        const Radius.circular(7),
      )),
      outline,
    );

    // Index finger — pointing UP
    final index = Path();
    index.moveTo(w * 0.33, h * 0.52);
    index.lineTo(w * 0.33, h * 0.12);
    index.arcToPoint(Offset(w * 0.62, h * 0.12),
        radius: const Radius.circular(16), clockwise: false);
    index.lineTo(w * 0.62, h * 0.52);
    index.close();
    canvas.drawPath(index, fill);
    canvas.drawPath(index, outline);

    // Middle finger — shorter, tucked
    final mid = Path();
    mid.moveTo(w * 0.63, h * 0.52);
    mid.lineTo(w * 0.63, h * 0.28);
    mid.arcToPoint(Offset(w * 0.80, h * 0.28),
        radius: const Radius.circular(10), clockwise: false);
    mid.lineTo(w * 0.80, h * 0.52);
    mid.close();
    canvas.drawPath(mid, fill);
    canvas.drawPath(mid, outline);

    // Ring bump
    canvas.drawCircle(Offset(w * 0.73, h * 0.55), w * 0.09, fill);
    canvas.drawCircle(Offset(w * 0.73, h * 0.55), w * 0.09, outline);

    // Thumb
    final thumb = Path();
    thumb.moveTo(w * 0.16, h * 0.60);
    thumb.lineTo(w * 0.03, h * 0.50);
    thumb.arcToPoint(Offset(w * 0.03, h * 0.68),
        radius: const Radius.circular(10));
    thumb.lineTo(w * 0.16, h * 0.74);
    thumb.close();
    canvas.drawPath(thumb, fill);
    canvas.drawPath(thumb, outline);

    // Knuckle lines
    final knuckle = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(w * 0.37, h * 0.37), Offset(w * 0.58, h * 0.37), knuckle);
    canvas.drawLine(
        Offset(w * 0.37, h * 0.45), Offset(w * 0.58, h * 0.45), knuckle);
  }

  @override
  bool shouldRepaint(_MickeyHandPainter old) => false;
}