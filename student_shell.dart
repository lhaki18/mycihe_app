import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'student_home_page.dart';
import '../announcements/announcements_page.dart';
import '../chat/chat_page.dart';
import '../chat/new_chat_page.dart';
import '../profile/profile_page.dart';

class StudentShell extends StatefulWidget {
  final String displayName;
  const StudentShell({super.key, required this.displayName});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      StudentHomePage(name: widget.displayName),
      const AnnouncementsPage(),
      const ChatPage(),
      ProfilePage(name: widget.displayName),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(['Home', 'Announcements', 'Chats', 'Profile'][_current]),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications),
          )
        ],
      ),
      body: pages[_current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        onTap: (i) => setState(() => _current = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: kNavy,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Announcements'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      // Show + button only on the Chat tab
      floatingActionButton: _current == 2
          ? FloatingActionButton(
        tooltip: 'New message',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewChatPage()),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
