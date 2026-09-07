import 'package:flutter/material.dart';

class AudioPreview {
  final String title;
  final String category;
  final String duration;
  final IconData icon;
  final Color color;
  final bool favorite;

  const AudioPreview({
    required this.title,
    required this.category,
    required this.duration,
    required this.icon,
    required this.color,
    this.favorite = false,
  });
}
