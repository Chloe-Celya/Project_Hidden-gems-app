import 'package:flutter/material.dart';
import '../models/spot.dart';
import '../services/spot_service.dart';
import '../screens/spotdetail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spotService = SpotService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WhisperMap'),
        backgroundColor: const Color(0xFF1D9E75),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<Spot>>(
        stream: spotService.getSpots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final spots = snapshot.data ?? [];

          if (spots.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.explore_off, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No hidden spots yet',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              final isOwner = spotService.isOwner(spot.createdBy);

              return GestureDetector(
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
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(Icons.place,
                              color: Color(0xFF1D9E75), size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(spot.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1D9E75)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(spot.category,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF1D9E75),
                                        fontWeight: FontWeight.w500)),
                              ),
                              const SizedBox(height: 6),
                              Text(spot.description,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black87)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person_outline,
                                      size: 13, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    isOwner
                                        ? '${spot.authorName} (you)'
                                        : spot.authorName,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isOwner)
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Color(0xFF1D9E75), size: 20),
                                onPressed: () => showEditDialog(
                                    context, spot, spotService),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent, size: 20),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete spot?'),
                                      content: const Text(
                                          'This action cannot be undone.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red))),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await spotService.deleteSpot(
                                        spot.id, spot.createdBy);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Spot deleted')));
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                      ],
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
Future<void> showEditDialog(
  BuildContext context,
  Spot spot,
  SpotService spotService,
) async {
  final nameController = TextEditingController(text: spot.name);
  final descriptionController =
      TextEditingController(text: spot.description);
  final categoryController = TextEditingController(text: spot.category);
  final ageController = TextEditingController(text: spot.age);
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Spot'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedSpot = Spot(
                id: spot.id,
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                category: categoryController.text.trim(),
                age: ageController.text.trim(),
                createdBy: spot.createdBy,
                authorName: spot.authorName,
              );
              Navigator.pop(context);
              await spotService.updateSpot(updatedSpot);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D9E75),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}