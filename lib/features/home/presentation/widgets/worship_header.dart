import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';

class WorshipHeader extends StatelessWidget {
  const WorshipHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = context.watch<ThemeProvider>();

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: themeProvider.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: themeProvider.cardBorderColor),
          ),
          child: Icon(Icons.mosque_rounded, color: colorScheme.primary, size: 22.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'قسم العبادات',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: themeProvider.primaryText,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'تقبّل الله طاعتكم وذكركم',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(fontSize: 9.sp, color: themeProvider.secondaryText),
              ),
            ],
          ),
        ),
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: themeProvider.cardColor,
            border: Border.all(color: themeProvider.cardBorderColor),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.notifications_outlined, color: themeProvider.primaryText, size: 20.sp),
            onPressed: () {
              // TODO: إجراء التنبيهات
            },
          ),
        ),
      ],
    );
  }
}