import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';

class WorshipDhikrCard extends StatelessWidget {
  final String dhikrText;
  final String repeatLabel;
  final VoidCallback? onTap;

  const WorshipDhikrCard({
    super.key,
    this.dhikrText = 'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
    this.repeatLabel = 'ردّدها 100 مرة',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = context.watch<ThemeProvider>();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(19.w),
        decoration: BoxDecoration(
          color: themeProvider.cardColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: themeProvider.cardBorderColor),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(shape: BoxShape.circle, color: colorScheme.primary.withOpacity(0.12)),
              child: Icon(Icons.auto_awesome_rounded, color: colorScheme.primary, size: 22.sp),
            ),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ذكر اليوم',
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(fontSize: 10.sp, fontWeight: FontWeight.w600, color: colorScheme.primary),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    dhikrText,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(fontSize: 15.sp, fontWeight: FontWeight.w700, color: themeProvider.primaryText),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    repeatLabel,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(fontSize: 8.sp, color: themeProvider.secondaryText),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_ios_rounded, size: 13.sp, color: themeProvider.secondaryText),
          ],
        ),
      ),
    );
  }
}