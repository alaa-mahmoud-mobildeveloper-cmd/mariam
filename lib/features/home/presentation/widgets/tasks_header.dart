import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';


class TasksHeader extends StatelessWidget {
  const TasksHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(17.r),
            border: Border.all(
              color: isDarkMode ? AppCustomColors.darkBorder : AppCustomColors.lightBorder,
            ),
          ),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: colorScheme.primary,
            size: 25.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'مهامي',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'خطوات صغيرة تصنع يومًا أجمل',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}