import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/spot_service.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart';
import 'dart:io';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() =>
      _AddSpotScreenState();
}

class _AddSpotScreenState
    extends State<AddSpotScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController =
      TextEditingController();

  final _descriptionController =
      TextEditingController();

  final _categoryController =
      TextEditingController();

  final _ageController =
      TextEditingController();

  final SpotService _spotService =
      SpotService();

  bool isLoading = false;

  LatLng? selectedLocation;

  static const LatLng surabaya =
      LatLng(
    -7.2575,
    112.7521,
  );

  final CloudinaryService _cloudinaryService =
      CloudinaryService();
  File? selectedImage;
  final ImagePicker _picker =
      ImagePicker();

  Future<void> pickImage() async {
    final XFile? image =
        await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> saveSpot() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedLocation == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a location on the map',
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    String imageUrl = '';
    if (selectedImage != null) {
      final uploadedUrl = await _cloudinaryService.uploadImage(selectedImage!);
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
      }
    }

    await _spotService.addSpot(
      name: _nameController.text.trim(),
      description:
          _descriptionController.text.trim(),
      category:
          _categoryController.text.trim(),
      age: 
          _ageController.text.trim(),
      imageUrl: imageUrl,
      latitude:
          selectedLocation!.latitude,
      longitude:
          selectedLocation!.longitude,
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = selectedLocation == null
        ? <Marker>{}
        : {
            Marker(
              markerId:
                  const MarkerId('selected'),
              position: selectedLocation!,
            ),
          };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Spot'),
        backgroundColor:
            const Color(0xFF1D9E75),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller:
                    _nameController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Spot Name',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Please enter a spot name';
                  }
                  return null;
                },
              ),

              const SizedBox(
                  height: 16),

              TextFormField(
                controller:
                    _descriptionController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Description',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),

              const SizedBox(
                  height: 16),

              TextFormField(
                controller:
                    _categoryController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Category',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),

              const SizedBox(
                  height: 16),

              TextFormField(
                controller:
                    _ageController,
                decoration:
                    const InputDecoration(
                  labelText: 'Age',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Please enter an age';
                  }
                  return null;
                },
              ),

              const SizedBox(
                  height: 24),
              
              ElevatedButton.icon(
                onPressed:pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Choose Image'),
              ),
              const SizedBox(height: 16),
              if (selectedImage != null)
                Column(
                  children: [
                    Image.file(
                      selectedImage!,
                      height: 200,
                    ),
                    const SizedBox(height: 16)
                  ],
                ),

              const Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  'Tap the map to select a location',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(
                  height: 12),

              SizedBox(
                height: 300,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                          12),
                  child: GoogleMap(
                    initialCameraPosition:
                        const CameraPosition(
                      target: surabaya,
                      zoom: 12,
                    ),
                    markers: markers,
                    onTap: (position) {
                      setState(() {
                        selectedLocation =
                            position;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(
                  height: 12),

              if (selectedLocation !=
                  null)
                Text(
                  'Selected: ${selectedLocation!.latitude.toStringAsFixed(6)}, ${selectedLocation!.longitude.toStringAsFixed(6)}',
                ),

              const SizedBox(
                  height: 24),

              SizedBox(
                width:
                    double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : saveSpot,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                            0xFF1D9E75),
                    foregroundColor:
                        Colors.white,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Save Spot',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}