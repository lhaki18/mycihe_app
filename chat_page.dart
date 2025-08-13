import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/message.dart';
import 'conversation_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock chat list (last message preview + unread count)
    final chats = [
      _ChatItem(
        peerName: 'Ayaz Raza',
        peerEmail: 'ayaz.raza@cihe.edu.au',
        color: kNavy,
        lastMessage: 'Please remember to upload by 4 PM.',
        time: '10:12 AM',
        unread: 2,
        conversation: _sampleConversationWithAyaz(),
      ),
      _ChatItem(
        peerName: 'Karma Suii',
        peerEmail: 'karmasuii@cihe.edu.au',
        color: Colors.deepPurple,
        lastMessage: 'Let me know if you have questions.',
        time: 'Yesterday',
        unread: 0,
        conversation: _sampleConversationWithKarma(),
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final c = chats[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: c.color,
            child: Text(
              c.peerName.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(c.peerName, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(
            c.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(c.time, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              if (c.unread > 0) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  child: Text('${c.unread}',
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConversationPage(
                  peerName: c.peerName,
                  peerEmail: c.peerEmail,
                  avatarColor: c.color,
                  messages: c.conversation,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/* ---------- helpers & mock data ---------- */

class _ChatItem {
  final String peerName;
  final String peerEmail;
  final Color color;
  final String lastMessage;
  final String time;
  final int unread;
  final List<Message> conversation;

  _ChatItem({
    required this.peerName,
    required this.peerEmail,
    required this.color,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.conversation,
  });
}

List<Message> _sampleConversationWithAyaz() => [
  Message(id: 'm1', senderId: 'lecturer', text: 'Hi, please remember to upload Assignment 3.', sentAt: DateTime.now().subtract(const Duration(minutes: 18))),
  Message(id: 'm2', senderId: 'student',  text: 'Hi Sir, noted! Is PDF okay?', sentAt: DateTime.now().subtract(const Duration(minutes: 15))),
  Message(id: 'm3', senderId: 'lecturer', text: 'Yes, PDF is fine. Submit by 4:00 PM.', sentAt: DateTime.now().subtract(const Duration(minutes: 10)), isRead: false),
  Message(id: 'm4', senderId: 'lecturer', text: 'Ping me if you face issues.', sentAt: DateTime.now().subtract(const Duration(minutes: 9)), isRead: false),
];

List<Message> _sampleConversationWithKarma() => [
  Message(id: 'k1', senderId: 'student',  text: 'Good afternoon!', sentAt: DateTime.now().subtract(const Duration(days: 1, minutes: 52))),
  Message(id: 'k2', senderId: 'lecturer', text: 'Good afternoon. How can I help?', sentAt: DateTime.now().subtract(const Duration(days: 1, minutes: 50))),
  Message(id: 'k3', senderId: 'student',  text: 'I missed today’s class, could I get the slides?', sentAt: DateTime.now().subtract(const Duration(days: 1, minutes: 45))),
  Message(id: 'k4', senderId: 'lecturer', text: 'Sure, I’ve uploaded them to Moodle. Let me know if you have questions.', sentAt: DateTime.now().subtract(const Duration(days: 1, minutes: 40))),
];
