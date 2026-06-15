import 'package:cloud_firestore/cloud_firestore.dart';

class Spot {
  final String id;
  final String name;
  final String description;
  final String category;
  final String age;

  // Cloudinary image URL
  final String imageUrl;

  final String createdBy;
  final String authorName;
  final DateTime? createdAt;

  // Google Maps coordinates
  final double latitude;
  final double longitude;

  Spot({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.age,

    // Cloudinary
    this.imageUrl = '',

    required this.createdBy,
    this.authorName = 'Anonymous',
    this.createdAt,

    // Google Maps
    this.latitude = -7.2575,
    this.longitude = 112.7521,
  });

  factory Spot.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return Spot(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      age: data['age'] ?? '',

      // Cloudinary
      imageUrl: data['imageUrl'] ?? '',

      createdBy: data['createdBy'] ?? '',
      authorName: data['authorName'] ?? 'Anonymous',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),

      latitude: (data['latitude'] ?? -7.2575).toDouble(),
      longitude: (data['longitude'] ?? 112.7521).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'age': age,

      // Cloudinary
      'imageUrl': imageUrl,

      'createdBy': createdBy,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),

      // Google Maps
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}