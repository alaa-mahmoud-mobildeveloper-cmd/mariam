import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:mariam/features/home/presentation/providers/home_provider.dart';
import 'package:mariam/features/home/presentation/widgets/daily_dhikr_card.dart';
import 'package:mariam/features/home/presentation/widgets/daily_progress_card.dart';
import 'package:mariam/features/home/presentation/widgets/daily_verse_card.dart';
import 'package:mariam/features/home/presentation/widgets/header_home.dart';
import 'package:mariam/features/home/presentation/widgets/next_prayer_card.dart';
import 'package:mariam/features/home/presentation/widgets/today_tasks_section.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    if (provider.status == HomeStatus.loading ||
        provider.status == HomeStatus.initial) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.status == HomeStatus.error) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'تعذر تحميل بيانات الصفحة الرئيسية',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => provider.loadHomeData(
                    latitude: 30.0444,
                    longitude: 31.2357,
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final prayerTimes = provider.prayerTimes;
    final ayah = provider.ayah;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.loadHomeData(
            latitude: 30.0444,
            longitude: 31.2357,
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 30.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const HomeHeader(),

                      SizedBox(height: 22.h),

                      const DailyProgressCard(),

                      SizedBox(height: 18.h),

                      NextPrayerCard(
                        prayerName: 'صلاة العصر',
                        prayerTime: prayerTimes?.asr ?? '--:--',
                      ),

                      SizedBox(height: 18.h),

                      DailyVerseCard(
                        verse: ayah?.text ?? 'لا توجد آية متاحة حاليًا',
                        surahName: ayah?.surahName ?? '',
                        ayahNumber: ayah?.numberInSurah,
                      ),

                      SizedBox(height: 18.h),

                      DailyDhikrCard(
                        dhikr: provider.dhikr?.text ?? 'لا توجد أذكار متاحة حاليًا',
                        repeatCount: provider.dhikr?.repeatCount ?? 0,
                        onTap: () {
                          // افتح شاشة الأذكار
                        },
                      ),

                      SizedBox(height: 18.h),

                      const TodayTasksSection(),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
