import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';

class WorshipCategorySelector extends StatelessWidget {
  final List<String> categories;
  final int selectedCategory;
  final ValueChanged<int> onCategorySelected;

  const WorshipCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = context.watch<ThemeProvider>();

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        reverse: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final selected = selectedCategory == index;

          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(horizontal: 19.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? colorScheme.primary : themeProvider.cardColor,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: selected ? colorScheme.primary : themeProvider.cardBorderColor,
                ),
              ),
              child: Text(
                categories[index],
                textDirection: TextDirection.rtl,
                style: GoogleFonts.cairo(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : themeProvider.secondaryText,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}