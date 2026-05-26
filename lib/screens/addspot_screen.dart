import 'package:flutter/material.dart';

class AddSpotScreen extends StatelessWidget {
  const AddSpotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Spot'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Add Spot Screen — coming soon'),
      ),
    );
  }
}