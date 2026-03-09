import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String eventName;
  final double carbonFootprint;

  Event({
    required this.id,
    required this.eventName,
    required this.carbonFootprint,
  });

  factory Event.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      eventName: data['eventName'] ?? '',
      carbonFootprint: (data['carbonFootprint'] ?? 0).toDouble(),
    );
  }
}