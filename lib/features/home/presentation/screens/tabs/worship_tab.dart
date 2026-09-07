import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/home/domain/entities/dhikr_item.dart';
import 'package:mariam/features/home/presentation/widgets/worship_category_selector.dart';
import 'package:mariam/features/home/presentation/widgets/worship_daily_card.dart';
import 'package:mariam/features/home/presentation/widgets/worship_dhikr_card.dart';
import 'package:mariam/features/home/presentation/widgets/worship_header.dart';
import 'package:mariam/features/home/presentation/widgets/worship_item_card.dart';
import 'package:mariam/features/home/presentation/widgets/worship_quran_card.dart';
import 'package:mariam/features/home/presentation/widgets/worship_quran_card_audio.dart';
import 'package:mariam/features/home/presentation/widgets/worship_section_title.dart';
import 'package:mariam/features/home/presentation/widgets/worship_tasbih_card.dart';


class WorshipTab extends StatefulWidget {
  const WorshipTab({super.key});

  @override
  State<WorshipTab> createState() => _WorshipTabState();
}

class _WorshipTabState extends State<WorshipTab> {
  int selectedCategory = 0;

  final List<String> categories = ['الكل', 'الصلاة', 'القرآن', 'الأذكار', 'التسبيح'];

  // --- الصلوات ---
  final List<Map<String, dynamic>> prayers = [
    {'title': 'الفجر', 'subtitle': '04:45 ص', 'icon': Icons.brightness_3_rounded, 'completed': true},
    {'title': 'الظهر', 'subtitle': '12:15 م', 'icon': Icons.wb_sunny_rounded, 'completed': true},
    {'title': 'العصر', 'subtitle': '03:40 م', 'icon': Icons.wb_twilight_rounded, 'completed': false},
    {'title': 'المغرب', 'subtitle': '06:10 م', 'icon': Icons.brightness_4_rounded, 'completed': false},
    {'title': 'العشاء', 'subtitle': '07:35 م', 'icon': Icons.nightlight_round, 'completed': false},
  ];

  // --- القرآن ---
  int quranPagesRead = 4;
  final int quranDailyGoal = 10;

  // --- السبحة ---
  int tasbihCount = 0;

  static const Color prayerColor = Color(0xFF5B8DEF);
  static const Color quranColor = Color(0xFFE272B7);
  static const Color adhkarMorningColor = Color(0xFFFF9F45);
  static const Color adhkarEveningColor = Color(0xFF7C6BF2);
  static const Color tasbihColor = Color(0xFF4CC38A);

  int get completedPrayersCount => prayers.where((p) => p['completed'] == true).length;

  double get overallProgress {
    final prayerProgress = completedPrayersCount / prayers.length;
    final quranProgress = (quranPagesRead / quranDailyGoal).clamp(0.0, 1.0);
    return (prayerProgress + quranProgress) / 2;
  }

  int get overallCompletedCount => completedPrayersCount + (quranPagesRead >= quranDailyGoal ? 1 : 0);
  int get overallTotalCount => prayers.length + 1;

  void _openAdhkar(DhikrCategory category) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => AdhkarScreen(initialCategory: category)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final showAll = selectedCategory == 0;
    final showPrayers = showAll || selectedCategory == 1;
    final showQuran = showAll || selectedCategory == 2;
    final showAdhkar = showAll || selectedCategory == 3;
    final showTasbih = showAll || selectedCategory == 4;

    return SafeArea(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
        children: [
          const WorshipHeader(),
          SizedBox(height: 22.h),

          WorshipDailyCard(
            totalProgress: overallProgress,
            completedCount: overallCompletedCount,
            totalCount: overallTotalCount,
          ),
          SizedBox(height: 22.h),

          WorshipCategorySelector(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: (index) => setState(() => selectedCategory = index),
          ),
          SizedBox(height: 22.h),

          if (showPrayers) ...[
            const WorshipSectionTitle(title: 'الصلوات', actionText: ''),
            SizedBox(height: 12.h),
            ...prayers.map(
                  (prayer) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: WorshipItemCard(
                  title: prayer['title'],
                  subtitle: prayer['subtitle'],
                  icon: prayer['icon'],
                  color: prayerColor,
                  progress: prayer['completed'] ? 1.0 : 0.0,
                  completed: prayer['completed'],
                  onTap: () => setState(() => prayer['completed'] = !prayer['completed']),
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],

          if (showQuran) ...[
            const WorshipSectionTitle(title: ' القران الكريم ', actionText: ''),
            SizedBox(height: 12.h),
            const WorshipQuranCardAudio(),
            SizedBox(height: 22.h),
            const WorshipSectionTitle(title: 'ورد القرآن', actionText: ''),
            SizedBox(height: 12.h),
            WorshipQuranCard(
              pagesRead: quranPagesRead,
              dailyGoal: quranDailyGoal,
              color: quranColor,
              onIncrement: () => setState(() => quranPagesRead++),
              onDecrement: () => setState(() {
                if (quranPagesRead > 0) quranPagesRead--;
              }),
            ),
            SizedBox(height: 22.h),
          ],

          if (showAdhkar) ...[
            const WorshipSectionTitle(title: 'الأذكار', actionText: ''),
            SizedBox(height: 12.h),
            WorshipItemCard(
              title: 'أذكار الصباح',
              subtitle: 'ابدأ يومك بذكر الله',
              icon: Icons.wb_sunny_rounded,
              color: adhkarMorningColor,
              progress: 0,
              completed: false,
              onTap: () => _openAdhkar(DhikrCategory.morning),
            ),
            SizedBox(height: 10.h),
            WorshipItemCard(
              title: 'أذكار المساء',
              subtitle: 'اختم يومك بذكر الله',
              icon: Icons.nightlight_round,
              color: adhkarEveningColor,
              progress: 0,
              completed: false,
              onTap: () => _openAdhkar(DhikrCategory.evening),
            ),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () => _openAdhkar(DhikrCategory.morning),
              child: const WorshipDhikrCard(),
            ),

            SizedBox(height: 22.h),
          ],

          if (showTasbih) ...[
            const WorshipSectionTitle(title: 'السبحة الإلكترونية', actionText: ''),
            SizedBox(height: 12.h),
            WorshipTasbihCard(
              count: tasbihCount,
              color: tasbihColor,
              onTap: () => setState(() => tasbihCount++),
              onReset: () => setState(() => tasbihCount = 0),
            ),
          ],
        ],
      ),
    );
  }
}