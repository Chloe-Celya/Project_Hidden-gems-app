import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String reviewId;
  final String spotId;
  final String userId;
  final String userName;
  final String userPhoto;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.reviewId,
    required this.spotId,
    required this.userId,
    required this.userName,
    required this.userPhoto,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'reviewId': reviewId,
        'spotId': spotId,
        'userId': userId,
        'userName': userName,
        'userPhoto': userPhoto,
        'rating': rating,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      };

  factory ReviewModel.fromMap(Map<String, dynamic> map) => ReviewModel(
        reviewId: map['reviewId'] ?? '',
        spotId: map['spotId'] ?? '',
        userId: map['userId'] ?? '',
        userName: map['userName'] ?? '',
        userPhoto: map['userPhoto'] ?? '',
        rating: (map['rating'] ?? 0).toDouble(),
        comment: map['comment'] ?? '',
        createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
}