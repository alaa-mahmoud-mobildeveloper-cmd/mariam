import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mariam/core/theme/app_colors.dart';

class DailyVerseCard extends StatelessWidget {
  final String verse;
  final String surahName;
  final int? ayahNumber;

  const DailyVerseCard({
    super.key,
    this.verse = 'لا توجد آية متاحة حاليًا',
    this.surahName = '',
    this.ayahNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final reference = [
      if (surahName.trim().isNotEmpty) surahName.trim(),
      if (ayahNumber != null) 'آية $ayahNumber',
    ].join(' • ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppCustomColors.darkBorder,
        ),
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
                  color: colorScheme.onSurface,
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
            verse,
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
          if (reference.isNotEmpty)
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  reference,
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
