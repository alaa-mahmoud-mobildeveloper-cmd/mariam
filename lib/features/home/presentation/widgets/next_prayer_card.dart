import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mariam/core/theme/app_colors.dart';
import 'package:mariam/features/prayer_times/presentation/providers/prayer_times_provider.dart';

class NextPrayerCard extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final String? period;

  const NextPrayerCard({
    super.key,
    this.prayerName = 'الصلاة القادمة',
    this.prayerTime = '--:--',
    this.period,
  });

  String _getPeriod(String time) {
    if (period != null && period!.trim().isNotEmpty) return period!;
    final match = RegExp(r'^(\d{1,2})').firstMatch(time);
    final hour = int.tryParse(match?.group(1) ?? '');
    if (hour == null) return '';
    return hour >= 12 ? 'مساءً' : 'صباحًا';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final prayerProvider = context.watch<PrayerTimesProvider>();
    final nextPrayer = prayerProvider.nextPrayer;
    final displayedName = nextPrayer?.arabicName ?? (prayerProvider.isLoading ? 'جاري تحميل مواقيت الصلاة' : prayerName);
    final displayedTime = nextPrayer?.time ?? prayerTime;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppCustomColors.darkBorder),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(Icons.mosque_rounded, color: colorScheme.primary, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayerProvider.errorMessage != null && nextPrayer == null ? 'أوقات الصلاة' : 'الصلاة القادمة',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(fontSize: 10.sp, color: AppCustomColors.darkTextMuted),
                ),
                Text(
                  nextPrayer == null && prayerProvider.errorMessage != null ? prayerProvider.errorMessage! : displayedName,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(fontSize: 15.sp, fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(
                  displayedTime,
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.cairo(fontSize: 13.sp, fontWeight: FontWeight.w700, color: colorScheme.primary),
                ),
                Text(
                  nextPrayer == null ? _getPeriod(displayedTime) : 'اليوم',
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.cairo(fontSize: 9.sp, color: AppCustomColors.darkTextMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
