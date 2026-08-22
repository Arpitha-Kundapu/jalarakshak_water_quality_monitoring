import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'language_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // ANIMATION CONTROLLERS
  // ============================================================

  late final AnimationController _entrance;
  late final AnimationController _floating;
  late final AnimationController _water;
  late final AnimationController _loading;

  Timer? _timer;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    // Main entrance animation
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    // Gentle logo floating animation
    _floating = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Slow water animation
    _water = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Loading animation
    _loading = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // ============================================================
    // MOVE TO LANGUAGE SCREEN AFTER 4 SECONDS
    // ============================================================

    _timer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LanguageScreen()),
      );
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _timer?.cancel();

    _entrance.dispose();
    _floating.dispose();
    _water.dispose();
    _loading.dispose();

    super.dispose();
  }

  // ============================================================
  // FADE ANIMATION
  // ============================================================

  Animation<double> _fade(double start, double end) {
    return CurvedAnimation(
      parent: _entrance,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  // ============================================================
  // SLIDE ANIMATION
  // ============================================================

  Animation<Offset> _slideUp(double start, double end) {
    return Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFD),

      body: Stack(
        fit: StackFit.expand,
        children: [
          // ========================================================
          // BACKGROUND
          // ========================================================
          const _SoftBackground(),

          // ========================================================
          // SOFT FLOATING LIGHT
          // ========================================================
          AnimatedBuilder(
            animation: _water,
            builder: (context, _) {
              return CustomPaint(painter: _SoftBubblesPainter(_water.value));
            },
          ),

          // ========================================================
          // WATER AT BOTTOM
          // ========================================================
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _water,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(size.width, size.height * 0.27),
                  painter: _NaturalWaterPainter(_water.value),
                );
              },
            ),
          ),

          // ========================================================
          // MAIN CONTENT
          // ========================================================
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ==================================================
                // LOGO
                // ==================================================
                FadeTransition(
                  opacity: _fade(0.0, 0.55),
                  child: AnimatedBuilder(
                    animation: _floating,
                    builder: (context, child) {
                      final movement = sin(_floating.value * pi) * 5;

                      return Transform.translate(
                        offset: Offset(0, -movement),
                        child: child,
                      );
                    },
                    child: const _NaturalLogo(size: 175),
                  ),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // TITLE
                // ==================================================
                FadeTransition(
                  opacity: _fade(0.20, 0.65),
                  child: SlideTransition(
                    position: _slideUp(0.20, 0.65),
                    child: const Text(
                      'JalRakshak',
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        color: Color(0xFF1267B1),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                // ==================================================
                // SUBTITLE
                // ==================================================
                FadeTransition(
                  opacity: _fade(0.30, 0.72),
                  child: SlideTransition(
                    position: _slideUp(0.30, 0.72),
                    child: const Text(
                      'Drinking Water Quality Monitoring',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF66849D),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // SMALL DIVIDER
                // ==================================================
                FadeTransition(
                  opacity: _fade(0.40, 0.78),
                  child: const _WaterDivider(),
                ),

                const Spacer(flex: 3),

                // ==================================================
                // FEATURES
                // ==================================================
                FadeTransition(
                  opacity: _fade(0.50, 0.90),
                  child: SlideTransition(
                    position: _slideUp(0.50, 0.90),
                    child: const _FeatureRow(),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // TAGLINE
                // ==================================================
                FadeTransition(
                  opacity: _fade(0.58, 1.0),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.eco_outlined,
                        size: 17,
                        color: Color(0xFF43A047),
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Protecting Every Drop',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2385B8),
                        ),
                      ),
                      SizedBox(width: 7),
                      Icon(
                        Icons.water_drop_outlined,
                        size: 16,
                        color: Color(0xFF43A047),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // LOADING INDICATOR
                // ==================================================
                FadeTransition(
                  opacity: _fade(0.65, 1.0),
                  child: AnimatedBuilder(
                    animation: _loading,
                    builder: (context, _) {
                      return _LoadingIndicator(value: _loading.value);
                    },
                  ),
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// SOFT BACKGROUND
// ==================================================================

class _SoftBackground extends StatelessWidget {
  const _SoftBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE9F6FC), Color(0xFFF9FCFE), Color(0xFFE0F2FA)],
          stops: [0.0, 0.58, 1.0],
        ),
      ),
    );
  }
}

// ==================================================================
// SOFT BUBBLES
// ==================================================================

class _SoftBubblesPainter extends CustomPainter {
  final double t;

  _SoftBubblesPainter(this.t);

  final List<_Bubble> bubbles = const [
    _Bubble(x: 0.13, y: 0.18, radius: 7, speed: 1.0),
    _Bubble(x: 0.86, y: 0.22, radius: 5, speed: 0.8),
    _Bubble(x: 0.08, y: 0.56, radius: 4, speed: 1.2),
    _Bubble(x: 0.92, y: 0.52, radius: 7, speed: 0.9),
    _Bubble(x: 0.75, y: 0.10, radius: 3, speed: 1.1),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;

    for (final bubble in bubbles) {
      final movement = sin((t * 2 * pi * bubble.speed) + bubble.x * pi) * 8;

      final x = size.width * bubble.x;

      final y = size.height * bubble.y + movement;

      fill.color = const Color(0xFF5AB6E8).withOpacity(0.08);

      canvas.drawCircle(Offset(x, y), bubble.radius, fill);
    }
  }

  @override
  bool shouldRepaint(covariant _SoftBubblesPainter oldDelegate) {
    return true;
  }
}

class _Bubble {
  final double x;
  final double y;
  final double radius;
  final double speed;

  const _Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
  });
}

// ==================================================================
// NATURAL WATER
// ==================================================================

class _NaturalWaterPainter extends CustomPainter {
  final double t;

  _NaturalWaterPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;

    final height = size.height;

    // --------------------------------------------------------------
    // First soft wave
    // --------------------------------------------------------------

    _drawWave(
      canvas,
      size,
      phase: t,
      y: height * 0.35,
      amplitude: 9,
      color: const Color(0xFFB9E3F6),
      opacity: 0.65,
    );

    // --------------------------------------------------------------
    // Second wave
    // --------------------------------------------------------------

    _drawWave(
      canvas,
      size,
      phase: t + 0.35,
      y: height * 0.47,
      amplitude: 12,
      color: const Color(0xFF8FD1EF),
      opacity: 0.55,
    );

    // --------------------------------------------------------------
    // Main water layer
    // --------------------------------------------------------------

    final path = Path();

    path.moveTo(0, height * 0.60);

    for (double x = 0; x <= width; x += 8) {
      final wave = sin((x / width * 2 * pi) + t * 2 * pi) * 12;

      path.lineTo(x, height * 0.60 + wave);
    }

    path.lineTo(width, height);

    path.lineTo(0, height);

    path.close();

    canvas.drawPath(
      path,
      Paint()..color = const Color(0xFF67BCE6).withOpacity(0.30),
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double phase,
    required double y,
    required double amplitude,
    required Color color,
    required double opacity,
  }) {
    final path = Path();

    path.moveTo(0, y);

    for (double x = 0; x <= size.width; x += 8) {
      final wave = sin((x / size.width * 2 * pi) + phase * 2 * pi) * amplitude;

      path.lineTo(x, y + wave);
    }

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    canvas.drawPath(path, Paint()..color = color.withOpacity(opacity));
  }

  @override
  bool shouldRepaint(covariant _NaturalWaterPainter oldDelegate) {
    return true;
  }
}

