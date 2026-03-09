class Option {
  final int id;
  final String name;
  final int point;
  final String imagePath;
  final String? description; // 可选字段

  Option({
    required this.id,
    required this.name,
    required this.point,
    required this.imagePath,
    this.description,
  });
}
