// ============================================================
// JalRakshak — Smart Water Quality Monitoring — Splash Screen
// 100% code-drawn (no image/svg assets)
// ============================================================

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'language_screen.dart';

// ============================================================
// SPLASH SCREEN
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Entrance animation
  late final AnimationController _entrance;

  // Continuous ambient loop
  late final AnimationController _ambient;

  // Falling drop + ripple loop
  late final AnimationController _dropLoop;

  // Loading dots + page indicator
  late final AnimationController _loadingLoop;

  // Timer for moving to LanguageScreen
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // ----------------------------------------------------------
    // Entrance animation
    // ----------------------------------------------------------

    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    // ----------------------------------------------------------
    // Ambient animation
    // ----------------------------------------------------------

    _ambient = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // ----------------------------------------------------------
    // Falling water drop animation
    // ----------------------------------------------------------

    _dropLoop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    // ----------------------------------------------------------
    // Loading dots animation
    // ----------------------------------------------------------

    _loadingLoop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    // ----------------------------------------------------------
    // MOVE TO LANGUAGE SCREEN AFTER 4 SECONDS
    // ----------------------------------------------------------

    _timer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LanguageScreen()),
      );
    });
  }

  @override
  void dispose() {
    // Cancel navigation timer
    _timer?.cancel();

    // Dispose animation controllers
    _entrance.dispose();
    _ambient.dispose();
    _dropLoop.dispose();
    _loadingLoop.dispose();

    super.dispose();
  }

  // ============================================================
  // ANIMATION HELPERS
  // ============================================================

  Animation<double> _fade(double start, double end) => CurvedAnimation(
    parent: _entrance,
    curve: Interval(start, end, curve: Curves.easeOut),
  );

  Animation<Offset> _slideUp(double start, double end) =>
      Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _entrance,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ------------------------------------------------------
          // BACKGROUND
          // ------------------------------------------------------
          const _BackgroundGradient(),

          // ------------------------------------------------------
          // FLOATING BUBBLES
          // ------------------------------------------------------
          AnimatedBuilder(
            animation: _ambient,
            builder: (context, _) {
              return CustomPaint(painter: _BubblesPainter(_ambient.value));
            },
          ),

          // ------------------------------------------------------
          // WATER WAVES + RIPPLES
          // ------------------------------------------------------
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: Listenable.merge([_ambient, _dropLoop]),
              builder: (context, _) {
                return CustomPaint(
                  size: Size(size.width, size.height * 0.32),
                  painter: _WaterPainter(
                    wavePhase: _ambient.value,
                    dropProgress: _dropLoop.value,
                  ),
                );
              },
            ),
          ),

          // ------------------------------------------------------
          // FALLING WATER DROP
          // ------------------------------------------------------
          Align(
            alignment: const Alignment(0, 0.32),
            child: AnimatedBuilder(
              animation: _dropLoop,
              builder: (context, _) {
                return _FallingDrop(progress: _dropLoop.value);
              },
            ),
          ),

          // ------------------------------------------------------
          // MAIN CONTENT
          // ------------------------------------------------------
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // ------------------------------------------------
                // LOGO
                // ------------------------------------------------
                FadeTransition(
                  opacity: _fade(0.0, 0.5),
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _entrance,
                      curve: const Interval(
                        0.0,
                        0.55,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: const _ShieldLogo(size: 180),
                  ),
                ),

                const SizedBox(height: 18),

                // ------------------------------------------------
                // TITLE
                // ------------------------------------------------
                FadeTransition(
                  opacity: _fade(0.25, 0.65),
                  child: SlideTransition(
                    position: _slideUp(0.25, 0.65),
                    child: const Text(
                      'JalRakshak',
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ------------------------------------------------
                // SUBTITLE
                // ------------------------------------------------
                FadeTransition(
                  opacity: _fade(0.35, 0.7),
                  child: SlideTransition(
                    position: _slideUp(0.35, 0.7),
                    child: const Text(
                      'Smart Water Quality Monitoring',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF5C7A9C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ------------------------------------------------
                // DROP DIVIDER
                // ------------------------------------------------
                FadeTransition(
                  opacity: _fade(0.4, 0.75),
                  child: const _DropDivider(),
                ),

                const Spacer(flex: 5),

                // ------------------------------------------------
                // FEATURES
                // ------------------------------------------------
                FadeTransition(
                  opacity: _fade(0.5, 0.9),
                  child: SlideTransition(
                    position: _slideUp(0.5, 0.9),
                    child: const _FeatureRow(),
                  ),
                ),

                const SizedBox(height: 22),

                // ------------------------------------------------
                // PROTECTING EVERY DROP
                // ------------------------------------------------
                FadeTransition(
                  opacity: _fade(0.55, 1.0),
                  child: const _ProtectingRow(),
                ),

                const SizedBox(height: 18),

                // ------------------------------------------------
                // PAGE DOTS
                // ------------------------------------------------
                FadeTransition(
                  opacity: _fade(0.6, 1.0),
                  child: AnimatedBuilder(
                    animation: _loadingLoop,
                    builder: (context, _) {
                      return _PageDots(t: _loadingLoop.value);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ------------------------------------------------
                // LOADING TEXT
                // ------------------------------------------------
                FadeTransition(
                  opacity: _fade(0.65, 1.0),
                  child: AnimatedBuilder(
                    animation: _loadingLoop,
                    builder: (context, _) {
                      return _LoadingText(t: _loadingLoop.value);
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

// ============================================================
// BACKGROUND GRADIENT
// ============================================================

class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEAF6FD), Color(0xFFF5FBFF), Color(0xFFDDF0FB)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ============================================================
// FLOATING BUBBLES
// ============================================================

class _BubblesPainter extends CustomPainter {
  final double t;

  _BubblesPainter(this.t);

  final List<_BubbleSpec> _bubbles = const [
    _BubbleSpec(dx: 0.19, dy0: 0.14, r: 9, drift: 10),
    _BubbleSpec(dx: 0.17, dy0: 0.20, r: 6, drift: 14),
    _BubbleSpec(dx: 0.71, dy0: 0.07, r: 4, drift: 8),
    _BubbleSpec(dx: 0.80, dy0: 0.24, r: 7, drift: 12),
    _BubbleSpec(dx: 0.13, dy0: 0.48, r: 5, drift: 9),
    _BubbleSpec(dx: 0.89, dy0: 0.51, r: 8, drift: 11),
    _BubbleSpec(dx: 0.85, dy0: 0.60, r: 5, drift: 7),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paintFill = Paint()..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    for (final b in _bubbles) {
      final phase = (t + b.dx) % 1.0;

      final floatOffset = sin(phase * 2 * pi) * b.drift;

      final cx = size.width * b.dx;

      final cy = size.height * b.dy0 + floatOffset;

      final opacity = 0.35 + 0.25 * sin(phase * 2 * pi);

      paintFill.color = const Color(0xFF7FC4EE).withOpacity(opacity * 0.25);

      paintStroke.color = const Color(0xFF6BB8EA).withOpacity(opacity);

      canvas.drawCircle(Offset(cx, cy), b.r, paintFill);

      canvas.drawCircle(Offset(cx, cy), b.r, paintStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblesPainter oldDelegate) {
    return true;
  }
}

class _BubbleSpec {
  final double dx;
  final double dy0;
  final double r;
  final double drift;

  const _BubbleSpec({
    required this.dx,
    required this.dy0,
    required this.r,
    required this.drift,
  });
}

// ============================================================
// SHIELD LOGO
// ============================================================

class _ShieldLogo extends StatelessWidget {
  final double size;

  const _ShieldLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ShieldPainter()),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ----------------------------------------------------------
    // SHIELD
    // ----------------------------------------------------------

    final shieldPath = Path();

    shieldPath.moveTo(w * 0.5, h * 0.03);

    shieldPath.cubicTo(
      w * 0.5,
      h * 0.03,
      w * 0.78,
      h * 0.14,
      w * 0.92,
      h * 0.16,
    );

    shieldPath.lineTo(w * 0.92, h * 0.52);

    shieldPath.cubicTo(
      w * 0.92,
      h * 0.78,
      w * 0.72,
      h * 0.93,
      w * 0.5,
      h * 1.0,
    );

    shieldPath.cubicTo(
      w * 0.28,
      h * 0.93,
      w * 0.08,
      h * 0.78,
      w * 0.08,
      h * 0.52,
    );

    shieldPath.lineTo(w * 0.08, h * 0.16);

    shieldPath.cubicTo(
      w * 0.22,
      h * 0.14,
      w * 0.5,
      h * 0.03,
      w * 0.5,
      h * 0.03,
    );

    shieldPath.close();

    final shieldShader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1565C0), Color(0xFF29B6F6)],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final shieldPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeJoin = StrokeJoin.round
      ..shader = shieldShader;

    canvas.drawPath(shieldPath, shieldPaint);

    // ----------------------------------------------------------
    // WATER DROP
    // ----------------------------------------------------------

    final dropCenterX = w * 0.46;
    final dropTopY = h * 0.26;

    final dropWidth = w * 0.30;
    final dropHeight = h * 0.40;

    final dropPath = Path();

    dropPath.moveTo(dropCenterX, dropTopY);

    dropPath.cubicTo(
      dropCenterX + dropWidth * 0.55,
      dropTopY + dropHeight * 0.55,
      dropCenterX + dropWidth * 0.42,
      dropTopY + dropHeight,
      dropCenterX,
      dropTopY + dropHeight,
    );

    dropPath.cubicTo(
      dropCenterX - dropWidth * 0.42,
      dropTopY + dropHeight,
      dropCenterX - dropWidth * 0.55,
      dropTopY + dropHeight * 0.55,
      dropCenterX,
      dropTopY,
    );

    dropPath.close();

    final dropShader =
        const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF64C6F1), Color(0xFF0B72C4)],
        ).createShader(
          Rect.fromLTWH(
            dropCenterX - dropWidth,
            dropTopY,
            dropWidth * 2,
            dropHeight,
          ),
        );

    canvas.drawPath(dropPath, Paint()..shader = dropShader);

    // ----------------------------------------------------------
    // DROP HIGHLIGHT
    // ----------------------------------------------------------

    final highlight = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(
        dropCenterX - dropWidth * 0.16,
        dropTopY + dropHeight * 0.32,
        dropWidth * 0.22,
        dropHeight * 0.28,
      ),
      highlight,
    );

    // ----------------------------------------------------------
    // LEAF
    // ----------------------------------------------------------

    final leafOrigin = Offset(w * 0.62, h * 0.66);

    _drawLeaf(canvas, leafOrigin, w * 0.22, -0.35);

    _drawLeaf(canvas, leafOrigin + Offset(w * 0.05, h * 0.03), w * 0.16, 0.25);
  }

  void _drawLeaf(Canvas canvas, Offset origin, double length, double angle) {
    canvas.save();

    canvas.translate(origin.dx, origin.dy);

    canvas.rotate(angle);

    final leafPath = Path();

    leafPath.moveTo(0, 0);

    leafPath.quadraticBezierTo(length * 0.5, -length * 0.45, length, 0);

    leafPath.quadraticBezierTo(length * 0.5, length * 0.25, 0, 0);

    leafPath.close();

    final leafPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
      ).createShader(Rect.fromLTWH(0, -length * 0.4, length, length * 0.6));

    canvas.drawPath(leafPath, leafPaint);

    final veinPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset.zero,
      Offset(length * 0.85, -length * 0.05),
      veinPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// DIVIDER WITH DROP
// ============================================================

class _DropDivider extends StatelessWidget {
  const _DropDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _line(),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.water_drop, size: 12, color: Color(0xFF29B6F6)),
        ),

        _line(),
      ],
    );
  }

  Widget _line() {
    return Container(width: 90, height: 1.2, color: const Color(0xFFB9DFF4));
  }
}

// ============================================================
// FALLING DROP
// ============================================================

class _FallingDrop extends StatelessWidget {
  final double progress;

  const _FallingDrop({required this.progress});

  @override
  Widget build(BuildContext context) {
    const fallEnd = 0.55;

    if (progress > fallEnd) {
      return const SizedBox.shrink();
    }

    final fallT = Curves.easeIn.transform(progress / fallEnd);

    final dy = -90 + fallT * 90;

    final opacity = progress < 0.05
        ? progress / 0.05
        : (1 - (progress / fallEnd)).clamp(0.0, 1.0) * 0.8 + 0.2;

    return Transform.translate(
      offset: Offset(0, dy),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: const CustomPaint(
          size: Size(26, 34),
          painter: _MiniDropPainter(),
        ),
      ),
    );
  }
}

