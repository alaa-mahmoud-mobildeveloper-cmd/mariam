import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/theme/app_colors.dart';

class DailyVerseCard extends StatelessWidget {
  const DailyVerseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppCustomColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: colorScheme.primary,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'آية اليوم',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.bookmark_border_rounded,
                size: 20.sp,
                color: AppCustomColors.darkTextMuted,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا۝ إِنَّ مَعَ الْعُسْرِ يُسْرًا',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 20.sp,
              height: 1.8,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 14.h),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: const Color(0xFF221A2C),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'سورة الشرح • 5 - 6',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 10.sp,
                  color: AppCustomColors.darkTextMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}