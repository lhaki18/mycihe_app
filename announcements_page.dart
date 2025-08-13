import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/announcement.dart';
import 'announcement_detail_page.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <Announcement>[
      Announcement(
        id: 'a1',
        senderName: 'Ayaz Raza',
        senderEmail: 'ayaz.raza@cihe.edu.au',
        title: 'Assignment Deadline',
        subtitle: 'ICT302 • Data Structures',
        body: 'Dear students,\n\nThis is a reminder to submit your Assignment 3 by 4:00 PM today. '
            'Late submissions may incur penalties as per the unit outline.\n\nThanks.',
        postedAt: DateTime.now(),
      ),
      Announcement(
        id: 'a2',
        senderName: 'Karma Suii',
        senderEmail: 'karmasuii@cihe.edu.au',
        title: 'ICT304 Attendance',
        subtitle: 'Information Systems',
        body: 'You were marked absent for today\'s ICT304 class. '
            'Please make sure to attend regularly and review today’s materials on Moodle.',
        postedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final ann = items[i];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => AnnouncementDetailPage(ann: ann))),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: kNavy,
                child: Text(
                  ann.senderName.substring(0,1).toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(ann.title, style: const TextStyle(fontWeight: FontWeight.w700, color: kNavy)),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 4),
                Text(ann.subtitle, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 6),
                Text(
                  ann.body.length > 70 ? "${ann.body.substring(0,70)}..." : ann.body,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
              ]),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        );
      },
    );
  }
}
