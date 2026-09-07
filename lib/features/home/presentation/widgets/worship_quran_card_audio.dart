import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/audio_quran/presentation/screen/audio_screen.dart';

class WorshipQuranCardAudio extends StatelessWidget {
  const WorshipQuranCardAudio({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AudioScreen(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.headphones_rounded,
                  color: colorScheme.onPrimary,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الاستماع إلى القرآن',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'استمع إلى تلاوات القرآن الكريم',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: colorScheme.onPrimary.withValues(alpha: 0.75),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: colorScheme.onPrimary,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
