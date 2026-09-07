import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/home/presentation/providers/tasks_provider.dart';
import 'package:provider/provider.dart';
import 'package:mariam/core/theme/theme_provider.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final tasksProvider = context.watch<TasksProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    // في الرئيسية بنعرض بس المهام اللي لسه معلقة ومحدش فاتها وقتها،
    // عشان القسم ده يفضل "قائمة أعمال قادمة" مش سجل فوائت.
    final pending = tasksProvider.pendingTasks.take(3).toList();

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: themeProvider.cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 16.sp, color: colorScheme.primary),
              SizedBox(width: 8.w),
              Text(
                'مهام اليوم',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: themeProvider.primaryText),
              ),
              const Spacer(),
              Text(
                '${tasksProvider.completedCount}/${tasksProvider.totalCount}',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          if (pending.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Icon(Icons.celebration_rounded, size: 18.sp, color: colorScheme.primary),
                  SizedBox(width: 8.w),
                  Text(
                    'خلصتِ كل مهامك اليوم 🎉',
                    style: TextStyle(fontSize: 12.5.sp, color: themeProvider.secondaryText),
                  ),
                ],
              ),
            )
          else
            ...pending.map(
                  (task) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: InkWell(
                  onTap: () => context.read<TasksProvider>().toggleTask(task.id),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: themeProvider.dividerColor, width: 1.5),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(task.icon, size: 16.sp, color: themeProvider.secondaryText),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          task.title,
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.5.sp, color: themeProvider.primaryText),
                        ),
                      ),
                      Text(
                        task.formattedTime,
                        style: TextStyle(fontSize: 10.5.sp, color: themeProvider.secondaryText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}