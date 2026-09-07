enum DhikrCategory { morning, evening }

class DhikrItem {
  final String text;
  final int repeatCount;
  final String? note;

  const DhikrItem({
    required this.text,
    required this.repeatCount,
    this.note,
  });
}