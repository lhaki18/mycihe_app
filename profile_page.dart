import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme.dart';
import '../../../models/student_profile.dart';
import '../../auth/login_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  /// Passed from StudentShell on first load; used only as a fallback.
  final String name;
  const ProfilePage({super.key, required this.name});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _prefsKey = 'student_profile';

  SharedPreferences? _prefs;
  StudentProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs!.getString(_prefsKey);

    if (saved != null) {
      _profile = StudentProfile.fromJsonString(saved);

      // 🔄 If the incoming name (from login) is different, update first/last.
      final incoming = widget.name.trim();
      if (incoming.isNotEmpty && incoming != _profile!.fullName) {
        final parts = incoming.split(RegExp(r'\s+'));
        final first = parts.isNotEmpty ? parts.first : _profile!.firstName;
        final last =
        parts.length > 1 ? parts.sublist(1).join(' ') : _profile!.lastName;
        _profile = _profile!.copyWith(firstName: first, lastName: last);
        await _persistProfile();
      }
    } else {
      // Seed with defaults (use provided name if available)
      final fallBackName =
      widget.name.trim().isEmpty ? 'Namgay Peldon' : widget.name.trim();
      final parts = fallBackName.split(RegExp(r'\s+'));
      final first = parts.isNotEmpty ? parts.first : 'Namgay';
      final last = parts.length > 1 ? parts.sublist(1).join(' ') : 'Peldon';

      _profile = StudentProfile(
        firstName: first,
        lastName: last,
        email: 'CIHE12345@student.cihe.edu.au',
        address: '1 Example St',
        city: 'Sydney',
        country: 'Australia',
        postcode: '2000',
        phone: '+61 400 000 000',
        courses: const [
          'ICT305 Topics in IT | Semester 2 2025',
          'ICT306 Advanced Cyber Security | Semester 2 2025',
          'ICT308 Project 2 (Programming & Testing) | Semester 2 2025',
          'ICT309 IT Governance, Risk & Compliance | Semester 2 2025',
        ],
      );
      await _persistProfile();
    }

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _persistProfile() async {
    if (_profile == null) return;
    await _prefs!.setString(_prefsKey, _profile!.toJsonString());
  }

  @override
  Widget build(BuildContext context) {
    // StudentShell already provides AppBar; keep only the body here.
    if (_loading || _profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final profile = _profile!;
    return SingleChildScrollView(
      // ⬇️ More bottom padding so the logout button clears the bottom nav
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar initials + name (navy)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: const Color(0xFFE7ECF5),
                child: Text(
                  profile.initials,
                  style: const TextStyle(
                      color: kNavy, fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  profile.fullName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800, color: kNavy),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // User details
          const _SectionTitle('User details'),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: _openEdit,
            icon: const Icon(Icons.edit, color: Colors.amber),
            label: const Text('Edit profile',
                style: TextStyle(color: Colors.amber, fontSize: 16)),
          ),
          const SizedBox(height: 12),

          const _FieldLabel('Email address'),
          Text(profile.email, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),

          const _FieldLabel('Address'),
          Text(
            '${profile.address}, ${profile.city}, ${profile.country} ${profile.postcode}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),

          const _FieldLabel('Phone'),
          Text(profile.phone, style: const TextStyle(fontSize: 16)),

          const SizedBox(height: 28),

          // Course details
          const _SectionTitle('Course details'),
          const SizedBox(height: 8),
          const _FieldLabel('Course profiles'),
          const SizedBox(height: 6),
          ...profile.courses.map(
                (c) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                c,
                style: const TextStyle(
                  color: Color(0xFFDAA520), // gold-ish
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // 🔴 Standout logout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: _confirmLogout,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEdit() async {
    if (_profile == null) return;
    final updated = await Navigator.push<StudentProfile>(
      context,
      MaterialPageRoute(builder: (_) => EditProfilePage(profile: _profile!)),
    );
    if (updated != null) {
      setState(() => _profile = updated);
      await _persistProfile();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile updated')));
    }
  }

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'Are you sure you want to log out and return to the login page?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      _logout();
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }
}

/* ---------- small UI helpers ---------- */

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
      const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kNavy),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
    );
  }
}
