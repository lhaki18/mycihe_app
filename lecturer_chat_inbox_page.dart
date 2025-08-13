import 'package:flutter/material.dart';

class LecturerChatInboxPage extends StatelessWidget {
  LecturerChatInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(child: Text('Lecturer chat inbox (empty)')),
    );
  }
}
