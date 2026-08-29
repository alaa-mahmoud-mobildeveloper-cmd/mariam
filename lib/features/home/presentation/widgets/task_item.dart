import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';

class TaskItem extends StatelessWidget {
  final Map<String, dynamic> task;
  final VoidCallback onTap;

  const TaskItem({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // استخراج البيانات من الـ Map مع التأكد من النوع
    final String title = task['title'] ?? '';
    final String category = task['category'] ?? '';
    final String time = task['time'] ?? '';
    final IconData icon = task['icon'] ?? Icons.task_alt_rounded;
    final bool completed = task['completed'] ?? false;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(13.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: completed
                ? colorScheme.primary.withValues(alpha: 0.4)
                : (isDarkMode ? AppCustomColors.darkBorder : AppCustomColors.lightBorder),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.25 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: completed ? colorScheme.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: completed
                      ? colorScheme.primary
                      : (isDarkMode ? AppCustomColors.darkBorder : AppCustomColors.lightBorder),
                  width: 1.5,
                ),
              ),
              child: completed
                  ? Icon(Icons.check_rounded, size: 16.sp, color: colorScheme.onPrimary)
                  : null,
            ),
            SizedBox(width: 12.w),
            // Icon Container
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                icon,
                size: 21.sp,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(width: 11.w),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: completed
                          ? (isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted)
                          : colorScheme.onSurface,
                      decoration: completed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Text(
                          category,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.secondary,
                          ),
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Icon(
                        Icons.access_time_rounded,
                        size: 11.sp,
                        color: isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        time,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 7.w),
            Icon(
              Icons.more_vert_rounded,
              size: 20.sp,
              color: isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted,
            ),
          ],
        ),
      ),
    );
  }
}