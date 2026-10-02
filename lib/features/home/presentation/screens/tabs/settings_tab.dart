import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/core/theme/theme_provider.dart';
import 'package:mariam/features/home/presentation/screens/tabs/statistics_tab.dart';
import 'package:mariam/features/home/presentation/widgets/settings_header.dart';
import 'package:mariam/features/home/presentation/widgets/settings_navigation_tile.dart';
import 'package:mariam/features/home/presentation/widgets/settings_profile_card.dart';
import 'package:mariam/features/home/presentation/widgets/settings_section_title.dart';
import 'package:mariam/features/home/presentation/widgets/settings_switch_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  static const _notificationsKey = 'notifications_enabled';
  static const _prayerNotificationsKey = 'prayer_notifications_enabled';
  static const _adhkarNotificationsKey = 'adhkar_notifications_enabled';
  bool notificationsEnabled = true;
  bool prayerNotifications = true;
  bool adhkarNotifications = true;

  @override
  void initState() {
    super.initState();
    final prefs = context.read<SharedPreferences>();
    notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    prayerNotifications = prefs.getBool(_prayerNotificationsKey) ?? true;
    adhkarNotifications = prefs.getBool(_adhkarNotificationsKey) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SettingsHeader(),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 30.h),
                children: [
                  const SettingsProfileCard(),
                  SizedBox(height: 25.h),

                  // THEME SECTION
                  SettingsSectionTitle(
                    title: 'التخصيص',
                    color: themeProvider.primaryText,
                  ),
                  SizedBox(height: 10.h),
                  _buildSettingsGroup(
                    cardColor: themeProvider.cardColor,
                    borderColor: themeProvider.cardBorderColor,
                    children: [
                      _buildThemeTile(themeProvider),
                    ],
                  ),
                  SizedBox(height: 25.h),

                  // NOTIFICATIONS SECTION
                  SettingsSectionTitle(
                    title: 'التنبيهات',
                    color: themeProvider.primaryText,
                  ),
                  SizedBox(height: 10.h),
                  _buildSettingsGroup(
                    cardColor: themeProvider.cardColor,
                    borderColor: themeProvider.cardBorderColor,
                    children: [
                      SettingsSwitchTile(
                        icon: Icons.notifications_rounded,
                        title: 'الإشعارات',
                        subtitle: 'تفعيل تنبيهات التطبيق',
                        value: notificationsEnabled,
                        color: const Color(0xFFFF66B2),
                        primaryText: themeProvider.primaryText,
                        secondaryText: themeProvider.secondaryText,
                        onChanged: (value) async {
                          setState(() => notificationsEnabled = value);
                          await context.read<SharedPreferences>().setBool(_notificationsKey, value);
                        },
                      ),
                      _buildDivider(themeProvider),
                      SettingsSwitchTile(
                        icon: Icons.mosque_rounded,
                        title: 'تذكير العبادات',
                        subtitle: 'تنبيهات الصلاة والعبادات',
                        value: prayerNotifications,
                        color: const Color(0xFFD91A72),
                        primaryText: themeProvider.primaryText,
                        secondaryText: themeProvider.secondaryText,
                        onChanged: (value) async {
                          setState(() => prayerNotifications = value);
                          await context.read<SharedPreferences>().setBool(_prayerNotificationsKey, value);
                        },
                      ),
                      _buildDivider(themeProvider),
                      SettingsSwitchTile(
                        icon: Icons.wb_sunny_rounded,
                        title: 'الأذكار اليومية',
                        subtitle: 'تذكير بأذكار الصباح والمساء',
                        value: adhkarNotifications,
                        color: const Color(0xFFFF80BF),
                        primaryText: themeProvider.primaryText,
                        secondaryText: themeProvider.secondaryText,
                        onChanged: (value) async {
                          setState(() => adhkarNotifications = value);
                          await context.read<SharedPreferences>().setBool(_adhkarNotificationsKey, value);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),

                  // JOURNEY SECTION
                  SettingsSectionTitle(
                    title: 'رحلتك',
                    color: themeProvider.primaryText,
                  ),
                  SizedBox(height: 10.h),
                  _buildSettingsGroup(
                    cardColor: themeProvider.cardColor,
                    borderColor: themeProvider.cardBorderColor,
                    children: [
                      SettingsNavigationTile(
                        icon: Icons.bar_chart_rounded,
                        title: 'الاحصائيات',
                        subtitle: 'أجمل اللحظات التي جمعتنا ❤️',
                        color: const Color(0xFFFF80BF),
                        primaryText: themeProvider.primaryText,
                        secondaryText: themeProvider.secondaryText,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StatisticsTab(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),

                  // ABOUT SECTION
                  SettingsSectionTitle(
                    title: 'عن التطبيق',
                    color: themeProvider.primaryText,
                  ),
                  SizedBox(height: 10.h),
                  _buildSettingsGroup(
                    cardColor: themeProvider.cardColor,
                    borderColor: themeProvider.cardBorderColor,
                    children: [
                      SettingsNavigationTile(
                        icon: Icons.info_outline_rounded,
                        title: 'عن التطبيق',
                        subtitle: 'رفيقك في رحلتك اليومية',
                        color: const Color(0xFFD91A72),
                        primaryText: themeProvider.primaryText,
                        secondaryText: themeProvider.secondaryText,
                        onTap: () => AppDialogs.showCustomDialog(
                          context: context,
                          title: 'عن التطبيق',
                          content:
                          'رفيقك اليومي لتنظيم مهامك، متابعة عباداتك، وحفظ أجمل ذكرياتك.',
                        ),
                      ),
                      _buildDivider(themeProvider),
                      SettingsNavigationTile(
                        icon: Icons.card_giftcard_rounded,
                        title: 'هذه الهدية',
                        subtitle: 'رسالة خاصة لك',
                        color: const Color(0xFFFF80BF),
                        primaryText: themeProvider.primaryText,
                        secondaryText: themeProvider.secondaryText,
                        onTap: () => AppDialogs.showCustomDialog(
                          context: context,
                          title: 'هذه الهدية',
                            content:
                            'إليكِ أنتِ… ❤️\n\n'
                                'يا من دخلتِ قلبي بهدوء، '
                                'ثم أصبحتِ أجمل ما فيه.\n\n'
                                'ما كان هذا التطبيق إلا حجةً صغيرة '
                                'لأقول لكِ شيئًا كبيرًا:\n\n'
                                'أحبكِ…\n'
                                'وأحب كل لحظةٍ جعلتني أعرفكِ، '
                                'وكل ذكرى جمعتني بكِ.\n\n'
                                'فإن كان للحب وطن، '
                                'فأنتِ وطني، وإن كان للقلب أمنية، '
                                'فأنتِ أجمل أمنياتي. ❤️'                        ),
                        ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  Center(
                    child: Text(
                      'صُنعت بمحبة 🤍',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: themeProvider.secondaryText.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeTile(ThemeProvider themeProvider) {
    return Padding(
      padding: EdgeInsets.all(14.w),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              // ألوان خلفية الأيقونة تتكيف بسلاسة مع ثيم البنفسجي الوردي الجديد
              color: themeProvider.isDarkMode
                  ? const Color(0xFF2D2038) // متوافقة مع darkBorder / darkCardBg
                  : const Color(0xFFF9F6FB), // متوافقة مع lightBackground
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              themeProvider.isDarkMode
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: const Color(0xFFFF66B2), // لون الأيقونة متناسق مع الـ Primary الجديد
              size: 21.sp,
            ),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مظهر التطبيق',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: themeProvider.primaryText,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  themeProvider.isDarkMode ? 'الوضع الداكن' : 'الوضع الفاتح',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: themeProvider.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: themeProvider.isDarkMode,
            activeColor: const Color(0xFFFF66B2), // لون الـ Switch النشط متطابق مع الهوية
            onChanged: (value) => themeProvider.toggleTheme(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup({
    required Color cardColor,
    required Color borderColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(ThemeProvider themeProvider) {
    return Divider(
      height: 1,
      indent: 72.w,
      color: themeProvider.dividerColor,
    );
  }



}
class AppDialogs {
  static void showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: themeProvider.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          title: Text(
            title,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(color: themeProvider.primaryText),
          ),
          content: Text(
            content,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(color: themeProvider.secondaryText,fontSize: 16.sp,fontWeight: FontWeight.bold),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'حسنًا',
                style: TextStyle(color: themeProvider.primaryText),
              ),
            ),
          ],
        );
      },
    );
  }
}
