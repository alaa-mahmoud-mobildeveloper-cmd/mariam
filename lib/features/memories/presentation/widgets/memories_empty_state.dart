import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';

class MemoriesEmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const MemoriesEmptyState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF80BF).withOpacity(0.12),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              size: 46,
              color: Color(0xFFFF80BF),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'لسه مفيش ذكريات هنا',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ابدأ بحفظ أول لحظة حلوة تفضل معاكم للأبد',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: themeProvider.secondaryText),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: onAdd,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFF80BF).withOpacity(0.12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.add_rounded, color: Color(0xFFFF80BF)),
            label: const Text(
              'أضف أول ذكرى',
              style: TextStyle(
                color: Color(0xFFFF80BF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}