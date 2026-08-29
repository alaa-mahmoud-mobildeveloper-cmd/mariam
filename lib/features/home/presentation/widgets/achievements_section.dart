import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';

import 'section_title.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SectionTitle(title: 'إنجازاتك'),
        SizedBox(height: 12.h),
        Row(
          textDirection: TextDirection.rtl,
          children: const [
            Expanded(
              child: AchievementItem(
                icon: Icons.wb_sunny_rounded,
                title: 'بداية جميلة',
                subtitle: 'أكملت أول عبادة',
                active: true,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: AchievementItem(
                icon: Icons.local_fire_department,
                title: '7 أيام',
                subtitle: 'أسبوع كامل',
                active: true,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: AchievementItem(
                icon: Icons.menu_book_rounded,
                title: 'قارئ',
                subtitle: '100 صفحة',
                active: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AchievementItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;

  const AchievementItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final cardBg = isDark ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg;
    final borderColor = isDark ? AppCustomColors.darkBorder : AppCustomColors.lightBorder;
    final textMuted = isDark ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: active ? cardBg : cardBg.withValues(alpha: isDark ? 0.4 : 0.6),
        borderRadius: BorderRadius.circular(19.r),
        border: Border.all(
          color: active ? borderColor : borderColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : textMuted.withValues(alpha: 0.1),
            ),
            child: Icon(
              icon,
              size: 21.sp,
              color: active ? colorScheme.primary : textMuted,
            ),
          ),
          SizedBox(height: 9.h),
          Text(
            title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: active ? colorScheme.onSurface : textMuted,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            subtitle,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 6.5.sp, color: textMuted),
          ),
        ],
      ),
    );
  }
}