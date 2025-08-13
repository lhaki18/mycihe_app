import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../widgets/announcement_card.dart';
import '../announcements/announcement_detail_page.dart';
import '../../../models/announcement.dart';

class StudentHomePage extends StatelessWidget {
  final String name;
  const StudentHomePage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, $name 👋',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: kNavy),
          ),
          const SizedBox(height: 18),
          Text(
            'Recent Announcements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          // Card 1 (tappable)
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              final ann = Announcement(
                id: 'a1',
                senderName: 'Ayaz Raza',
                senderEmail: 'ayaz.raza@cihe.edu.au',
                title: 'Assignment Deadline',
                subtitle: 'ICT302 • Data Structures',
                body:
                'Don’t forget to submit your assignment by the deadline.\n\nSubmission closes at 4:00 PM today.',
                postedAt: DateTime.now(),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnnouncementDetailPage(ann: ann),
                ),
              );
            },
            child: const AnnouncementCard(
              senderName: 'Ayaz Raza',
              avatarColor: kNavy,
              title: 'Assignment Deadline',
              subtitle: 'ICT302 • Data Structures',
              meta: 'Due Today • 4:00 PM',
              body: 'Don’t forget to submit your assignment by the deadline.',
              senderEmail: 'ayaz.raza@cihe.edu.au',
            ),
          ),
          const SizedBox(height: 12),

          // Card 2 (tappable)
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              final ann = Announcement(
                id: 'a2',
                senderName: 'Karma Suii',
                senderEmail: 'karmasuii@cihe.edu.au',
                title: 'ICT304 Attendance',
                subtitle: 'Information Systems',
                body:
                'You were marked absent. Please attend regularly and review today’s materials.',
                postedAt: DateTime.now().subtract(const Duration(days: 1)),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnnouncementDetailPage(ann: ann),
                ),
              );
            },
            child: const AnnouncementCard(
              senderName: 'Karma Suii',
              avatarColor: Colors.deepPurple,
              title: 'ICT304 Attendance',
              subtitle: 'Information Systems',
              meta: 'Recorded: Sep 16',
              body: 'You were marked absent. Please attend regularly.',
              senderEmail: 'karmasuii@cihe.edu.au',
            ),
          ),
        ],
      ),
    );
  }
}
