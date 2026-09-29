import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/pathvision_logo.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Smooth Fade & Slide Page Route Transition
// ─────────────────────────────────────────────────────────────────────────────
class OrbitPageRoute<T> extends PageRouteBuilder<T> {
  OrbitPageRoute({required Widget page})
      : super(
          transitionDuration: const Duration(milliseconds: 700),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (ctx, anim, secAnim) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final inCurve =
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            final outCurve =
                CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn);

            return Stack(
              children: [
                FadeTransition(
                  opacity: Tween<double>(begin: 1, end: 0).animate(outCurve),
                  child: const SizedBox.expand(),
                ),
                FadeTransition(
                  opacity: inCurve,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 0.04), end: Offset.zero)
                        .animate(inCurve),
                    child: child,
                  ),
                ),
              ],
            );
          },
        );
}

// ─────────────────────────────────────────────────────────────────────────────
// Splash Screen
// ─────────────────────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _contentFade;
  late Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // 1. Logo fades and slides smoothly
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.60, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Brand name, HRMS badge, and tagline fade in
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
      ),
    );

    // 3. Footer & pulsing indicators fade in
    _footerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.60, 1.0, curve: Curves.easeIn),
      ),
    );

    _entryCtrl.forward();

    // Auto-navigate to login screen after 2.8 seconds
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFCEE8FB), // Soft corporate sky blue
              Color(0xFFE8F4FD),
              Color(0xFFF7FAFD),
              Color(0xFFFFFFFF), // Pure white
            ],
            stops: [0.0, 0.30, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ── Decorative background concentric rings ─────────────────────
            const Positioned.fill(child: _OrbitRingsPainter()),

            // ── Main Centered Content ──────────────────────────────────────
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── 1. Logo at top center with subtle floating animation ──
                    FadeTransition(
                      opacity: _logoFade,
                      child: SlideTransition(
                        position: _logoSlide,
                        child: AntigravityHover(
                          amplitude: 8,
                          period: const Duration(milliseconds: 2600),
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1565C0).withAlpha(35),
                                  blurRadius: 32,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 10),
                                ),
                                BoxShadow(
                                  color: Colors.white.withAlpha(220),
                                  blurRadius: 6,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/images/pathvision_logo.jpeg',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const PathVisionLogo(size: 80),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── 2. Brand Name in Solid Black Text ───────────────────
                    FadeTransition(
                      opacity: _contentFade,
                      child: Text(
                        'PathVision Innovations',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0D1B2A), // Strong solid black/navy
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── 3. Blue Rounded Rectangle with "HRMS" ──────────────
                    FadeTransition(
                      opacity: _contentFade,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1246A8),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1565C0).withAlpha(70),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'HRMS',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 3.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── 4. Tagline: "Engineering-First HRMS in Motion" ───────
                    FadeTransition(
                      opacity: _contentFade,
                      child: Text(
                        'Engineering-First HRMS in Motion',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF546E7A),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 5. Footer: Version 'v1.0.0' + Subtle Pulsing Loader ─────────
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _footerFade,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _PulsingDots(),
                    const SizedBox(height: 12),
                    Text(
                      'v1.0.0',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF90A4AE), // Subtle gray
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated Pulsing Loading Dots
// ─────────────────────────────────────────────────────────────────────────────
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final phase = ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
            final opacity = math.sin(phase * math.pi).clamp(0.15, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3.5),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Color.fromRGBO(21, 101, 192, opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Decorative Concentric Orbit Rings (subtle background motif)
// ─────────────────────────────────────────────────────────────────────────────
class _OrbitRingsPainter extends StatelessWidget {
  const _OrbitRingsPainter();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _RingsPainter());
  }
}

class _RingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.42;

    for (final r in [85.0, 135.0, 190.0]) {
      final paint = Paint()
        ..color = const Color(0xFF90CAF9).withAlpha((0.14 * 255).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
