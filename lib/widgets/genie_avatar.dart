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

  late AnimationController _fingerSlideController;
  late Animation<double> _fingerSlideAnim;

  late AnimationController _fingerBounceController;
  late Animation<double> _fingerBounceAnim;

  late AnimationController _fingerFadeController;
  late Animation<double> _fingerFadeAnim;

  bool _winking = false;
  bool _showJoke = false;
  String? _currentJoke;
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

    // Float — gentle bob
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Aura
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat(reverse: true);
    _auraAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );

    // Pulse on tap
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pulseAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 50),
    ]).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Finger slide in from left
    _fingerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fingerSlideAnim = Tween<double>(begin: -120, end: 0).animate(
      CurvedAnimation(
          parent: _fingerSlideController, curve: Curves.easeOutBack),
    );

    // Finger bounce toward genie
    _fingerBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _fingerBounceAnim = Tween<double>(begin: 0, end: 16).animate(
      CurvedAnimation(
          parent: _fingerBounceController, curve: Curves.easeInOut),
    );

    // Finger fade out on tap
    _fingerFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fingerFadeAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fingerFadeController, curve: Curves.easeOut),
    );

    // Slide finger in after short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fingerSlideController.forward();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _auraController.dispose();
    _pulseController.dispose();
    _fingerSlideController.dispose();
    _fingerBounceController.dispose();
    _fingerFadeController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_busy) return;
    _busy = true;

    _fingerFadeController.forward();
    _pulseController.forward(from: 0);

    if (mounted) setState(() => _winking = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _winking = false);

    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() {
        _currentJoke = _jokes[_random.nextInt(_jokes.length)];
        _showJoke = true;
      });
    }

    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) setState(() => _showJoke = false);

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _busy = false;
      widget.onTap?.call();
    }
  }

  Widget _genieImage(String asset) {
    return Image.asset(
      asset,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Single consistent size — no overflow
    const double size = 420;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [

          // Aura glow
          AnimatedBuilder(
            animation: _auraAnim,
            builder: (_, __) => Transform.scale(
              scale: _auraAnim.value,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.cyan.withValues(alpha: 0.18),
                      Colors.cyan.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Genie — float + pulse + crossfade wink
          AnimatedBuilder(
            animation: Listenable.merge([_floatAnim, _pulseAnim]),
            builder: (_, __) => Transform.translate(
              offset: Offset(0, _floatAnim.value),
              child: Transform.scale(
                scale: _pulseAnim.value,
                child: GestureDetector(
                  onTap: _handleTap,
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedOpacity(
                          opacity: _winking ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: _genieImage('assets/images/genie.png'),
                        ),
                        AnimatedOpacity(
                          opacity: _winking ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: _genieImage('assets/images/genie_wink.png'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Finger — slides in from left, bounces right
          AnimatedBuilder(
            animation: Listenable.merge([
              _fingerSlideAnim,
              _fingerBounceAnim,
              _fingerFadeAnim,
            ]),
            builder: (_, __) => Positioned(
              left: _fingerSlideAnim.value + _fingerBounceAnim.value,
              top: size * 0.45,
              child: Opacity(
                opacity: _fingerFadeAnim.value,
                child: CustomPaint(
                  size: const Size(80, 90),
                  painter: _GloveHandPainter(),
                ),
              ),
            ),
          ),

          // Joke bubble — floats at chest level
          if (_showJoke && _currentJoke != null)
            Positioned(
              bottom: size * 0.38,
              left: 40,
              right: 40,
              child: AnimatedOpacity(
                opacity: _showJoke ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0d0030).withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(30),
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
                      fontSize: 13,
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

// ── Mickey glove hand pointing RIGHT ─────────────────────────────────────────

class _GloveHandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final outline = Paint()
      ..color = Colors.black..style = PaintingStyle.stroke
      ..strokeWidth = 3.0..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    void drawPath(Path p) {
      canvas.drawPath(p, fill);
      canvas.drawPath(p, outline);
    }

    // Palm
    drawPath(Path()..addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.35, w * 0.60, h * 0.38),
      const Radius.circular(16),
    )));

    // Wrist cuff
    drawPath(Path()..addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.05, h * 0.70, w * 0.50, h * 0.16),
      const Radius.circular(8),
    )));

    // Index finger — pointing RIGHT
    final index = Path();
    index.moveTo(w * 0.70, h * 0.35);
    index.lineTo(w * 0.98, h * 0.35);
    index.arcToPoint(Offset(w * 0.98, h * 0.55),
        radius: const Radius.circular(14), clockwise: true);
    index.lineTo(w * 0.70, h * 0.55);
    index.close();
    drawPath(index);

    // Middle finger — tucked
    final mid = Path();
    mid.moveTo(w * 0.70, h * 0.20);
    mid.lineTo(w * 0.88, h * 0.20);
    mid.arcToPoint(Offset(w * 0.88, h * 0.36),
        radius: const Radius.circular(10), clockwise: true);
    mid.lineTo(w * 0.70, h * 0.36);
    mid.close();
    drawPath(mid);

    // Ring bump
    canvas.drawCircle(Offset(w * 0.72, h * 0.62), w * 0.09, fill);
    canvas.drawCircle(Offset(w * 0.72, h * 0.62), w * 0.09, outline);

    // Thumb
    final thumb = Path();
    thumb.moveTo(w * 0.14, h * 0.36);
    thumb.lineTo(w * 0.08, h * 0.22);
    thumb.arcToPoint(Offset(w * 0.26, h * 0.18),
        radius: const Radius.circular(12));
    thumb.lineTo(w * 0.30, h * 0.36);
    thumb.close();
    drawPath(thumb);

    // Knuckle lines
    final knuckle = Paint()
      ..color = Colors.grey.shade400..strokeWidth = 1.5
      ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(w * 0.74, h * 0.39), Offset(w * 0.74, h * 0.51), knuckle);
    canvas.drawLine(
        Offset(w * 0.82, h * 0.39), Offset(w * 0.82, h * 0.51), knuckle);
  }

  @override
  bool shouldRepaint(_GloveHandPainter old) => false;
}