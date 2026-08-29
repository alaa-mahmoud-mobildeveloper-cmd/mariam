import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';

class MotivationCard extends StatelessWidget {
  const MotivationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final cardBg = isDark ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;
    final borderColor = isDark ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
    final textMuted = isDark ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(23.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote_rounded,
            size: 25.sp,
            color: colorScheme.primary,
          ),
          SizedBox(height: 5.h),
          Text(
            'وَاذْكُر رَّبَّكَ إِذَا نَسِيتَ',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'كل خطوة تخطوها تقرّبك أكثر.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9.sp, color: textMuted),
          ),
        ],
      ),
    );
  }
}