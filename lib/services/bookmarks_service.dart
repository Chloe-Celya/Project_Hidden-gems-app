import 'package:flutter/foundation.dart';
import 'notification_service.dart';

class BookmarkedSpot {
  final String spotId;
  final String spotName;
  final String spotOwnerId;

  final double latitude;
  final double longitude;

  const BookmarkedSpot({
    required this.spotId,
    required this.spotName,
    required this.spotOwnerId,
    required this.latitude,
    required this.longitude,
  });
}

class BookmarksService {
  BookmarksService._();

  static final BookmarksService instance =
      BookmarksService._();

  final ValueNotifier<List<BookmarkedSpot>>
      bookmarks =
      ValueNotifier<List<BookmarkedSpot>>([]);

  bool isBookmarked(String spotId) =>
      bookmarks.value.any(
        (s) => s.spotId == spotId,
      );

  void toggle(BookmarkedSpot spot) {
    final current =
        List<BookmarkedSpot>.from(
      bookmarks.value,
    );

    final index = current.indexWhere(
      (s) => s.spotId == spot.spotId,
    );

    final wasAdded = index < 0;

    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(spot);
    }

    bookmarks.value = current;

    NotificationService.instance.onBookmarkToggled(
      spotId: spot.spotId,
      spotName: spot.spotName,
      ownerId: spot.spotOwnerId,
      wasAdded: wasAdded,
    );
  }
}