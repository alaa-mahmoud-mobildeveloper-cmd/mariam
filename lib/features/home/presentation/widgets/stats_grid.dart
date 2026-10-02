import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mariam/features/tasks/presentation/providers/tasks_provider.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TasksProvider>().tasks;
    final completed = tasks.where((task) => task.completed).length;
    final activeDays = tasks.where((task) => task.completed).map((task) => '${task.date.year}-${task.date.month}-${task.date.day}').toSet().length;
    final progress = tasks.isEmpty ? 0 : (completed / tasks.length * 100).round();
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10.w,
      mainAxisSpacing: 10.h,
      childAspectRatio: 1.65,
      children: [
        StatCard(
          icon: Icons.check_circle_rounded,
          title: 'عبادات مكتملة',
          value: '$completed',
          subtitle: 'إجمالي المهام',
          color: Color(0xFF21845F),
        ),
        StatCard(
          icon: Icons.local_fire_department_rounded,
          title: 'أيام متتالية',
          value: '$activeDays',
          subtitle: 'أيام نشطة',
          color: Color(0xFFD18D39),
        ),
        StatCard(
          icon: Icons.menu_book_rounded,
          title: 'صفحات القرآن',
          value: '${tasks.length}',
          subtitle: 'إجمالي المهام',
          color: Color(0xFF557D9A),
        ),
        StatCard(
          icon: Icons.favorite_rounded,
          title: 'الأذكار',
          value: '$progress%',
          subtitle: 'نسبة الإنجاز',
          color: Color(0xFF9B6685),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final cardBg = isDark ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;
    final borderColor = isDark ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
    final textMuted = isDark ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 8.sp, color: textMuted),
                ),
                SizedBox(height: 3.h),
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        subtitle,
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 7.sp, color: textMuted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
