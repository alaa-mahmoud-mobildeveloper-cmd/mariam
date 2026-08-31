import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mariam/features/memories/presentation/screens/memory_details_screen.dart';
import 'package:provider/provider.dart';

import 'package:mariam/core/theme/theme_provider.dart';
import '../../domain/entities/memory.dart';
import 'utils/memory_ui_mapper.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;
  final bool isLast;
  final bool isFirst;

  const MemoryCard({
    super.key,
    required this.memory,
    required this.isLast,
    required this.isFirst,
  });

  static const _palette = [
    Color(0xFFFF80BF),
    Color(0xFFD91A72),
    Color(0xFFC75B9B),
    Color(0xFFFF66B2),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final accent = _palette[memory.id.hashCode.abs() % _palette.length];
    final hasPhotos = memory.photos.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MemoryDetailsScreen(memory: memory),
          ),
        );
      },
        child: Container(
          margin: const EdgeInsets.only(bottom: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(themeProvider.isDarkMode ? 0.15 : 0.18),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: hasPhotos
                ? _buildPhotoLayout(themeProvider, accent)
                : _buildTextOnlyLayout(themeProvider, accent),
          ),
        )
    );
  }

  // ---------- تصميم فيه صور: الصورة خلفية كاملة + نص فوقها ----------
  Widget _buildPhotoLayout(ThemeProvider themeProvider, Color accent) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildGallery(),

          // تدرج غامق من تحت عشان النص يبان واضح
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.85),
                ],
                stops: const [0.4, 0.7, 1.0],
              ),
            ),
          ),

          // بادچ الأيقونة العائم أعلى الكارت
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: Icon(iconForMemory(memory.icon), color: Colors.white, size: 19),
            ),
          ),

          // نقاط عدّاد الصور (لو أكتر من صورة)
          if (memory.photos.length > 1)
            Positioned(
              top: 20,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.photo_library_rounded, color: Colors.white, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      '${memory.photos.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

          // النص فوق التدرج
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    formatMemoryDate(memory.date),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  memory.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  memory.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    final photos = memory.photos;
    if (photos.length == 1) return _base64Image(photos[0]);

    return PageView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) => _base64Image(photos[index]),
    );
  }

  // ---------- تصميم من غير صور: كارت نصي مع أيقونة كبيرة ----------
  Widget _buildTextOnlyLayout(ThemeProvider themeProvider, Color accent) {
    return Container(
      color: themeProvider.cardColor,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: accent.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(iconForMemory(memory.icon), color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        memory.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: themeProvider.primaryText),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  formatMemoryDate(memory.date),
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: accent),
                ),
                const SizedBox(height: 10),
                Text(
                  memory.description,
                  style: TextStyle(fontSize: 13.5, height: 1.6, color: themeProvider.secondaryText),
                ),
              ],
            ),
          ),
        ],
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
        child: const Icon(Icons.broken_image_rounded, color: Colors.grey, size: 40),
      );
    }
  }
}