// ==================================================================
// NATURAL LOGO
// ==================================================================

class _NaturalLogo extends StatelessWidget {
  final double size;

  const _NaturalLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: Colors.white.withOpacity(0.62),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF42A5D8).withOpacity(0.14),

            blurRadius: 28,

            spreadRadius: 4,
          ),
        ],
      ),

      child: CustomPaint(painter: _NaturalLogoPainter()),
    );
  }
}

class _NaturalLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;

    final h = size.height;

    // ============================================================
    // SHIELD
    // ============================================================

    final shield = Path();

    shield.moveTo(w * 0.50, h * 0.08);

    shield.cubicTo(w * 0.69, h * 0.14, w * 0.84, h * 0.17, w * 0.88, h * 0.19);

    shield.lineTo(w * 0.88, h * 0.53);

    shield.cubicTo(w * 0.88, h * 0.76, w * 0.69, h * 0.90, w * 0.50, h * 0.96);

    shield.cubicTo(w * 0.31, h * 0.90, w * 0.12, h * 0.76, w * 0.12, h * 0.53);

    shield.lineTo(w * 0.12, h * 0.19);

    shield.cubicTo(w * 0.22, h * 0.16, w * 0.38, h * 0.12, w * 0.50, h * 0.08);

    shield.close();

    final shieldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeJoin = StrokeJoin.round
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1976C9), Color(0xFF42B5E8)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(shield, shieldPaint);

    // ============================================================
    // WATER DROP
    // ============================================================

    final drop = Path();

    final cx = w * 0.48;

    final top = h * 0.25;

    drop.moveTo(cx, top);

    drop.cubicTo(
      cx + w * 0.13,
      top + h * 0.16,
      cx + w * 0.15,
      top + h * 0.30,
      cx,
      top + h * 0.37,
    );

    drop.cubicTo(
      cx - w * 0.15,
      top + h * 0.30,
      cx - w * 0.13,
      top + h * 0.16,
      cx,
      top,
    );

    drop.close();

    final dropPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF6DD0F4), Color(0xFF1976C5)],
      ).createShader(Rect.fromLTWH(w * 0.30, h * 0.20, w * 0.36, h * 0.45));

    canvas.drawPath(drop, dropPaint);

    // ============================================================
    // DROP HIGHLIGHT
    // ============================================================

    final highlight = Paint()..color = Colors.white.withOpacity(0.62);

    canvas.drawOval(
      Rect.fromLTWH(w * 0.425, h * 0.37, w * 0.055, h * 0.10),
      highlight,
    );

    // ============================================================
    // LEAF
    // ============================================================

    final leaf = Path();

    leaf.moveTo(w * 0.55, h * 0.67);

    leaf.quadraticBezierTo(w * 0.68, h * 0.54, w * 0.78, h * 0.61);

    leaf.quadraticBezierTo(w * 0.69, h * 0.74, w * 0.55, h * 0.67);

    leaf.close();

    final leafPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
      ).createShader(Rect.fromLTWH(w * 0.53, h * 0.53, w * 0.28, h * 0.25));

    canvas.drawPath(leaf, leafPaint);

    // Leaf vein

    final vein = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 1.3;

    canvas.drawLine(
      Offset(w * 0.56, h * 0.67),
      Offset(w * 0.74, h * 0.62),
      vein,
    );
  }

  @override
  bool shouldRepaint(covariant _NaturalLogoPainter oldDelegate) {
    return false;
  }
}

