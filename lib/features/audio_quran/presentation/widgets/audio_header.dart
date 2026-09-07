import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioHeader extends StatelessWidget {
  final bool favoritesOnly;
  final ValueChanged<bool> onFavoritesChanged;

  const AudioHeader({
    super.key,
    required this.favoritesOnly,
    required this.onFavoritesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.headphones_rounded, color: colors.primary, size: 24.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('القرآن الكريم', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w800, color: colors.onSurface)),
              SizedBox(height: 3.h),
              Text('استمع إلى كتاب الله بصوت عذب', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 12.sp, color: colors.onSurface.withValues(alpha: 0.55))),
            ],
          ),
        ),
        IconButton(
          onPressed: () => onFavoritesChanged(!favoritesOnly),
          icon: Icon(favoritesOnly ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: favoritesOnly ? const Color(0xFFE978A9) : colors.onSurface),
        ),
      ],
    );
  }
}
