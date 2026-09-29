import 'package:flutter/material.dart';

/// Wraps any child in a looping vertical "antigravity" hover animation.
/// The child gently floats up and down like it's in zero gravity.
class AntigravityHover extends StatefulWidget {
  final Widget child;

  /// Total vertical displacement in logical pixels.
  final double amplitude;

  /// Duration of one full float cycle.
  final Duration period;

  /// Phase offset (0.0–1.0) so multiple hovered widgets drift out of sync.
  final double phaseOffset;

  const AntigravityHover({
    super.key,
    required this.child,
    this.amplitude = 10.0,
    this.period = const Duration(milliseconds: 2200),
    this.phaseOffset = 0.0,
  });

  @override
  State<AntigravityHover> createState() => _AntigravityHoverState();
}

class _AntigravityHoverState extends State<AntigravityHover>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.period)
      ..repeat(reverse: true);
    if (widget.phaseOffset > 0) {
      _ctrl.value = widget.phaseOffset;
    }
    _anim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        final dy = (_anim.value - 0.5) * widget.amplitude;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: widget.child,
    );
  }
}

/// Custom PathVision Logo Widget — stylized "P" with an eye integrated,
/// matching the Figma reference: bold black "P" with a blue eye iris.
class PathVisionLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const PathVisionLogo({
    super.key,
    this.size = 80,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showText) {
      return Image.asset(
        'assets/images/pathvision_logo.jpeg',
        width: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _LogoPainter(),
            ),
          );
        },
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(size * 0.10),
      child: Image.asset(
        'assets/images/pathvision_logo.jpeg',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            width: size,
            height: size,
            child: CustomPaint(painter: _LogoPainter()),
          );
        },
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Black "P" body ────────────────────────────────────────────────────────
    final pPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;

    // Vertical stem of the P
    final stemPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.05, w * 0.22, h * 0.90),
        Radius.circular(w * 0.06),
      ));
    canvas.drawPath(stemPath, pPaint);

    // Bump / bowl of the P (right semicircle)
    final bumpPath = Path();
    bumpPath.moveTo(w * 0.18, h * 0.05);
    bumpPath.lineTo(w * 0.65, h * 0.05);
    bumpPath.cubicTo(
      w * 1.00, h * 0.05,
      w * 1.00, h * 0.55,
      w * 0.65, h * 0.55,
    );
    bumpPath.lineTo(w * 0.18, h * 0.55);
    bumpPath.close();
    canvas.drawPath(bumpPath, pPaint);

    // ── Eye cut-out & iris ───────────────────────────────────────────────────
    // White sclera / almond eye shape
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final eyeCx = w * 0.60;
    final eyeCy = h * 0.30;
    final eyeRx = w * 0.26;
    final eyeRy = h * 0.13;

    final eyePath = _almondPath(eyeCx, eyeCy, eyeRx, eyeRy);
    canvas.drawPath(eyePath, eyePaint);

    // Blue iris
    final irisPaint = Paint()
      ..color = const Color(0xFF1565C0)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(eyeCx, eyeCy),
      eyeRy * 0.80,
      irisPaint,
    );

    // Light-blue highlight
    final highlightPaint = Paint()
      ..color = const Color(0xFF42A5F5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(eyeCx - eyeRy * 0.18, eyeCy - eyeRy * 0.22),
      eyeRy * 0.30,
      highlightPaint,
    );

    // Dark pupil
    final pupilPaint = Paint()
      ..color = const Color(0xFF0D1B2A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(eyeCx, eyeCy),
      eyeRy * 0.38,
      pupilPaint,
    );

    // Eyelash curves (top)
    final lashPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.025
      ..strokeCap = StrokeCap.round;

    final topLash = Path()
      ..moveTo(eyeCx - eyeRx, eyeCy)
      ..cubicTo(
        eyeCx - eyeRx * 0.5, eyeCy - eyeRy * 2.2,
        eyeCx + eyeRx * 0.5, eyeCy - eyeRy * 2.2,
        eyeCx + eyeRx, eyeCy,
      );
    canvas.drawPath(topLash, lashPaint);
  }

  /// Returns an almond/eye shaped closed path.
  Path _almondPath(double cx, double cy, double rx, double ry) {
    final path = Path();
    path.moveTo(cx - rx, cy);
    path.cubicTo(
      cx - rx * 0.5, cy - ry * 1.5,
      cx + rx * 0.5, cy - ry * 1.5,
      cx + rx, cy,
    );
    path.cubicTo(
      cx + rx * 0.5, cy + ry * 1.5,
      cx - rx * 0.5, cy + ry * 1.5,
      cx - rx, cy,
    );
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
