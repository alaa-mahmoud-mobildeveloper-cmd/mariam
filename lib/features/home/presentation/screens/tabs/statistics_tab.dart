import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/home/presentation/widgets/achievements_section.dart';
import 'package:mariam/features/home/presentation/widgets/main_progress_card.dart';
import 'package:mariam/features/home/presentation/widgets/motivation_card.dart';
import 'package:mariam/features/home/presentation/widgets/section_title.dart';
import 'package:mariam/features/home/presentation/widgets/statistics_header.dart';
import 'package:mariam/features/home/presentation/widgets/stats_grid.dart';
import 'package:mariam/features/home/presentation/widgets/streak_card.dart';
import 'package:mariam/features/home/presentation/widgets/weekly_chart_card.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const StatisticsHeader(),
                    SizedBox(height: 22.h),
                    const MainProgressCard(),
                    SizedBox(height: 18.h),
                    const StatsGrid(),
                    SizedBox(height: 22.h),
                    const SectionTitle(title: 'تقدمك هذا الأسبوع'),
                    SizedBox(height: 12.h),
                    const WeeklyChartCard(),
                    SizedBox(height: 22.h),
                    const StreakCard(),
                    SizedBox(height: 22.h),
                    const AchievementsSection(),
                    SizedBox(height: 20.h),
                    const MotivationCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}