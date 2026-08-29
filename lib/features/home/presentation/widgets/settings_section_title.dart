import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSectionTitle extends StatelessWidget {
  final String title;
  final Color? color; // جعلناه اختياري ليتكيف تلقائياً

  const SettingsSectionTitle({
    super.key,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Text(
        title,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w800,
          // إذا لم تُمرر لوناً، سيأخذ لون السطح المتناسق مع الثيم تلقائياً
          color: color ?? colorScheme.onSurface,
        ),
      ),
    );
  }
}