class _MiniDropPainter extends CustomPainter {
  const _MiniDropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();

    path.moveTo(w / 2, 0);

    path.cubicTo(w * 1.0, h * 0.55, w * 0.8, h, w / 2, h);

    path.cubicTo(w * 0.2, h, 0, h * 0.55, w / 2, 0);

    path.close();

    final shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF7FD3F5), Color(0xFF1E88C7)],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(path, Paint()..shader = shader);

    canvas.drawOval(
      Rect.fromLTWH(w * 0.32, h * 0.35, w * 0.18, h * 0.22),
      Paint()..color = Colors.white.withOpacity(0.6),
    );
  }

  @override
  bool shouldRepaint(covariant _MiniDropPainter oldDelegate) {
    return false;
  }
}

// ============================================================
// WATER SURFACE
// ============================================================

class _WaterPainter extends CustomPainter {
  final double wavePhase;
  final double dropProgress;

  _WaterPainter({required this.wavePhase, required this.dropProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ----------------------------------------------------------
    // WAVES
    // ----------------------------------------------------------

    _drawWave(canvas, size, wavePhase, h * 0.30, const Color(0xFFBEE6FA), 14);

    _drawWave(
      canvas,
      size,
      wavePhase + 0.3,
      h * 0.40,
      const Color(0xFF9BD8F3),
      18,
    );

    _drawWave(
      canvas,
      size,
      wavePhase + 0.6,
      h * 0.55,
      const Color(0xFF6FC3EC),
      22,
    );

    // ----------------------------------------------------------
    // RIPPLES
    // ----------------------------------------------------------

    const splashStart = 0.55;

    if (dropProgress >= splashStart) {
      final rt = (dropProgress - splashStart) / (1 - splashStart);

      final center = Offset(w / 2, h * 0.30);

      for (int i = 0; i < 3; i++) {
        final ringT = (rt - i * 0.12).clamp(0.0, 1.0);

        if (ringT <= 0) continue;

        final radius = ringT * w * 0.28;

        final opacity = (1 - ringT) * 0.5;

        final ringPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..color = const Color(0xFF1E88C7).withOpacity(opacity);

        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: radius * 2,
            height: radius * 0.55,
          ),
          ringPaint,
        );
      }
    }
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double phase,
    double y,
    Color color,
    double amp,
  ) {
    final w = size.width;

    final path = Path();

    path.moveTo(0, y);

    for (double x = 0; x <= w; x += 8) {
      final rad = (x / w * 2 * pi) + phase * 2 * pi;

      final yOff = sin(rad) * amp;

      path.lineTo(x, y + yOff);
    }

    path.lineTo(w, size.height);

    path.lineTo(0, size.height);

    path.close();

    canvas.drawPath(path, Paint()..color = color.withOpacity(0.85));
  }

  @override
  bool shouldRepaint(covariant _WaterPainter oldDelegate) {
    return true;
  }
}

