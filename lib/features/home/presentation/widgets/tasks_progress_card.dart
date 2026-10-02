import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TasksProgressCard extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final double progress;
  final int activeDays;

  const TasksProgressCard({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.progress,
    required this.activeDays,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 22,
            offset: const Offset(0, 9),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: colorScheme.onPrimary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'إنجازك اليوم',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'استمري، أنتِ تقومين بعمل رائع',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: colorScheme.onPrimary.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7.h,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
            ),
          ),
          SizedBox(height: 11.h),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completedCount من $totalCount مهام مكتملة',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 15.sp,
                    color: colorScheme.onPrimary,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    '$activeDays أيام نشطة',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
