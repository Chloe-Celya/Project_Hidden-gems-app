import 'package:flutter/material.dart';
import '../../models/review_model.dart';
import '../../services/review_service.dart';
import '../../widgets/review_card.dart';
import '../../widgets/star_rating.dart';
import 'review_screen_form.dart';

class ReviewsSection extends StatefulWidget {
  final String spotId;
  final String spotOwnerId;

  const ReviewsSection({super.key, required this.spotId, required this.spotOwnerId});

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final _service = ReviewService();

  void _openReviewForm({ReviewModel? existing}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ReviewForm(
        spotId: widget.spotId,
        existing: existing,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewModel>>(
      stream: _service.getReviews(widget.spotId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }if (snap.hasError) {
       return Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Error: ${snap.error}'),
  );
}

        final reviews = snap.data ?? [];
        final avgRating = reviews.isEmpty
            ? 0.0
            : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                reviews.length;

      
       final isSpotOwner = _service.currentUser?.uid == widget.spotOwnerId;
       final alreadyReviewed = reviews.any((r) => r.userId == _service.currentUser?.uid);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Reviews',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    if (reviews.isNotEmpty)
                      Row(
                        children: [
                          StarRating(rating: avgRating, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '${avgRating.toStringAsFixed(1)} (${reviews.length})',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                  ],
                ),
              if (!isSpotOwner && !alreadyReviewed)
                  ElevatedButton.icon(
                    onPressed: () => _openReviewForm(),
                    icon: const Icon(Icons.rate_review_outlined, size: 16),
                    label: const Text('Review'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D9E75),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Reviews list
            if (reviews.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.rate_review_outlined,
                        size: 32, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No reviews yet. Be the first!',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            else
              ...reviews.map((r) => ReviewCard(
                    review: r,
                    onChanged: () => setState(() {}),
                  )),
          ],
        );
      },
    );
  }
}