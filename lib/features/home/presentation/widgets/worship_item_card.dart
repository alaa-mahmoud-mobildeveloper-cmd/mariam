import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/theme/app_colors.dart';

class WorshipItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double progress;
  final bool completed;
  final VoidCallback onTap;

  const WorshipItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.progress,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(13.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(21.r),
          border: Border.all(
            color: completed
                ? colorScheme.primary.withOpacity(0.3)
                : AppCustomColors.darkBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 27.w,
              height: 27.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: completed ? colorScheme.primary : AppCustomColors.darkBorder,
                  width: 1.5,
                ),
              ),
              child: completed
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 17.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(icon, color: color, size: 23.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: completed ? AppCustomColors.darkTextMuted : Colors.white,
                      decoration: completed ? TextDecoration.lineThrough : null,
                      decorationColor: AppCustomColors.darkTextMuted,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    subtitle,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 8.sp,
                      color: AppCustomColors.darkTextMuted,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3.h,
                      backgroundColor: AppCustomColors.darkBorder,
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_ios_rounded, size: 13.sp, color: AppCustomColors.darkTextMuted),
          ],
        ),
      ),
    );
  }
}