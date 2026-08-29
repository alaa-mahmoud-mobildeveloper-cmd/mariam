import 'dart:math';
import 'package:flutter/material.dart';

class MemoriesHeaderCard extends StatelessWidget {
  final bool isDark;
  final Color primary;
  final int memoriesCount;

  const MemoriesHeaderCard({
    super.key,
    required this.isDark,
    required this.primary,
    required this.memoriesCount,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFFC75B9B), const Color(0xFF6B3357)]
                : [const Color(0xFFFF80BF), const Color(0xFFFFB6D9)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // زخارف دائرية شفافة في الخلفية
            Positioned(
              top: -30,
              left: -20,
              child: _decorCircle(90, 0.10),
            ),
            Positioned(
              bottom: -40,
              right: -30,
              child: _decorCircle(120, 0.08),
            ),
            Positioned(
              top: 20,
              right: 40,
              child: Transform.rotate(
                angle: -pi / 10,
                child: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white.withOpacity(0.12),
                  size: 46,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'كل لحظة معاكِ...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ذكرى تستحق إنها تفضل في القلب للأبد ❤️',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.collections_bookmark_rounded,
                          color: Colors.white, size: 15),
                      const SizedBox(width: 6),
                      Text(
                        '$memoriesCount ذكرى محفوظة',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
}