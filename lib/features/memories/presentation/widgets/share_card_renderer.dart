import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mariam/features/memories/presentation/widgets/utils/memory_ui_mapper.dart';

import '../../domain/entities/memory.dart';

class ShareCardRenderer {
  static Future<Uint8List?> renderMemoryCard({
    required BuildContext context,
    required Memory memory,
    required Color accent,
  }) async {
    final repaintKey = GlobalKey();
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: -9999,
        top: 0,
        child: RepaintBoundary(
          key: repaintKey,
          child: _ShareCardWidget(memory: memory, accent: accent),
        ),
      ),
    );

    overlay.insert(entry);
    await Future.delayed(const Duration(milliseconds: 80));

    Uint8List? bytes;
    try {
      final boundary =
      repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: 2.5);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        bytes = byteData?.buffer.asUint8List();
      }
    } finally {
      entry.remove();
    }

    return bytes;
  }
}

class _ShareCardWidget extends StatelessWidget {
  final Memory memory;
  final Color accent;

  const _ShareCardWidget({required this.memory, required this.accent});

  static const double _w = 1080;
  static const double _h = 1920;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = memory.photos.isNotEmpty;
    final darkAccent = Color.lerp(accent, Colors.black, 0.55)!;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: _w,
        height: _h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [darkAccent, accent, Color.lerp(accent, Colors.white, 0.15)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.55, 1],
          ),
        ),
        child: Stack(
          children: [
            // --- الصورة كخلفية علوية مموّهة ---
            if (hasPhoto)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: _h * 0.62,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _base64Image(memory.photos.first),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.05),
                            darkAccent.withOpacity(0.15),
                            accent,
                          ],
                          stops: const [0, 0.7, 1],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // --- زخارف دوائر شفافة ---
            Positioned(
              top: -60,
              right: -60,
              child: _decorCircle(220, 0.10),
            ),
            Positioned(
              bottom: 40,
              left: -80,
              child: _decorCircle(260, 0.08),
            ),

            // --- نقاط زخرفية صغيرة متناثرة ---
            Positioned(top: 140, left: 90, child: _sparkle(18, 0.7)),
            Positioned(top: 220, left: 140, child: _sparkle(9, 0.5)),
            Positioned(bottom: 340, right: 100, child: _sparkle(14, 0.6)),

            // --- المحتوى الرئيسي ---
            Padding(
              padding: const EdgeInsets.fromLTRB(64, 70, 64, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // شعار التطبيق أعلى الكارت
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                        ),
                        child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'مريم',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),

                  // --- بطاقة زجاجية (Glassmorphism) للنص ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilterCard(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(44, 46, 44, 44),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // بادچ الأيقونة + التاريخ
                            Row(
                              children: [
                                Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.white, Colors.white.withOpacity(0.8)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 14, offset: const Offset(0, 6)),
                                    ],
                                  ),
                                  child: Icon(iconForMemory(memory.icon), color: darkAccent, size: 32),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.white.withOpacity(0.35)),
                                  ),
                                  child: Text(
                                    formatMemoryDate(memory.date),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // العنوان
                            Text(
                              memory.title,
                              textDirection: TextDirection.rtl,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 18),

                            // خط فاصل زخرفي
                            Container(
                              width: 70,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 22),

                            // الوصف
                            Text(
                              memory.description,
                              textDirection: TextDirection.rtl,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.92),
                                fontSize: 27,
                                height: 1.65,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // تذييل بسيط
                  Center(
                    child: Text(
                      'ذكرياتنا • تطبيق مريم',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
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

  Widget _decorCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  Widget _sparkle(double size, double opacity) {
    return Icon(Icons.auto_awesome_rounded, size: size, color: Colors.white.withOpacity(opacity));
  }

  Widget _base64Image(String base64String) {
    try {
      final bytes = base64Decode(base64String);
      return Image.memory(bytes, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    } catch (_) {
      return const SizedBox.shrink();
    }
  }
}

/// بطاقة بتأثير زجاجي (شفافية + طبقة بيضاء خفيفة) بديل عن BackdropFilter
/// الحقيقي، لأن BackdropFilter مش دايمًا بيترسم صح جوه RepaintBoundary
/// خارج الشاشة المرئية — فبنحاكي التأثير بطبقات شفافية بسيطة.
class BackdropFilterCard extends StatelessWidget {
  final Widget child;
  const BackdropFilterCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
      ),
      child: child,
    );
  }
}