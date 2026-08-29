import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/app_colors.dart';

class TasksFilters extends StatelessWidget {
  final List<String> filters;
  final int selectedFilter;
  final ValueChanged<int> onFilterSelected;

  const TasksFilters({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        reverse: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final selected = selectedFilter == index;

          return GestureDetector(
            onTap: () => onFilterSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(horizontal: 19.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? colorScheme.primary
                    : (isDarkMode ? AppCustomColors.darkCardBg : AppCustomColors.lightCardBg),
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: selected
                      ? colorScheme.primary
                      : (isDarkMode ? AppCustomColors.darkBorder : AppCustomColors.lightBorder),
                ),
              ),
              child: Text(
                filters[index],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? colorScheme.onPrimary
                      : (isDarkMode ? AppCustomColors.darkTextMuted : AppCustomColors.lightTextMuted),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}