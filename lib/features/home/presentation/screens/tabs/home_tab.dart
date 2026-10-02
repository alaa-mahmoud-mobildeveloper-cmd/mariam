import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Scaffold(
      // استخدام اللون المخصص للخلفية الداكنة مباشرة من الثيم أو ثوابت الألوان
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
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
                    const NextPrayerCard(),
                    SizedBox(height: 18.h),
                    const DailyVerseCard(),
                    SizedBox(height: 18.h),
                    const DailyDhikrCard(),
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
    );
  }
}
