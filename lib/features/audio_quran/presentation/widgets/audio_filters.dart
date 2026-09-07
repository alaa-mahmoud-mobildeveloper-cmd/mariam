import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioSearchField extends StatelessWidget {
  final TextEditingController controller;
  const AudioSearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: 'ابحث في سور القرآن...',
        hintTextDirection: TextDirection.rtl,
        prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(17.r), borderSide: BorderSide.none),
      ),
    );
  }
}

class AudioCategories extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AudioCategories({super.key, required this.categories, required this.selectedIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, index) {
          final selected = selectedIndex == index;
          return ChoiceChip(
            label: Text(categories[index]),
            selected: selected,
            onSelected: (_) => onChanged(index),
            labelStyle: TextStyle(fontSize: 11.sp, color: selected ? colors.onPrimary : colors.onSurface, fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
            selectedColor: colors.primary,
            backgroundColor: Theme.of(context).cardColor,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.r)),
          );
        },
      ),
    );
  }
}
