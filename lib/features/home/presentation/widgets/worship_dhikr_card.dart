import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/theme/app_colors.dart';

class WorshipDhikrCard extends StatelessWidget {
  const WorshipDhikrCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(19.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1422),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppCustomColors.darkBorder),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2B1D35),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: colorScheme.primary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ذكر اليوم',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'ردّدها 100 مرة',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(
                    fontSize: 8.sp,
                    color: AppCustomColors.darkTextMuted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13.sp,
            color: AppCustomColors.darkTextMuted,
          ),
        ],
      ),
    );
  }
}