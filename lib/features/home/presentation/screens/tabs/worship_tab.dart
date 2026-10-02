import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mariam/features/home/presentation/widgets/worship_category_selector.dart';
import 'package:mariam/features/home/presentation/widgets/worship_daily_card.dart';
import 'package:mariam/features/home/presentation/widgets/worship_dhikr_card.dart';
import 'package:mariam/features/home/presentation/widgets/worship_header.dart';
import 'package:mariam/features/home/presentation/widgets/worship_item_card.dart';
import 'package:mariam/features/home/presentation/widgets/worship_section_title.dart';

class WorshipTab extends StatefulWidget {
  const WorshipTab({super.key});

  @override
  State<WorshipTab> createState() => _WorshipTabState();
}

class _WorshipTabState extends State<WorshipTab> {
  static const _storageKey = 'worship_progress';
  int selectedCategory = 0;
  final List<String> categories = const ['اليوم', 'الأذكار', 'القرآن', 'التسبيح'];
  late List<Map<String, dynamic>> worshipItems;
  bool _initialized = false;
  bool _storageLoaded = false;

  List<Map<String, dynamic>> _buildWorshipItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFA292A6)
        : const Color(0xFF7A6B82);
    return [
      {
        'title': 'أذكار الصباح',
        'subtitle': 'ابدأ يومك بذكر الله',
        'icon': Icons.wb_sunny_rounded,
        'color': colorScheme.primary,
        'progress': 0.0,
        'completed': false,
      },
      {
        'title': 'ورد القرآن',
        'subtitle': 'صفحة واحدة على الأقل',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFFE272B7),
        'progress': 0.0,
        'completed': false,
      },
      {
        'title': 'الصلاة',
        'subtitle': 'حافظ على صلواتك',
        'icon': Icons.mosque_rounded,
        'color': const Color(0xFFC75B9B),
        'progress': 0.0,
        'completed': false,
      },
      {
        'title': 'أذكار المساء',
        'subtitle': 'اختم يومك بذكر الله',
        'icon': Icons.nightlight_round,
        'color': secondaryColor,
        'progress': 0.0,
        'completed': false,
      },
      {
        'title': 'التسبيح',
        'subtitle': 'سبّحي واستغفري بقلب حاضر',
        'icon': Icons.favorite_rounded,
        'color': colorScheme.secondary,
        'progress': 0.0,
        'completed': false,
      },
    ];
  }

  int get completedCount => worshipItems.where((item) => item['completed'] == true).length;

  double get totalProgress {
    if (worshipItems.isEmpty) return 0;
    return worshipItems.fold<double>(0, (sum, item) => sum + (item['progress'] as double)) / worshipItems.length;
  }

  List<Map<String, dynamic>> get visibleItems {
    if (selectedCategory == 0) return worshipItems;
    if (selectedCategory == 1) {
      return worshipItems.where((item) => item['title'].toString().contains('أذكار') || item['title'] == 'التسبيح').toList();
    }
    if (selectedCategory == 2) return worshipItems.where((item) => item['title'] == 'ورد القرآن').toList();
    return worshipItems.where((item) => item['title'] == 'الصلاة').toList();
  }

  Future<void> _loadSavedProgress() async {
    if (_storageLoaded) return;
    _storageLoaded = true;
    final raw = context.read<SharedPreferences>().getString(_storageKey);
    if (raw == null) return;
    try {
      final saved = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      if (!mounted) return;
      setState(() {
        for (final item in worshipItems) {
          final state = saved[item['title']];
          if (state is Map) {
            item['completed'] = state['completed'] == true;
            item['progress'] = (state['progress'] as num?)?.toDouble() ?? 0.0;
          }
        }
      });
    } catch (_) {
      // إذا تلف الكاش نعود للقيم الافتراضية.
    }
  }

  Future<void> _saveProgress() async {
    final data = <String, dynamic>{
      for (final item in worshipItems)
        item['title'] as String: {'completed': item['completed'], 'progress': item['progress']},
    };
    await context.read<SharedPreferences>().setString(_storageKey, jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      worshipItems = _buildWorshipItems(context);
      _initialized = true;
      _loadSavedProgress();
    }

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const WorshipHeader(),
                SizedBox(height: 22.h),
                WorshipDailyCard(totalProgress: totalProgress, completedCount: completedCount, totalCount: worshipItems.length),
                SizedBox(height: 22.h),
                WorshipCategorySelector(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: (index) => setState(() => selectedCategory = index),
                ),
                SizedBox(height: 20.h),
                WorshipSectionTitle(
                  title: selectedCategory == 0 ? 'عبادات اليوم' : categories[selectedCategory],
                  actionText: 'الكل',
                  onActionTap: () => setState(() => selectedCategory = 0),
                ),
                SizedBox(height: 12.h),
                ...visibleItems.map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: WorshipItemCard(
                        title: item['title'],
                        subtitle: item['subtitle'],
                        icon: item['icon'],
                        color: item['color'],
                        progress: item['progress'],
                        completed: item['completed'],
                        onTap: () {
                          setState(() {
                            item['completed'] = !item['completed'];
                            item['progress'] = item['completed'] ? 1.0 : 0.0;
                          });
                          _saveProgress();
                        },
                      ),
                    )),
                SizedBox(height: 22.h),
                const WorshipDhikrCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
