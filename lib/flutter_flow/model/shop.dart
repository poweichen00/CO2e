import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  final String name;
  final int price;
  final String imagePath;
  final String description;

  Shop({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
  });

  factory Shop.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Safely cast to Map
    if (data == null) {
      // Handle case where document data is null
      return Shop(name: '', price: 0, imagePath: '', description: '');
    }
    return Shop(
      name: data['name'] ?? '',
      price: int.tryParse(data['price']?.toString() ?? '') ?? 0,
      imagePath: data['imagePath'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
