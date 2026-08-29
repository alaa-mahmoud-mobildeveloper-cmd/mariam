import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';

class TasksEmptyState extends StatelessWidget {
  const TasksEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isDarkMode ? AppCustomColors.darkBorder : AppCustomColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 45.sp,
            color: isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted,
          ),
          SizedBox(height: 12.h),
          Text(
            'لا توجد مهام هنا',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'ابدئي بإضافة مهمة جديدة ليومك',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 9.sp,
              color: isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}