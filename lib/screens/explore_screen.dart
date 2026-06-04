import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const LatLng surabaya = LatLng(
      -7.2575,
      112.7521,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: surabaya,
          zoom: 12,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('surabaya_marker'),
            position: surabaya,
            infoWindow: InfoWindow(
              title: 'Surabaya',
              snippet: 'Hidden Gems Test Location',
            ),
          ),
        },
      ),
    );
  }
}