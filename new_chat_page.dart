import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/message.dart';
import 'conversation_page.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _firstMessage = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _firstMessage.dispose();
    super.dispose();
  }

  void _startConversation() {
    if (!_formKey.currentState!.validate()) return;

    final email = _email.text.trim();
    final displayName = _name.text.trim().isEmpty ? email : _name.text.trim();
    final msg = _firstMessage.text.trim();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ConversationPage(
          peerName: displayName,
          peerEmail: email,
          avatarColor: kNavy,
          messages: [
            Message(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              senderId: 'student',
              text: msg,
              sentAt: DateTime.now(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Message')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Lecturer/Admin email',
                hintText: 'e.g. ayaz.raza@cihe.edu.au',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter an email';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name (optional)',
                hintText: 'Ayaz Raza',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _firstMessage,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Type your message…',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Write a message' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startConversation,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Send'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
