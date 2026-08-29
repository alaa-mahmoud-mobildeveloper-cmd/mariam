import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';


class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 12.h),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: themeProvider.cardColor,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: themeProvider.cardBorderColor),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 18.sp,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            'الإعدادات',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: themeProvider.cardBorderColor),
            ),
            child: Icon(
              Icons.settings_rounded,
              color: colorScheme.primary,
              size: 23.sp,
            ),
          ),
        ],
      ),
    );
  }
}