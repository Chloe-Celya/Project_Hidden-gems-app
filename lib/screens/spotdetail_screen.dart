import 'package:flutter/material.dart';
import '../screens/review_section.dart';

class SpotDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spotName),
        backgroundColor: const Color(0xFF1D9E75),
        foregroundColor: Colors.white,
        elevation: 0,
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
              spotId: spotId,
              spotOwnerId: spotOwnerId,
            ),
          ],
        ),
      ),
    );
  }
}
