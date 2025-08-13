import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  final String adminName;
  const AdminHomePage({super.key, required this.adminName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Home')),
      body: Center(
        child: Text(
          'Welcome, $adminName (Admin)\n\nAdmin dashboard coming soon…',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
