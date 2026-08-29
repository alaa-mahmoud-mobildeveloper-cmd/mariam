import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/theme/app_colors.dart';

class GiftWelcomeScreen extends StatefulWidget {
  final String recipientName;
  final String senderName;

  const GiftWelcomeScreen({
    super.key,
    required this.recipientName,
    this.senderName = 'من تمنى أن يكون رفيق الدرب 🤍',
  });

  @override
  State<GiftWelcomeScreen> createState() => _GiftWelcomeScreenState();
}

class _GiftWelcomeScreenState extends State<GiftWelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _floatingController;
  late final AnimationController _buttonController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _messageSlide;
  late final Animation<double> _buttonFade;

  String _visibleName = '';
  Timer? _nameTimer;

  static const String _message =
      'إلى مريم... رفيقة الدرب، وسكن القلب.\n\n'
      'أدعو الله أن يبارك في علمكِ، ويفتح لكِ فتوح العارفين، وأن يرزقكِ التوفيق في كل خطوةٍ تخطينها نحو حلمكِ بأن تكوني "مهندسة" تبني وتُعمّرُ في الأرض.\n\n'
      'سألت الله أن يسدد خطاكِ في دراستكِ وعملكِ، وأن يجعل التميز والنجاح رفيقيكِ، وأن يكتب لكِ مستقبلاً مشرقاً يليق بذكائكِ وطموح قلبكِ الطاهر.';

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startNameAnimation();
  }

  void _initAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );

    _messageSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.42, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.70, 1.0, curve: Curves.easeOut),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _mainController.forward();
  }

  void _startNameAnimation() {
    _nameTimer?.cancel();
    final characters = widget.recipientName.characters.toList();
    int index = 0;

    _nameTimer = Timer.periodic(
      const Duration(milliseconds: 180),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (index >= characters.length) {
          timer.cancel();
          return;
        }
        setState(() {
          _visibleName += characters[index];
        });
        index++;
      },
    );
  }

  @override
  void dispose() {
    _nameTimer?.cancel();
    _mainController.dispose();
    _floatingController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _GiftBackground(isDark: isDark)),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GiftLightPainter(primaryColor: colorScheme.primary),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GiftPatternPainter(primaryColor: colorScheme.primary),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _GiftParticlesPainter(
                      progress: _floatingController.value,
                      primaryColor: colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 25.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.h),
                      _RecipientSection(
                        fadeAnimation: _fadeAnimation,
                        visibleName: _visibleName,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      SizedBox(height: 28.h),
                      _MessageCard(
                        fadeAnimation: _fadeAnimation,
                        messageSlide: _messageSlide,
                        message: _message,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      SizedBox(height: 16.h),
                      _SenderSection(
                        fadeAnimation: _buttonFade,
                        senderName: widget.senderName,
                        primaryColor: colorScheme.primary,
                      ),
                      SizedBox(height: 25.h),
                      _DividerSection(
                        buttonFade: _buttonFade,
                        primaryColor: colorScheme.primary,
                      ),
                      SizedBox(height: 32.h),
                      _StartButtonSection(
                        buttonFade: _buttonFade,
                        buttonController: _buttonController,
                        colorScheme: colorScheme,
                        onPressed: () {
                          // Navigate to the next screen or perform any action
                          Navigator.pushReplacementNamed(context, '/home'); // Example navigation
                        },
                      ),
                      SizedBox(height: 25.h),
                      _FooterSection(
                        buttonFade: _buttonFade,
                        isDark: isDark,
                      ),
                    ],
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

// ==================================================================
// SUB-WIDGETS (COMPONENTS)
// ==================================================================

class _RecipientSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final String visibleName;
  final ColorScheme colorScheme;
  final bool isDark;

  const _RecipientSection({
    required this.fadeAnimation,
    required this.visibleName,
    required this.colorScheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textMuted = isDark ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;

    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          Text(
            'مريم',
            textDirection: TextDirection.rtl,
            style: GoogleFonts.amiri(
              fontSize: 65.sp,
              fontWeight: FontWeight.w700,
              height: 1.30,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'إلى',
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 11.sp, color: textMuted),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.ltr,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.15),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      visibleName.isEmpty ? ' ' : visibleName,
                      key: ValueKey(visibleName),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lobsterTwo(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.30,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: 140.w,
            height: 1,
            color: colorScheme.primary.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> messageSlide;
  final String message;
  final ColorScheme colorScheme;
  final bool isDark;

  const _MessageCard({
    required this.fadeAnimation,
    required this.messageSlide,
    required this.message,
    required this.colorScheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;
    final borderColor = isDark ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
    final textColor = colorScheme.onSurface.withValues(alpha: 0.85);

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: messageSlide,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: cardBg.withValues(alpha: isDark ? 0.6 : 0.8),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            message,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.9,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _SenderSection extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final String senderName;
  final Color primaryColor;

  const _SenderSection({
    required this.fadeAnimation,
    required this.senderName,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            senderName,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w600,
              color: primaryColor.withValues(alpha: 0.9),
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerSection extends StatelessWidget {
  final Animation<double> buttonFade;
  final Color primaryColor;

  const _DividerSection({
    required this.buttonFade,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: buttonFade,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 55.w, height: 1, color: primaryColor.withValues(alpha: 0.22)),
          SizedBox(width: 9.w),
          Icon(Icons.auto_awesome_rounded, size: 13.sp, color: primaryColor),
          SizedBox(width: 9.w),
          Container(width: 55.w, height: 1, color: primaryColor.withValues(alpha: 0.22)),
        ],
      ),
    );
  }
}

class _StartButtonSection extends StatelessWidget {
  final Animation<double> buttonFade;
  final AnimationController buttonController;
  final ColorScheme colorScheme;
  final VoidCallback onPressed;

  const _StartButtonSection({
    required this.buttonFade,
    required this.buttonController,
    required this.colorScheme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: buttonFade,
      child: AnimatedBuilder(
        animation: buttonController,
        builder: (context, child) {
          final value = Curves.easeInOut.transform(buttonController.value);
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(
                    alpha: 0.08 + (value * 0.10),
                  ),
                  blurRadius: 22 + (value * 8),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: child,
          );
        },
        child: SizedBox(
          width: 210.w,
          height: 52.h,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ابدأ رحلتك',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward_ios_rounded, size: 19.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final Animation<double> buttonFade;
  final bool isDark;

  const _FooterSection({
    required this.buttonFade,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textMuted = isDark ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;

    return FadeTransition(
      opacity: buttonFade,
      child: Text(
        'جعل الله أيامك مليئة بالخير والطمأنينة 🤍',
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8.5.sp,
          color: textMuted,
          height: 1.5,
        ),
      ),
    );
  }
}

// ==================================================================
// PAINTERS & BACKGROUND
// ==================================================================

class _GiftBackground extends StatelessWidget {
  final bool isDark;

  const _GiftBackground({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppCustomColors.darkBackground : AppCustomColors.lightBackground;
    final cardBg = isDark ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        gradient: RadialGradient(
          center: const Alignment(0, -0.35),
          radius: 1.25,
          colors: [cardBg, bgColor, bgColor],
        ),
      ),
    );
  }
}

class _GiftLightPainter extends CustomPainter {
  final Color primaryColor;

  _GiftLightPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [primaryColor.withValues(alpha: 0.08), Colors.transparent],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height * 0.25),
          radius: size.width * 0.85,
        ),
      );

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _GiftLightPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }
}

class _GiftPatternPainter extends CustomPainter {
  final Color primaryColor;

  _GiftPatternPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withValues(alpha: 0.025)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    const spacing = 70.0;

    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        final center = Offset(x, y);
        final path = Path();

        for (int i = 0; i < 8; i++) {
          final angle = (math.pi * 2 / 8) * i;
          final point = Offset(
            center.dx + math.cos(angle) * 16,
            center.dy + math.sin(angle) * 16,
          );

          if (i == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GiftPatternPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }
}

class _GiftParticlesPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;

  _GiftParticlesPainter({
    required this.progress,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final movement = math.sin(progress * math.pi * 2 + i) * 8;
      final y = baseY + movement;
      final radius = random.nextDouble() * 1.4 + 0.4;
      final opacity = 0.08 + random.nextDouble() * 0.30;

      final paint = Paint()
        ..color = primaryColor.withValues(alpha: opacity);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GiftParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor;
  }
}