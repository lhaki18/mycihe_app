import 'package:flutter/material.dart';

class LecturerClassesPage extends StatelessWidget {
  LecturerClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Classes')),
      body: const Center(child: Text('Your units & rosters (empty)')),
    );
  }
}
