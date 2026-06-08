import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // CREATE
  Future<void> addReview({
    required String spotId,
    required double rating,
    required String comment,
  }) async {
    final user = currentUser!;
    final ref = _db.collection('reviews').doc();
    final review = ReviewModel(
      reviewId: ref.id,
      spotId: spotId,
      userId: user.uid,
      userName: user.displayName ?? 'Anonymous',
      userPhoto: user.photoURL ?? '',
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    await ref.set(review.toMap());
    await _updateSpotRating(spotId);
  }

  // READ
  Stream<List<ReviewModel>> getReviews(String spotId) {
  return _db
      .collection('reviews')
      .where('spotId', isEqualTo: spotId)
      .snapshots()
      .map((snap) {
        final list =
            snap.docs.map((d) => ReviewModel.fromMap(d.data())).toList();
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      });
}

  // UPDATE
  Future<void> updateReview({
    required String reviewId,
    required String spotId,
    required double rating,
    required String comment,
  }) async {
    await _db.collection('reviews').doc(reviewId).update({
      'rating': rating,
      'comment': comment,
    });
    await _updateSpotRating(spotId);
  }

  // DELETE
  Future<void> deleteReview({
    required String reviewId,
    required String spotId,
  }) async {
    await _db.collection('reviews').doc(reviewId).delete();
    await _updateSpotRating(spotId);
  }

  //auto update
  Future<void> _updateSpotRating(String spotId) async {
    final snap = await _db
        .collection('reviews')
        .where('spotId', isEqualTo: spotId)
        .get();

    if (snap.docs.isEmpty) {
      await _db.collection('spots').doc(spotId).update({
        'avgRating': 0.0,
        'reviewCount': 0,
      });
      return;
    }

    final ratings = snap.docs.map((d) => (d['rating'] as num).toDouble());
    final avg = ratings.reduce((a, b) => a + b) / ratings.length;

    await _db.collection('spots').doc(spotId).update({
      'avgRating': double.parse(avg.toStringAsFixed(1)),
      'reviewCount': snap.docs.length,
    });
  }

  bool isOwner(String userId) => currentUser?.uid == userId;
}