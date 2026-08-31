import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';
import '../providers/memories_provider.dart';

class MemoriesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MemoriesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final memoriesProvider = context.watch<MemoriesProvider>();
    final isDark = themeProvider.isDarkMode;
    final accent = isDark ? const Color(0xFFFFB6D9) : const Color(0xFFFF80BF);
    final count = memoriesProvider.memories.length;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      toolbarHeight: kToolbarHeight + 14,
      title: Row(
        textDirection: TextDirection.rtl,
        children: [
          // بادچ الأيقونة بتدرج + بريق خفيف
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accent, accent.withOpacity(0.55)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 22),
              ),
              Positioned(
                top: -4,
                left: -4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: themeProvider.backgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: accent.withOpacity(0.5), width: 1.5),
                  ),
                  child: Icon(Icons.auto_awesome_rounded, size: 8, color: accent),
                ),
              ),
            ],
          ),
          const SizedBox(width: 13),

          // العنوان + الوصف الفرعي
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ذكرياتي',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: themeProvider.primaryText,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'أجمل اللحظات المحفوظة للأبد',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: themeProvider.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          // بادچ عدد الذكريات
          if (count > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.collections_bookmark_rounded, size: 13, color: accent),
                  const SizedBox(width: 5),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                themeProvider.dividerColor,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 15);
}