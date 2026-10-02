import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mariam/features/tasks/presentation/providers/tasks_provider.dart';


class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final cardBg = isDark ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;
    final borderColor = isDark ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
    final textMuted = isDark ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;
    final tasks = context.watch<TasksProvider>().tasks.where((task) => task.completed).toList();
    var streak = 0;
    var cursor = DateTime.now();
    while (tasks.any((task) => task.date.year == cursor.year && task.date.month == cursor.month && task.date.day == cursor.day)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

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
                  streak == 0 ? 'ابدئي بإكمال مهمة اليوم لبناء سلسلة الالتزام' : 'أكملت مهامك لمدة $streak أيام متتالية',
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
                '$streak',
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
