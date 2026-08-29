/// نوع الأيقونة كـ enum بدل IconData مباشرة،
/// عشان طبقة الـ domain متبقاش معتمدة على Flutter UI.
enum MemoryIcon { heart, sparkle, star }

/// الكيان الأساسي للذكرى - مفيهوش أي منطق UI أو تنسيق.
class Memory {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final MemoryIcon icon;

  const Memory({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.icon,
  });
}