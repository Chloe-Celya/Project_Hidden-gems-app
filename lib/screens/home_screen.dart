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
                      Text(spot.category),
                      const SizedBox(height: 4),
                      Text(spot.description),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 100, 51, 5),
                        ),

                        onPressed: () {
                          showEditDialog(
                            context,
                            spot,
                            spotService,
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 37, 6, 3),
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
                    ],
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

Future<void> showEditDialog(
  BuildContext context,
  Spot spot,
  SpotService spotService,
) async {
  final nameController =
      TextEditingController(text: spot.name);

  final descriptionController =
      TextEditingController(text: spot.description);

  final categoryController =
      TextEditingController(text: spot.category);

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Edit Spot',
        ),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),

              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),

              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final updatedSpot = Spot(
                id: spot.id,
                name: nameController.text,
                description: descriptionController.text,
                category: categoryController.text,
                createdBy: spot.createdBy,
              );

              //fermeture dialog avec modif'
              if (context.mounted) {
                Navigator.pop(context);
              }
              await spotService.updateSpot(
                updatedSpot,
              );

              
            },
            child: const Text(
              'Save',
            ),
          ),
        ],
      );
    },
  );
}