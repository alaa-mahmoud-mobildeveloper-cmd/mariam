enum MemoryIcon { heart, sparkle, star }

class Memory {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final MemoryIcon icon;
  final List<String> photos; // Base64 strings بدل روابط

  const Memory({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.icon,
    this.photos = const [],
  });
}