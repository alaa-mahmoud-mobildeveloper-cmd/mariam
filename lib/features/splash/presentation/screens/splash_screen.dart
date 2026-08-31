import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/routes/route_app.dart';
import 'package:mariam/features/gift/presentation/screens/gift_welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _masterController;
  late final AnimationController _ambientController;

  late final Animation<double> _revealAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<double> _shimmerAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOut),
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -1.5, end: 2.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeInOutSine),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _ambientController,
        curve: Curves.easeInOut,
      ),
    );

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _ambientController,
        curve: Curves.easeInOut,
      ),
    );

    _masterController.forward();

    Timer(const Duration(seconds: 20), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const GiftWelcomeScreen(
            recipientName: 'Eng:🥰Mariam Ahmed',
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _masterController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  Widget _buildFloatingIcon(
      BuildContext context, {
        required IconData icon,
        required double size,
        required double left,
        required double baseTop,
        required double phase,
      }) {
    final sizeObj = MediaQuery.sizeOf(context);

    final movementY =
        math.sin((_ambientController.value * math.pi * 2) + phase) * 20.h;
    final movementX =
        math.cos((_ambientController.value * math.pi * 2) + phase) * 10.w;

    final opacity =
        (math.sin((_ambientController.value * math.pi) + phase) + 1) / 2;

    return Positioned(
      left: (sizeObj.width * left) + movementX,
      top: (sizeObj.height * baseTop) + movementY,
      child: Opacity(
        opacity: 0.05 + (opacity * 0.15),
        child: Transform.rotate(
          angle: movementX * 0.05,
          child: Icon(
            icon,
            size: size,
            color: const Color(0xFFFF66B2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.2),
                radius: 1.35,
                colors: [
                  Color(0xFF1F0B14),
                  Color(0xFF10050A),
                  Color(0xFF030102),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Center(
                child: Container(
                  width: (320 * _pulseAnimation.value).w,
                  height: (320 * _pulseAnimation.value).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFF66B2)
                            .withValues(alpha: 0.12 * (_pulseAnimation.value / 1.2)),
                        const Color(0xFFFF66B2).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _ambientController,
            builder: (context, child) {
              return Stack(
                children: [
                  _buildFloatingIcon(context, icon: Icons.favorite, size: 22.w, left: 0.15, baseTop: 0.25, phase: 0.0),
                  _buildFloatingIcon(context, icon: Icons.star_rounded, size: 28.w, left: 0.8, baseTop: 0.15, phase: 1.5),
                  _buildFloatingIcon(context, icon: Icons.circle, size: 10.w, left: 0.25, baseTop: 0.75, phase: 2.0),
                  _buildFloatingIcon(context, icon: Icons.favorite_border, size: 24.w, left: 0.75, baseTop: 0.65, phase: 3.14),
                  _buildFloatingIcon(context, icon: Icons.star_outline_rounded, size: 32.w, left: 0.45, baseTop: 0.10, phase: 0.8),
                  _buildFloatingIcon(context, icon: Icons.circle_outlined, size: 14.w, left: 0.4, baseTop: 0.85, phase: 2.5),
                  _buildFloatingIcon(context, icon: Icons.favorite, size: 16.w, left: 0.85, baseTop: 0.40, phase: 4.0),
                  _buildFloatingIcon(context, icon: Icons.star_rounded, size: 18.w, left: 0.1, baseTop: 0.55, phase: 5.5),
                ],
              );
            },
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _masterController,
              builder: (context, child) {
                return Opacity(
                  opacity: _revealAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Stack(
                      children: [
                        // 1. خريطة فلسطين في الأعلى
                        Positioned(
                          top: 70.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation.value),
                                  child: Image.asset(
                                    'assets/image/p2.png',
                                    width: 380.w,
                                    height: 420.h,
                                    color: const Color(0xFFFF66B2),
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // 2. النصوص قريبة جداً من أسفل الخريطة مباشرة
                        Positioned(
                          top: 360.h,
                          left: 24.w,
                          right: 24.w,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: const [
                                      Color(0xFFFFFFFF),
                                      Color(0xFFFF80BF),
                                      Color(0xFFD91A72),
                                      Color(0xFFFF80BF),
                                      Color(0xFFFFFFFF),
                                    ],
                                    stops: [
                                      0.0,
                                      (_shimmerAnimation.value - 0.3)
                                          .clamp(0.0, 1.0),
                                      _shimmerAnimation.value.clamp(0.0, 1.0),
                                      (_shimmerAnimation.value + 0.3)
                                          .clamp(0.0, 1.0),
                                      1.0,
                                    ],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.srcIn,
                                child: Text(
                                  'مريم',
                                  textDirection: TextDirection.rtl,
                                  style: GoogleFonts.amiri(
                                    fontSize: 65.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.30,
                                  ),
                                ),
                              ),

                              SizedBox(height: 12.h),

                              Opacity(
                                opacity: _textFadeAnimation.value,
                                child: Container(
                                  width: 36.w,
                                  height: 1.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFFFF66B2)
                                            .withValues(alpha: 0.0),
                                        const Color(0xFFFF66B2),
                                        const Color(0xFFFF66B2)
                                            .withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20.h),

                              Opacity(
                                opacity: _textFadeAnimation.value,
                                child: Text(
                                  'وَريحُ يُوسُفَ لَا تَأْتِي نَسَائِمُهَا ... إِلَّا لِقَلْبٍ هَوَاهُ كَانَ يَعْقُوبَا',
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.reemKufi(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFF7D1E3),
                                    height: 1.4,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textFadeAnimation,
              child: Center(
                child: SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFFFF66B2).withValues(alpha: 0.55),
                    ),
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