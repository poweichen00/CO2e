import '../../backend/backend.dart';

class Coupon {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final String imagePath;

  Coupon({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.quantity,
  });

  // Factory constructor to create a Coupon from Firestore document
  factory Coupon.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Coupon(
      id: doc.id, // Assign the document ID to the id field
      name: data['name'] ?? '',
      imagePath: data['imagePath'] ?? '',
      description: data['description'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }
}
