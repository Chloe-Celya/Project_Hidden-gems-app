import 'package:flutter/material.dart';

class SpotDetailScreen extends StatelessWidget {
  const SpotDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spot Detail'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Spot Detail — coming soon'),
      ),
    );
  }
}