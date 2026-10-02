import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mariam/features/home/presentation/providers/tasks_provider.dart';

class WeeklyChartCard extends StatelessWidget {
  const WeeklyChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final cardBg = isDark ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;
    final borderColor = isDark ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
    final textMuted = isDark ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;

    final tasks = context.watch<TasksProvider>().tasks;
    final today = DateTime.now();
    final data = List<double>.generate(7, (index) {
      final date = DateTime(today.year, today.month, today.day).subtract(Duration(days: 6 - index));
      final dayTasks = tasks.where((task) => task.date.year == date.year && task.date.month == date.month && task.date.day == date.day).toList();
      return dayTasks.isEmpty ? 0.0 : dayTasks.where((task) => task.completed).length / dayTasks.length;
    });
    final days = ['س', 'ج', 'خ', 'أ', 'ث', 'ن', 'ر'];

    return Container(
      height: 205.h,
      padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 12.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(23.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'نسبة الإنجاز',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 9.sp, color: textMuted),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                data.length,
                    (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${(data[index] * 100).round()}%',
                            style: TextStyle(
                              fontSize: 7.sp,
                              fontWeight: FontWeight.w600,
                              color: textMuted,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: data[index],
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  width: 18.w,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [colorScheme.primary, colorScheme.secondary],
                                    ),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            days[index],
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
