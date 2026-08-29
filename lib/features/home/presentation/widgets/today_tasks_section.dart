import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/theme/app_colors.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Text(
              'مهام اليوم',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'عرض الكل',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        const TaskItemTile(
          title: 'أذكار الصباح',
          subtitle: 'عبادة',
          icon: Icons.wb_sunny_outlined,
          completed: true,
        ),
        SizedBox(height: 8.h),
        const TaskItemTile(
          title: 'قراءة ورد القرآن',
          subtitle: 'قرآن',
          icon: Icons.menu_book_rounded,
          completed: true,
        ),
        SizedBox(height: 8.h),
        const TaskItemTile(
          title: 'صلاة الضحى',
          subtitle: 'صلاة',
          icon: Icons.mosque_outlined,
          completed: false,
        ),
        SizedBox(height: 8.h),
        const TaskItemTile(
          title: 'قراءة سورة الكهف',
          subtitle: 'قرآن',
          icon: Icons.auto_stories_outlined,
          completed: false,
        ),
      ],
    );
  }
}

class TaskItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool completed;

  const TaskItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppCustomColors.darkBorder),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: completed
                  ? colorScheme.primary.withOpacity(0.15)
                  : const Color(0xFF221A2C),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: 18.sp,
              color: completed ? colorScheme.primary : AppCustomColors.darkTextMuted,
            ),
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
                    fontWeight: FontWeight.w600,
                    color: completed ? AppCustomColors.darkTextMuted : Colors.white,
                    decoration: completed ? TextDecoration.lineThrough : null,
                    decorationColor: AppCustomColors.darkTextMuted,
                  ),
                ),
                Text(
                  subtitle,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    fontSize: 9.sp,
                    color: AppCustomColors.darkTextMuted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 22.sp,
            color: completed ? colorScheme.primary : const Color(0xFF4A3A54),
          ),
        ],
      ),
    );
  }
}