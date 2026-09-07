import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/home/data/models/daily_task.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';

class TaskItem extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const TaskItem({
    super.key,
    required this.task,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isReligious = task.isReligious;
    final isMissed = task.status == TaskStatus.missed;
    final accent = isMissed
        ? Colors.redAccent
        : (isReligious ? const Color(0xFFC75B9B) : const Color(0xFF5B8DEF));

    return GestureDetector(
      onTap: isMissed ? null : onTap,
      onLongPress: isMissed ? null : onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isMissed ? Colors.redAccent.withOpacity(0.05) : themeProvider.cardColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isMissed ? Colors.redAccent.withOpacity(0.25) : themeProvider.cardBorderColor,
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: themeProvider.dividerColor, width: 1.5),
              ),
              child: isMissed
                  ? Icon(Icons.close_rounded, size: 14.sp, color: Colors.redAccent)
                  : null,
            ),
            SizedBox(width: 12.w),
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.13),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(task.icon, size: 19.sp, color: accent),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: isMissed ? themeProvider.secondaryText : themeProvider.primaryText,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    task.category,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 9.sp, color: themeProvider.secondaryText),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6.w),
            if (isMissed)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'لم يتم الإنجاز',
                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w700, color: Colors.redAccent),
                ),
              )
            else
              Text(
                task.formattedTime,
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: themeProvider.secondaryText),
              ),
          ],
        ),
      ),
    );
  }
}