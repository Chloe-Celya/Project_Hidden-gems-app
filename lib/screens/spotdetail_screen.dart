import 'package:flutter/material.dart';
import '../screens/review_section.dart';
import '../services/bookmarks_service.dart';

class SpotDetailScreen extends StatefulWidget {
  final String spotId;
  final String spotName;
  final String spotOwnerId;

  const SpotDetailScreen({
    super.key,
    required this.spotId,
    required this.spotName,
    required this.spotOwnerId,
  });

  @override
  State<SpotDetailScreen> createState() => _SpotDetailScreenState();
}

class _SpotDetailScreenState extends State<SpotDetailScreen> {
  final _bookmarks = BookmarksService.instance;

  bool get _isBookmarked => _bookmarks.isBookmarked(widget.spotId);

  void _toggleBookmark() {
    _bookmarks.toggle(BookmarkedSpot(
      spotId: widget.spotId,
      spotName: widget.spotName,
      spotOwnerId: widget.spotOwnerId,
    ));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
              ? '${widget.spotName} saved to bookmarks'
              : '${widget.spotName} removed from bookmarks',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<BookmarkedSpot>>(
      valueListenable: _bookmarks.bookmarks,
      builder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.spotName),
            backgroundColor: const Color(0xFF1D9E75),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                tooltip: _isBookmarked ? 'Remove bookmark' : 'Save spot',
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: _toggleBookmark,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.place, size: 64, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                ReviewsSection(
                  spotId: widget.spotId,
                  spotOwnerId: widget.spotOwnerId,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}