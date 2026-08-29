import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';


class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final cardBg = isDark ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;
    final borderColor = isDark ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
    final textMuted = isDark ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(23.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 53.w,
            height: 53.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withValues(alpha: 0.15),
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: colorScheme.primary,
              size: 27.sp,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'سلسلة الالتزام',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'أكملت عباداتك لمدة 7 أيام متتالية',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 8.sp, color: textMuted),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            children: [
              Text(
                '7',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                'يوم',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 7.sp, color: textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}