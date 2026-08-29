import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  int selectedCategory = 0;

  final List<String> categories = [
    'اليوم',
    'الأذكار',
    'القرآن',
    'التسبيح',
  ];

  List<Map<String, dynamic>> _buildWorshipItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFA292A6) // darkTextMuted
        : const Color(0xFF7A6B82); // lightTextMuted

    return [
      {
        'title': 'أذكار الصباح',
        'subtitle': 'ابدأ يومك بذكر الله',
        'icon': Icons.wb_sunny_rounded,
        'color': colorScheme.primary,
        'progress': 1.0,
        'completed': true,
      },
      {
        'title': 'ورد القرآن',
        'subtitle': 'صفحة واحدة على الأقل',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFFE272B7),
        'progress': 0.65,
        'completed': false,
      },
      {
        'title': 'الصلاة',
        'subtitle': 'حافظ على صلواتك',
        'icon': Icons.mosque_rounded,
        'color': const Color(0xFFC75B9B),
        'progress': 0.60,
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
    ];
  }

  late List<Map<String, dynamic>> worshipItems;
  bool _initialized = false;

  int get completedCount {
    return worshipItems.where((item) => item['completed'] == true).length;
  }

  double get totalProgress {
    if (worshipItems.isEmpty) return 0;
    double sum = worshipItems.fold(0.0, (prev, item) => prev + (item['progress'] as double));
    return sum / worshipItems.length;
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      worshipItems = _buildWorshipItems(context);
      _initialized = true;
    }

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const WorshipHeader(),
                  SizedBox(height: 22.h),
                  WorshipDailyCard(
                    totalProgress: totalProgress,
                    completedCount: completedCount,
                    totalCount: worshipItems.length,
                  ),
                  SizedBox(height: 22.h),
                  WorshipCategorySelector(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: (index) {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  const WorshipSectionTitle(
                    title: 'عبادات اليوم',
                    actionText: 'عرض الكل',
                  ),
                  SizedBox(height: 12.h),
                  ...worshipItems.asMap().entries.map((entry) {
                    final item = entry.value;

                    return Padding(
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
                        },
                      ),
                    );
                  }),
                  SizedBox(height: 22.h),
                  const WorshipDhikrCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}