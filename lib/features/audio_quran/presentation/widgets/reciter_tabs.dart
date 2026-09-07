import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReciterTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ReciterTabs({super.key, required this.selectedIndex, required this.onChanged});

  static const names = ['المنشاوي', 'محمود البنا', 'الحصري'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 52.h,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(17.r)),
      child: Row(
        textDirection: TextDirection.rtl,
        children: names.asMap().entries.map((entry) {
          final selected = selectedIndex == entry.key;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: selected ? colors.primary : Colors.transparent, borderRadius: BorderRadius.circular(13.r)),
                child: Text(entry.value, textDirection: TextDirection.rtl, style: TextStyle(fontSize: 11.sp, fontWeight: selected ? FontWeight.w800 : FontWeight.w500, color: selected ? colors.onPrimary : colors.onSurface.withValues(alpha: 0.6))),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
