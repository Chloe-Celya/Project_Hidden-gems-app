import 'package:flutter/material.dart';

import '../models/spot.dart';
import '../services/spot_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spotService = SpotService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WhisperMap'),
        backgroundColor: const Color.fromARGB(255, 102, 207, 153),
        foregroundColor: const Color.fromARGB(255, 241, 233, 233),
        elevation: 0,
      ),
      body: StreamBuilder<List<Spot>>(
        stream: spotService.getSpots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          final spots = snapshot.data ?? [];

          if (spots.isEmpty) {
            return const Center(
              child: Text(
                'No hidden spots added yet',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(
                    Icons.place,
                    color: Color.fromARGB(255, 102, 207, 153),
                  ),
                  title: Text(
                    spot.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        spot.category,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        spot.description,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await spotService.deleteSpot(
                        spot.id,
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Spot deleted',
                            ),
                          ),
                        );
                      }
                    },
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