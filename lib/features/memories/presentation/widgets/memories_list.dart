import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';
import '../providers/memories_provider.dart';
import 'memories_empty_state.dart';
import 'memories_header_card.dart';
import 'memory_card.dart';
import 'staggered_fade_slide.dart';

class MemoriesList extends StatelessWidget {
  final VoidCallback onAdd;

  const MemoriesList({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final memoriesProvider = context.watch<MemoriesProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final primary = isDark ? const Color(0xFFFFB6D9) : const Color(0xFFFF80BF);

    switch (memoriesProvider.status) {
      case MemoriesStatus.initial:
      case MemoriesStatus.loading:
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: CircularProgressIndicator(color: primary),
          ),
        );

      case MemoriesStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Text(
              memoriesProvider.errorMessage ?? 'حدث خطأ ما',
              style: TextStyle(color: themeProvider.secondaryText),
            ),
          ),
        );

      case MemoriesStatus.loaded:
        final memories = memoriesProvider.memories;
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
          children: [
            StaggeredFadeSlide(
              index: 0,
              child: MemoriesHeaderCard(
                isDark: isDark,
                primary: primary,
                memoriesCount: memories.length,
              ),
            ),
            const SizedBox(height: 26),
            if (memories.isEmpty)
              MemoriesEmptyState(onAdd: onAdd)
            else
              ...List.generate(memories.length, (index) {
                return StaggeredFadeSlide(
                  index: index + 1,
                  child: MemoryCard(
                    memory: memories[index],
                    isFirst: index == 0,
                    isLast: index == memories.length - 1,
                  ),
                );
              }),
          ],
        );
    }
  }
}