import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/theme/app_colors.dart';

class HomeBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF130E1B),
        border: Border(
          top: BorderSide(
            color: AppCustomColors.darkBorder,
            width: 1.h,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarItem(
                icon: Icons.home_rounded,
                title: 'الرئيسية',
                active: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              NavBarItem(
                icon: Icons.check_circle_outline_rounded,
                title: 'المهام',
                active: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              NavBarItem(
                icon: Icons.favorite_border_rounded,
                title: 'عباداتي',
                active: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              NavBarItem(
                icon: Icons.photo_library_rounded, // ✅ اتغيّرت
                title: 'الذكريات',
                active: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              NavBarItem(
                icon: Icons.settings_suggest_rounded,
                title: 'الإعدادات',
                active: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.title,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: active
              ? colorScheme.primary.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: active ? colorScheme.primary : AppCustomColors.darkTextMuted,
            ),
            SizedBox(height: 3.h),
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 9.sp,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? colorScheme.primary : AppCustomColors.darkTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}