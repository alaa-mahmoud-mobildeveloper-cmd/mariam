import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mariam/features/memories/presentation/widgets/utils/memory_ui_mapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:mariam/core/theme/theme_provider.dart';
import '../../domain/entities/memory.dart';

import '../widgets/share_card_renderer.dart';

class MemoryDetailsScreen extends StatefulWidget {
  final Memory memory;

  const MemoryDetailsScreen({super.key, required this.memory});

  @override
  State<MemoryDetailsScreen> createState() => _MemoryDetailsScreenState();
}

class _MemoryDetailsScreenState extends State<MemoryDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSharing = false;

  static const _palette = [
    Color(0xFFFF80BF),
    Color(0xFFD91A72),
    Color(0xFFC75B9B),
    Color(0xFFFF66B2),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(BuildContext context, Color accent) async {
    final themeProvider = context.read<ThemeProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text('حذف الذكرى؟', style: TextStyle(color: themeProvider.primaryText)),
        content: Text(
          'الذكرى دي هتتمسح نهائيًا ومش هينفع ترجعها تاني.',
          style: TextStyle(color: themeProvider.secondaryText),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء', style: TextStyle(color: themeProvider.secondaryText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // TODO: نادِ context.read<MemoriesProvider>().deleteMemory(widget.memory.id) لما تضيف الميثود دي
      Navigator.pop(context);
    }
  }

  Future<void> _shareMemory(BuildContext context, Color accent) async {
    if (_isSharing) return;

    setState(() => _isSharing = true);

    try {
      debugPrint('========== SHARE START ==========');

      final bytes = await ShareCardRenderer.renderMemoryCard(
        context: context,
        memory: widget.memory,
        accent: accent,
      );

      debugPrint('Image bytes: ${bytes?.length}');

      if (bytes == null || bytes.isEmpty) {
        throw Exception('ShareCardRenderer رجع صورة فارغة');
      }

      final tempDir = await getTemporaryDirectory();

      debugPrint('Temp directory: ${tempDir.path}');

      final file = File(
        '${tempDir.path}/memory_${widget.memory.id}_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await file.writeAsBytes(
        bytes,
        flush: true,
      );

      debugPrint('File exists: ${await file.exists()}');
      debugPrint('File path: ${file.path}');
      debugPrint('File size: ${await file.length()}');

      await Share.shareXFiles(
        [
          XFile(
            file.path,
            mimeType: 'image/png',
          ),
        ],
        text: '${widget.memory.title} — من تطبيق مريم ❤️',
      );

      debugPrint('========== SHARE SUCCESS ==========');
    } catch (e, stackTrace) {
      debugPrint('========== SHARE ERROR ==========');
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      debugPrint('================================');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ أثناء المشاركة: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final memory = widget.memory;
    final accent = _palette[memory.id.hashCode.abs() % _palette.length];
    final hasPhotos = memory.photos.isNotEmpty;

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: false,
                stretch: true,
                expandedHeight: hasPhotos ? 460 : 100,
                backgroundColor: themeProvider.backgroundColor,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: hasPhotos
                      ? _buildImmersiveHeader(memory, accent, themeProvider)
                      : _buildPlainHeader(memory, accent, themeProvider),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- الكارت العائم (يتراكب فوق حافة الصورة) ---
                      Transform.translate(
                        offset: const Offset(0, -36),
                        child: _buildFloatingInfoCard(memory, accent, themeProvider, hasPhotos),
                      ),

                      // --- بطاقة الوصف ---
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                          decoration: BoxDecoration(
                            color: themeProvider.cardColor,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: themeProvider.cardBorderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(themeProvider.isDarkMode ? 0.22 : 0.05),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -20,
                                right: -4,
                                child: Icon(
                                  Icons.format_quote_rounded,
                                  size: 50,
                                  color: accent.withOpacity(0.18),
                                ),
                              ),
                              Text(
                                memory.description,
                                style: TextStyle(
                                  fontSize: 15.5,
                                  height: 2.0,
                                  color: themeProvider.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (hasPhotos && memory.photos.length > 1) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: accent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'كل الصور',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: themeProvider.primaryText,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${memory.photos.length})',
                              style: TextStyle(fontSize: 13, color: themeProvider.secondaryText),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildThumbnailsRow(memory, accent),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- شريط علوي شفاف عائم (رجوع فقط) ---
          Positioned(
            top: MediaQuery.of(context).padding.top + 6,
            right: 14,
            child: _buildGlassButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // --- شريط أزرار سفلي ثابت (Share / Delete) ---
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _buildBottomActionBar(context, themeProvider, accent),
          ),
        ],
      ),
    );
  }

  // ---------------- Header مع صور ----------------
  Widget _buildImmersiveHeader(Memory memory, Color accent, ThemeProvider themeProvider) {
    final photos = memory.photos;

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: photos.length,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemBuilder: (context, index) => _base64Image(photos[index]),
        ),

        // تدرج غامق من فوق (للأزرار العائمة)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 140,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              ),
            ),
          ),
        ),

        // تدرج غامق من تحت (للعنوان + الاندماج مع الخلفية)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 280,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.55),
                  themeProvider.backgroundColor,
                ],
                stops: const [0, 0.55, 1],
              ),
            ),
          ),
        ),

        // نقاط المؤشر
        if (photos.length > 1)
          Positioned(
            bottom: 130,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(photos.length, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),

        // العنوان فوق الصورة مباشرة (بوستر ستايل)
        Positioned(
          left: 24,
          right: 24,
          bottom: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  formatMemoryDate(memory.date),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                memory.title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.25,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 3))],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- Header من غير صور ----------------
  Widget _buildPlainHeader(Memory memory, Color accent, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent.withOpacity(0.16), themeProvider.backgroundColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 90, 24, 20),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Text(
            memory.title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryText,
              height: 1.25,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- الكارت العائم (أيقونة + إحصائيات سريعة) ----------------
  Widget _buildFloatingInfoCard(Memory memory, Color accent, ThemeProvider themeProvider, bool hasPhotos) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: themeProvider.cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(themeProvider.isDarkMode ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(color: accent.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 5)),
              ],
            ),
            child: Icon(iconForMemory(memory.icon), color: Colors.white, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasPhotos) ...[
                  Text(
                    formatMemoryDate(memory.date),
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: accent),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  'ذكرى محفوظة بحب ❤️',
                  style: TextStyle(fontSize: 12.5, color: themeProvider.secondaryText, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          if (hasPhotos && memory.photos.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library_rounded, size: 14, color: accent),
                  const SizedBox(width: 5),
                  Text(
                    '${memory.photos.length}',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accent),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- زرار زجاجي دائري (رجوع) ----------------
  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.32),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  // ---------------- شريط الأزرار السفلي الثابت ----------------
  Widget _buildBottomActionBar(BuildContext context, ThemeProvider themeProvider, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: themeProvider.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: themeProvider.cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(themeProvider.isDarkMode ? 0.35 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: _isSharing ? Icons.hourglass_top_rounded : Icons.ios_share_rounded,
              label: 'مشاركة',
              color: accent,
              filled: true,
              onTap: () => _shareMemory(context, accent),
            ),
          ),
          const SizedBox(width: 10),
          _buildActionButton(
            icon: Icons.delete_outline_rounded,
            label: null,
            color: Colors.redAccent,
            filled: false,
            onTap: () => _confirmDelete(context, accent),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    String? label,
    required Color color,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: label != null ? 18 : 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: filled
              ? LinearGradient(colors: [color, color.withOpacity(0.75)])
              : null,
          color: filled ? null : color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: filled ? Colors.white : color, size: 19),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: filled ? Colors.white : color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailsRow(Memory memory, Color accent) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: memory.photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isActive = index == _currentPage;
          return InkWell(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 76,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isActive ? accent : Colors.transparent,
                  width: 2.5,
                ),
                boxShadow: isActive
                    ? [BoxShadow(color: accent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Opacity(
                  opacity: isActive ? 1 : 0.6,
                  child: _base64Image(memory.photos[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _base64Image(String base64String) {
    try {
      final bytes = base64Decode(base64String);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (_) {
      return Container(
        color: Colors.grey.withOpacity(0.15),
        child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
      );
    }
  }
}