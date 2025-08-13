import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class LecturerHomePage extends StatelessWidget {
  final String lecturerName;
  final VoidCallback? onComposeAnnouncement;
  final VoidCallback? onNewMessage;
  final VoidCallback? onOpenAnnouncements;
  final VoidCallback? onOpenChat;

  const LecturerHomePage({
    super.key,
    required this.lecturerName,
    this.onComposeAnnouncement,
    this.onNewMessage,
    this.onOpenAnnouncements,
    this.onOpenChat,
  });

  @override
  Widget build(BuildContext context) {
    final first = lecturerName.trim().split(RegExp(r'\s+')).first;

    return Scaffold(
      appBar: AppBar(title: const Text('Lecturer Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderCard(firstName: first),
            const SizedBox(height: 16),
            _QuickActions(
              onCompose: onComposeAnnouncement ??
                      () => _snack(context, 'Compose Announcement (stub)'),
              onNewMessage: onNewMessage ??
                      () => _snack(context, 'New Message (stub)'),
            ),
            const SizedBox(height: 16),
            _TodayStrip(
              unreadChats: 2,
              recentAnnouncements: 1,
              onOpenAnnouncements: onOpenAnnouncements ??
                      () => _snack(context, 'Open Announcements (stub)'),
              onOpenChat: onOpenChat ??
                      () => _snack(context, 'Open Chat (stub)'),
            ),
            const SizedBox(height: 16),
            const _SectionTitle('Recent activity'),
            const SizedBox(height: 8),
            // keep only 3–4 items so this page stays light
            _ActivityList(items: const [
              _ActivityItem(
                icon: Icons.campaign_outlined,
                color: kNavy,
                title: 'ICT307: Class postponed',
                subtitle: 'Posted 2h ago',
              ),
              _ActivityItem(
                icon: Icons.mark_chat_unread_outlined,
                color: Colors.teal,
                title: 'Pema Dema replied',
                subtitle: '“I will be late to lab today…”',
              ),
              _ActivityItem(
                icon: Icons.campaign_outlined,
                color: Colors.indigo,
                title: 'ICT301: Guest talk next week',
                subtitle: 'Posted Mon',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

/* ---------- pieces ---------- */

class _HeaderCard extends StatelessWidget {
  final String firstName;
  const _HeaderCard({required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kNavy, kNavy.withOpacity(0.88)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hi, $firstName 👋',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 6),
          const Text(
            'Quick actions to get you started.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onCompose;
  final VoidCallback onNewMessage;

  const _QuickActions({
    required this.onCompose,
    required this.onNewMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuickActionCard(
          icon: Icons.campaign,
          title: 'Compose announcement',
          onTap: onCompose,
        ),
        const SizedBox(width: 12),
        _QuickActionCard(
          icon: Icons.chat_bubble_rounded,
          title: 'New message',
          onTap: onNewMessage,
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF3F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: kNavy),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: kNavy,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayStrip extends StatelessWidget {
  final int unreadChats;
  final int recentAnnouncements;
  final VoidCallback onOpenAnnouncements;
  final VoidCallback onOpenChat;

  const _TodayStrip({
    required this.unreadChats,
    required this.recentAnnouncements,
    required this.onOpenAnnouncements,
    required this.onOpenChat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TodayTile(
          icon: Icons.mark_chat_unread,
          label: 'Unread chats',
          value: unreadChats.toString(),
          onTap: onOpenChat,
        ),
        const SizedBox(width: 12),
        _TodayTile(
          icon: Icons.campaign_outlined,
          label: 'New announcements',
          value: recentAnnouncements.toString(),
          onTap: onOpenAnnouncements,
        ),
      ],
    );
  }
}

class _TodayTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TodayTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE7ECF5)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: kNavy.withOpacity(0.08),
                  child: Icon(icon, color: kNavy, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.black87)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kNavy,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  final List<_ActivityItem> items;
  const _ActivityList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => _ActivityTile(item: items[i]),
    );
  }
}

class _ActivityItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _ActivityItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}

class _ActivityTile extends StatelessWidget {
  final _ActivityItem item;
  const _ActivityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: item.color.withOpacity(0.1),
          child: Icon(item.icon, color: item.color),
        ),
        title: Text(item.title,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(item.subtitle),
        onTap: () {}, // open detail later
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kNavy),
    );
  }
}
