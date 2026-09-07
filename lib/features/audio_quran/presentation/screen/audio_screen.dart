import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mariam/features/audio_quran/presentation/widgets/audio_filters.dart';
import 'package:mariam/features/audio_quran/presentation/widgets/audio_header.dart';
import 'package:mariam/features/audio_quran/presentation/widgets/audio_hero_card.dart';
import 'package:mariam/features/audio_quran/presentation/widgets/audio_mini_player.dart';
import 'package:mariam/features/audio_quran/presentation/widgets/audio_preview.dart';
import 'package:mariam/features/audio_quran/presentation/widgets/audio_tile.dart';
import 'package:mariam/features/audio_quran/presentation/widgets/reciter_tabs.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final searchController = TextEditingController();
  int selectedCategory = 0;
  int selectedReciter = 0;
  int? playingIndex;
  bool isPlaying = false;
  bool favoritesOnly = false;

  final categories = const ['الكل', 'السور القصيرة', 'السور المكية', 'السور المدنية'];

  final audioItems = <AudioPreview>[
    const AudioPreview(title: 'سورة الفاتحة', category: 'السور القصيرة', duration: '01:12', icon: Icons.menu_book_rounded, color: Color(0xFF56B99D)),
    const AudioPreview(title: 'سورة البقرة', category: 'السور المدنية', duration: '02:18:42', icon: Icons.auto_stories_rounded, color: Color(0xFF5C9FE8)),
    const AudioPreview(title: 'سورة الكهف', category: 'السور المكية', duration: '38:24', icon: Icons.book_rounded, color: Color(0xFFFFB457)),
    const AudioPreview(title: 'سورة يس', category: 'السور المكية', duration: '22:16', icon: Icons.menu_book_rounded, color: Color(0xFF8C83E8)),
    const AudioPreview(title: 'سورة الرحمن', category: 'السور المكية', duration: '19:08', icon: Icons.auto_stories_rounded, color: Color(0xFFDE78B0)),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 110.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  AudioHeader(favoritesOnly: favoritesOnly, onFavoritesChanged: (value) => setState(() => favoritesOnly = value)),
                  SizedBox(height: 20.h),
                  AudioHeroCard(onTap: () => _selectAudio(0)),
                  SizedBox(height: 18.h),
                  ReciterTabs(selectedIndex: selectedReciter, onChanged: (value) => setState(() { selectedReciter = value; playingIndex = null; isPlaying = false; })),
                  SizedBox(height: 18.h),
                  AudioSearchField(controller: searchController),
                  SizedBox(height: 16.h),
                  AudioCategories(categories: categories, selectedIndex: selectedCategory, onChanged: (value) => setState(() => selectedCategory = value)),
                  SizedBox(height: 22.h),
                  _SectionTitle(count: audioItems.length),
                  SizedBox(height: 12.h),
                  ...audioItems.asMap().entries.map((entry) => AudioTile(item: entry.value, selected: playingIndex == entry.key, isPlaying: isPlaying, onTap: () => _selectAudio(entry.key), onFavorite: () {})),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: playingIndex == null ? null : AudioMiniPlayer(item: audioItems[playingIndex!], isPlaying: isPlaying, onPlayPause: () => setState(() => isPlaying = !isPlaying), onClose: () => setState(() { playingIndex = null; isPlaying = false; })),
    );
  }

  void _selectAudio(int index) {
    if (index < 0 || index >= audioItems.length) return;
    setState(() {
      playingIndex = index;
      isPlaying = true;
    });
  }
}

class _SectionTitle extends StatelessWidget {
  final int count;
  const _SectionTitle({required this.count});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(textDirection: TextDirection.rtl, children: [
      Text('سور القرآن الكريم', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: colors.onSurface)),
      const Spacer(),
      Text('$count ملف', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 11.sp, color: colors.onSurface.withValues(alpha: 0.5))),
    ]);
  }
}
