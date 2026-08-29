import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/theme/app_colors.dart';

class DailyProgressCard extends StatelessWidget {
  const DailyProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF261426),
            Color(0xFF140B16),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: colorScheme.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'يومك يا بشمهندسة مريم',
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.cairo(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'خطوة صغيرة كل يوم 🌸',
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: AppCustomColors.darkTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '65%',
                style: GoogleFonts.cairo(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                '4 من 6 مهام مكتملة',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  color: AppCustomColors.darkTextMuted,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: 0.65,
              minHeight: 8.h,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                size: 16.sp,
                color: colorScheme.secondary,
              ),
              SizedBox(width: 5.w),
              Text(
                '7 أيام متتالية',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}