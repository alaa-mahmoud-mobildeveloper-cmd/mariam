import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/theme/app_colors.dart';

class WorshipHeader extends StatelessWidget {
  const WorshipHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppCustomColors.darkBorder),
          ),
          child: Icon(
            Icons.mosque_rounded,
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
                'قسم العبادات',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'تقبّل الله طاعتكم وذكركم',
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 9.sp,
                  color: AppCustomColors.darkTextMuted,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface,
            border: Border.all(color: AppCustomColors.darkBorder),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 20.sp,
            ),
            onPressed: () {
              // يمكنك إضافة إجراء التنبيهات هنا
            },
          ),
        ),
      ],
    );
  }
}