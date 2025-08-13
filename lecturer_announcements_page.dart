import 'package:flutter/material.dart';

class LecturerAnnouncementsPage extends StatelessWidget {
  LecturerAnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: const Center(child: Text('Lecturer announcements (empty)')),
    );
  }
}