// ============================================================
// FEATURE ROW
// ============================================================

class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _FeatureItem(
          icon: Icons.water_drop_outlined,
          title: 'Monitor',
          subtitle: 'Water Quality',
        ),

        _divider(),

        const _FeatureItem(
          icon: Icons.verified_user_outlined,
          title: 'Detect',
          subtitle: 'Impurities',
        ),

        _divider(),

        const _FeatureItem(
          icon: Icons.notifications_none_rounded,
          title: 'Alert',
          subtitle: 'In Real Time',
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: const Color(0xFFBFE0F2),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.6),
              border: Border.all(color: const Color(0xFF9FD5EF), width: 1.4),
            ),
            child: Icon(icon, color: const Color(0xFF1565C0), size: 24),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
              color: Color(0xFF0D47A1),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6E8CA8)),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROTECTING EVERY DROP
// ============================================================

class _ProtectingRow extends StatelessWidget {
  const _ProtectingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.energy_savings_leaf, size: 16, color: Color(0xFF43A047)),

        SizedBox(width: 8),

        Text(
          'Protecting Every Drop',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E88C7),
          ),
        ),

        SizedBox(width: 8),

        Icon(Icons.energy_savings_leaf, size: 16, color: Color(0xFF43A047)),
      ],
    );
  }
}

// ============================================================
// PAGE INDICATOR DOTS
// ============================================================

class _PageDots extends StatelessWidget {
  final double t;

  const _PageDots({required this.t});

  @override
  Widget build(BuildContext context) {
    const dotCount = 4;

    final active = (t * dotCount).floor() % dotCount;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(dotCount, (i) {
        final isActive = i == active;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive ? const Color(0xFF1E88C7) : const Color(0xFFBFE0F2),
          ),
        );
      }),
    );
  }
}

// ============================================================
// LOADING TEXT
// ============================================================

class _LoadingText extends StatelessWidget {
  final double t;

  const _LoadingText({required this.t});

  @override
  Widget build(BuildContext context) {
    final dotCount = 1 + ((t * 3).floor() % 3);

    final dots = '.' * dotCount;

    return Text(
      'Loading$dots',
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF8FAAC4),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
