import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/message.dart';

class ConversationPage extends StatefulWidget {
  final String peerName;
  final String peerEmail;
  final Color avatarColor;
  final List<Message> messages;

  const ConversationPage({
    super.key,
    required this.peerName,
    required this.peerEmail,
    required this.avatarColor,
    required this.messages,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  late List<Message> _msgs;

  @override
  void initState() {
    super.initState();
    _msgs = List.of(widget.messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: widget.avatarColor,
              child: Text(
                widget.peerName.substring(0,1).toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.peerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text(widget.peerEmail, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            ]),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              itemCount: _msgs.length,
              itemBuilder: (context, i) {
                final m = _msgs[i];
                final isMe = m.senderId == 'student';
                return _MessageBubble(
                  text: m.text,
                  time: _timeLabel(m.sentAt),
                  isMe: isMe,
                );
              },
            ),
          ),
          _Composer(
            controller: _input,
            onSend: _handleSend,
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'student',
        text: text,
        sentAt: DateTime.now(),
      ));
      _input.clear();
    });

    // Scroll to newest
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _timeLabel(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final mm = d.minute.toString().padLeft(2, '0');
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    return '$h:$mm $ampm';
  }
}

/* -------------------- widgets -------------------- */

class _MessageBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;

  const _MessageBubble({
    required this.text,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? kNavy : const Color(0xFFEFF3F8);
    final fg = isMe ? Colors.white : Colors.black87;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(4),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(4),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(isMe ? 60 : 8, 6, isMe ? 8 : 60, 6),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: bg, borderRadius: radius, boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
            ]),
            child: Text(text, style: TextStyle(color: fg, height: 1.3)),
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(fontSize: 11, color: Colors.black45)),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _Composer({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Type your message…',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onSend,
              icon: const Icon(Icons.send_rounded, color: kNavy),
              tooltip: 'Send',
            ),
          ],
        ),
      ),
    );
  }
}
