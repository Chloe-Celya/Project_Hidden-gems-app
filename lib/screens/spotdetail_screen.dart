import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/review_section.dart';
import '../services/bookmarks_service.dart';

class SpotDetailScreen extends StatefulWidget {
  final String spotId;
  final String spotName;
  final String spotOwnerId;

  final double latitude;
  final double longitude;

  const SpotDetailScreen({
    super.key,
    required this.spotId,
    required this.spotName,
    required this.spotOwnerId,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<SpotDetailScreen> createState() => _SpotDetailScreenState();
}

class _SpotDetailScreenState extends State<SpotDetailScreen> {
  final _bookmarks = BookmarksService.instance;

  bool get _isBookmarked =>
      _bookmarks.isBookmarked(widget.spotId);

  void _toggleBookmark() {
    _bookmarks.toggle(
      BookmarkedSpot(
        spotId: widget.spotId,
        spotName: widget.spotName,
        spotOwnerId: widget.spotOwnerId,
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
    );

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
                tooltip: _isBookmarked
                    ? 'Remove bookmark'
                    : 'Save spot',
                icon: Icon(
                  _isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
                onPressed: _toggleBookmark,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition:
                          CameraPosition(
                        target: LatLng(
                          widget.latitude,
                          widget.longitude,
                        ),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(
                            widget.spotId,
                          ),
                          position: LatLng(
                            widget.latitude,
                            widget.longitude,
                          ),
                          infoWindow: InfoWindow(
                            title:
                                widget.spotName,
                          ),
                        ),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled:
                          false,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                ReviewsSection(
                  spotId: widget.spotId,
                  spotOwnerId:
                      widget.spotOwnerId,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}