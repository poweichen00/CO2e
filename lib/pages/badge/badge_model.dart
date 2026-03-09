class AchievementBadge {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final int voucher;
  bool unlocked;

  AchievementBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.voucher,
    this.unlocked = false,
  });
}
