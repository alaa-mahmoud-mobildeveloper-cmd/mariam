import 'package:flutter/material.dart';
import 'package:mariam/features/memories/domain/entities/memory.dart';



IconData iconForMemory(MemoryIcon icon) {
  switch (icon) {
    case MemoryIcon.heart:
      return Icons.favorite_rounded;
    case MemoryIcon.sparkle:
      return Icons.auto_awesome_rounded;
    case MemoryIcon.star:
      return Icons.star_rounded;
  }
}

String formatMemoryDate(DateTime date) {
  const months = [
    'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}