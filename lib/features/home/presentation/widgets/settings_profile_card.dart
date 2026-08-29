import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // تدرج ألوان متناسق مع الـ ColorScheme يعكس جو التطبيق
    final gradientColors = isDark
        ? [colorScheme.primary.withValues(alpha: 0.25), colorScheme.surface]
        : [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.85)];

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.0),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          // أيقونة المستخدم الدائرية
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.secondary.withValues(alpha: 0.2),
              border: Border.all(
                color: colorScheme.secondary.withValues(alpha: 0.4),
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              color: colorScheme.secondary,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 14.w),

          // النصوص (أهلاً بك وصاحب الهدية)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلًا بك 👋',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: isDark
                        ? colorScheme.onSurface.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  ' بشمهندسة مريم',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // أيقونة جمالية إضافية
          Icon(
            Icons.auto_awesome_rounded,
            color: colorScheme.secondary,
            size: 22.sp,
          ),
        ],
      ),
    );
  }
}