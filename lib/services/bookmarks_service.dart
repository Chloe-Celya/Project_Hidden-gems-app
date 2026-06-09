import 'package:flutter/foundation.dart';

class BookmarkedSpot {
  final String spotId;
  final String spotName;
  final String spotOwnerId;

  const BookmarkedSpot({
    required this.spotId,
    required this.spotName,
    required this.spotOwnerId,
  });
}

class BookmarksService {
  BookmarksService._();
  static final BookmarksService instance = BookmarksService._();

  final ValueNotifier<List<BookmarkedSpot>> bookmarks =
      ValueNotifier<List<BookmarkedSpot>>([]);

  bool isBookmarked(String spotId) =>
      bookmarks.value.any((s) => s.spotId == spotId);

  void toggle(BookmarkedSpot spot) {
    final current = List<BookmarkedSpot>.from(bookmarks.value);
    final index = current.indexWhere((s) => s.spotId == spot.spotId);
    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(spot);
    }
    bookmarks.value = current;
  }
}