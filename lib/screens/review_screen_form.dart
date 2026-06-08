import 'package:flutter/material.dart';
import '../../models/review_model.dart';
import '../../services/review_service.dart';
import '../../widgets/star_rating.dart';

class ReviewForm extends StatefulWidget {
  final String spotId;
  final ReviewModel? existing; // null = add, non-null = edit

  const ReviewForm({super.key, required this.spotId, this.existing});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _commentCtrl = TextEditingController();
  final _service = ReviewService();
  double _rating = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _rating = widget.existing!.rating;
      _commentCtrl.text = widget.existing!.comment;
    }
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      _showError('Please select a rating');
      return;
    }
    if (_commentCtrl.text.trim().isEmpty) {
      _showError('Please write a comment');
      return;
    }
    setState(() => _loading = true);
    try {
      if (widget.existing == null) {
        await _service.addReview(
          spotId: widget.spotId,
          rating: _rating,
          comment: _commentCtrl.text.trim(),
        );
      } else {
        await _service.updateReview(
          reviewId: widget.existing!.reviewId,
          spotId: widget.spotId,
          rating: _rating,
          comment: _commentCtrl.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.existing == null ? 'Write a Review' : 'Edit Review',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Your rating',
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          StarRating(
            rating: _rating,
            size: 36,
            interactive: true,
            onRatingChanged: (r) => setState(() => _rating = r),
          ),
          const SizedBox(height: 20),
          const Text('Your comment',
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: _commentCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your experience...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: Color(0xFF1D9E75), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9E75),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      widget.existing == null ? 'Submit Review' : 'Save Changes',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}