import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/spot.dart';

class SpotService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String collection = 'spots';

  User? get currentUser => _auth.currentUser;

  bool isOwner(String createdBy) =>
      currentUser?.uid == createdBy;

  Future<void> addSpot({
    required String name,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
  }) async {
    final user = currentUser!;

    final spot = Spot(
      id: '',
      name: name,
      description: description,
      category: category,
      createdBy: user.uid,
      authorName:
          user.displayName ?? 'Anonymous',
      latitude: latitude,
      longitude: longitude,
    );

    await _db
        .collection(collection)
        .add(
          spot.toFirestore(),
        );
  }

  Stream<List<Spot>> getSpots() {
    return _db
        .collection(collection)
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Spot.fromFirestore(
                  doc.data(),
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  Future<void> updateSpot(
    Spot spot,
  ) async {
    await _db
        .collection(collection)
        .doc(spot.id)
        .update({
      'name': spot.name,
      'description': spot.description,
      'category': spot.category,
      'latitude': spot.latitude,
      'longitude': spot.longitude,
    });
  }

  Future<void> deleteSpot(
    String id,
    String createdBy,
  ) async {
    await _db
        .collection(collection)
        .doc(id)
        .delete();
  }
}