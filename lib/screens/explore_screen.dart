import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/spot.dart';
import '../services/spot_service.dart';
import 'spotdetail_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const LatLng surabaya = LatLng(
      -7.2575,
      112.7521,
    );

    final spotService = SpotService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<List<Spot>>(
        stream: spotService.getSpots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final spots = snapshot.data!;

          final markers = spots.map((spot) {
            return Marker(
              markerId: MarkerId(spot.id),
              position: LatLng(
                spot.latitude,
                spot.longitude,
              ),
              infoWindow: InfoWindow(
                title: spot.name,
                snippet: spot.category,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SpotDetailScreen(
                      spotId: spot.id,
                      spotName: spot.name,
                      spotOwnerId: spot.createdBy,
                      latitude: spot.latitude,
                      longitude: spot.longitude,
                      imageUrl: spot.imageUrl,
                    ),
                  ),
                );
              },
            );
          }).toSet();

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: surabaya,
                  zoom: 12,
                ),
                markers: markers,
              ),

              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {},
                  child: Text(
                    spots.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}