import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhisperMap'),
        backgroundColor: const Color.fromARGB(255, 102, 207, 153),
        foregroundColor: const Color.fromARGB(255, 241, 233, 233),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Home Screen — coming soon'),
      ),
    );
  }
}