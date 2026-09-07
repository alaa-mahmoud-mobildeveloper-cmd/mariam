import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioHeroCard extends StatelessWidget {
  final VoidCallback onTap;

  const AudioHeroCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(26.r),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [colors.primary, colors.primary.withValues(alpha: 0.78)], begin: Alignment.topRight, end: Alignment.bottomLeft),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [BoxShadow(color: colors.primary.withValues(alpha: 0.22), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Container(width: 62.w, height: 62.w, decoration: BoxDecoration(color: colors.onPrimary.withValues(alpha: 0.16), shape: BoxShape.circle), child: Icon(Icons.play_arrow_rounded, color: colors.onPrimary, size: 38.sp)),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('تلاوة الآن', textDirection: TextDirection.rtl, style: TextStyle(color: colors.onPrimary.withValues(alpha: 0.78), fontSize: 12.sp)),
                SizedBox(height: 4.h),
                Text('سورة الفاتحة', textDirection: TextDirection.rtl, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: colors.onPrimary, fontSize: 17.sp, fontWeight: FontWeight.w800)),
                SizedBox(height: 9.h),
                Text('تلاوة عطرة من كتاب الله الكريم', textDirection: TextDirection.rtl, style: TextStyle(color: colors.onPrimary.withValues(alpha: 0.7), fontSize: 10.sp)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
