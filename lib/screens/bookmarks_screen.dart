import 'package:flutter/material.dart';
import '../services/bookmarks_service.dart';
import '../screens/spotdetail_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarksService = BookmarksService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Spots'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ValueListenableBuilder<List<BookmarkedSpot>>(
        valueListenable: bookmarksService.bookmarks,
        builder: (context, spots, _) {
          if (spots.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No saved spots yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: spots.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final spot = spots[index];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF1D9E75),
                  child: Icon(Icons.place, color: Colors.white),
                ),
                title: Text(
                  spot.spotName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Quick-remove button
                    IconButton(
                      tooltip: 'Remove bookmark',
                      icon: const Icon(Icons.bookmark,
                          color: Color(0xFF1D9E75)),
                      onPressed: () => bookmarksService.toggle(spot),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SpotDetailScreen(
                      spotId: spot.spotId,
                      spotName: spot.spotName,
                      spotOwnerId: spot.spotOwnerId,
                      latitude: spot.latitude,
                      longitude: spot.longitude,
                      imageUrl: '',
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}