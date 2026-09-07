import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';

class WorshipQuranCard extends StatelessWidget {
  final int pagesRead;
  final int dailyGoal;
  final Color color;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const WorshipQuranCard({
    super.key,
    required this.pagesRead,
    required this.dailyGoal,
    required this.color,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final progress = dailyGoal == 0 ? 0.0 : (pagesRead / dailyGoal).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: themeProvider.cardBorderColor),
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14.r)),
                child: Icon(Icons.menu_book_rounded, color: color, size: 21.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'ورد القرآن اليومي',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: themeProvider.primaryText),
                ),
              ),
              Text(
                '$pagesRead/$dailyGoal',
                style: GoogleFonts.cairo(fontSize: 15.sp, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDecrement,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: themeProvider.cardBorderColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  icon: Icon(Icons.remove_rounded, size: 16.sp, color: themeProvider.secondaryText),
                  label: Text('صفحة', style: GoogleFonts.cairo(fontSize: 11.sp, color: themeProvider.secondaryText)),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onIncrement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                  label: Text('صفحة', style: GoogleFonts.cairo(fontSize: 11.sp, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}