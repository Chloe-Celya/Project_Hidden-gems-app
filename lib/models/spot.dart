import 'package:cloud_firestore/cloud_firestore.dart';

class Spot {
  final String id;
  final String name;
  final String description;
  final String category;
  final String createdBy;      // userId
  final String authorName;     // display name
  final DateTime? createdAt;

  Spot({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.createdBy,
    this.authorName = 'Anonymous',
    this.createdAt,
  });

  factory Spot.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Spot(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      createdBy: data['createdBy'] ?? '',
      authorName: data['authorName'] ?? 'Anonymous',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'createdBy': createdBy,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}