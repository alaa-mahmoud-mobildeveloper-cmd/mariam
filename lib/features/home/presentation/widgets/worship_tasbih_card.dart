import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';

class WorshipTasbihCard extends StatelessWidget {
  final int count;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const WorshipTasbihCard({
    super.key,
    required this.count,
    required this.color,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: themeProvider.cardBorderColor),
      ),
      child: Column(
        children: [
          Text(
            'السبحة الإلكترونية',
            style: GoogleFonts.cairo(fontSize: 13.sp, fontWeight: FontWeight.w700, color: themeProvider.primaryText),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 130.w,
              height: 130.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [color, color.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                boxShadow: [BoxShadow(color: color.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 38.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          TextButton.icon(
            onPressed: onReset,
            icon: Icon(Icons.refresh_rounded, size: 15, color: themeProvider.secondaryText),
            label: Text('إعادة تصفير', style: GoogleFonts.cairo(color: themeProvider.secondaryText, fontSize: 11.5.sp)),
          ),
        ],
      ),
    );
  }
}