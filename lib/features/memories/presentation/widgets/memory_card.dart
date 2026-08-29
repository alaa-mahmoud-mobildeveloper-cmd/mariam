import 'package:flutter/material.dart';
import 'package:mariam/features/memories/presentation/widgets/utils/memory_ui_mapper.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';
import '../../domain/entities/memory.dart';


class MemoryCard extends StatelessWidget {
  final Memory memory;
  final bool isFirst;
  final bool isLast;

  const MemoryCard({
    super.key,
    required this.memory,
    this.isFirst = false,
    this.isLast = false,
  });

  static const _palette = [
    Color(0xFFFF80BF),
    Color(0xFFD91A72),
    Color(0xFFC75B9B),
    Color(0xFFFF66B2),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final accent = _palette[memory.id.hashCode.abs() % _palette.length];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عمود الخط الزمني
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 10,
                  color: isFirst ? Colors.transparent : themeProvider.dividerColor,
                ),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent,
                    border: Border.all(
                      color: themeProvider.backgroundColor,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : themeProvider.dividerColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // الكارت نفسه
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: themeProvider.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: themeProvider.cardBorderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(themeProvider.isDarkMode ? 0.25 : 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // شريط لوني جانبي مميز
                    Container(
                      width: 5,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(24),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [accent, accent.withOpacity(0.6)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                iconForMemory(memory.icon),
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          memory.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: themeProvider.primaryText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 9, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: accent.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      formatMemoryDate(memory.date),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: accent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    memory.description,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      height: 1.6,
                                      color: themeProvider.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}