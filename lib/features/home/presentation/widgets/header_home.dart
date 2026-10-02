import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mariam/core/theme/theme_provider.dart';
import 'package:mariam/core/routes/route_app.dart';
import 'package:mariam/features/notifications/presentation/providers/notifications_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final unreadCount = context.watch<NotificationsProvider>().unreadCount;

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        // زر الإشعارات
        Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: themeProvider.dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.notifications_none_rounded, size: 22.sp, color: colorScheme.onSurface),
                if (unreadCount > 0)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      width: unreadCount > 9 ? 16.w : 7.w,
                      height: unreadCount > 9 ? 16.w : 7.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                      child: unreadCount > 9
                          ? Text(unreadCount > 99 ? '99+' : '$unreadCount', style: TextStyle(fontSize: 8.sp, color: Colors.white, fontWeight: FontWeight.bold))
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // الترحيب الشخصي المخصص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مساء الجمال يا🌿',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.secondaryText,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                ' بشمهندسة مريم',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),

        GestureDetector(
          onTap: () {
            context.read<ThemeProvider>().toggleTheme(!isDarkMode);
          },
          child: Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  colorScheme.primary,
                  colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                size: 22.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