// ==================================================================
// WATER DIVIDER
// ==================================================================

class _WaterDivider extends StatelessWidget {
  const _WaterDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Container(width: 70, height: 1, color: const Color(0xFFB7DDED)),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 9),
          child: Icon(
            Icons.water_drop_outlined,
            size: 14,
            color: Color(0xFF42A5D8),
          ),
        ),

        Container(width: 70, height: 1, color: const Color(0xFFB7DDED)),
      ],
    );
  }
}

// ==================================================================
// FEATURE ROW
// ==================================================================

class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: const [
        _Feature(
          icon: Icons.water_drop_outlined,
          title: 'Monitor',
          subtitle: 'Water Quality',
        ),

        _FeatureDivider(),

        _Feature(
          icon: Icons.verified_outlined,
          title: 'Detect',
          subtitle: 'Impurities',
        ),

        _FeatureDivider(),

        _Feature(
          icon: Icons.notifications_none_rounded,
          title: 'Alert',
          subtitle: 'Early Warning',
        ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,

      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.72),

              shape: BoxShape.circle,

              border: Border.all(color: const Color(0xFFA7D7ED), width: 1),
            ),

            child: Icon(icon, size: 22, color: const Color(0xFF1976B9)),
          ),

          const SizedBox(height: 7),

          Text(
            title,

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF145B91),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 10.5, color: Color(0xFF7290A6)),
          ),
        ],
      ),
    );
  }
}

class _FeatureDivider extends StatelessWidget {
  const _FeatureDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,

      margin: const EdgeInsets.symmetric(horizontal: 4),

      color: const Color(0xFFC6E2F0),
    );
  }
}

// ==================================================================
// LOADING INDICATOR
// ==================================================================

class _LoadingIndicator extends StatelessWidget {
  final double value;

  const _LoadingIndicator({required this.value});

  @override
  Widget build(BuildContext context) {
    final active = (value * 3).floor() % 3;

    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        for (int i = 0; i < 3; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),

            margin: const EdgeInsets.symmetric(horizontal: 3),

            width: i == active ? 18 : 6,

            height: 6,

            decoration: BoxDecoration(
              color: i == active
                  ? const Color(0xFF238BC1)
                  : const Color(0xFFB9DCEB),

              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}
