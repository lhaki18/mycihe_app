import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/student_profile.dart';

class EditProfilePage extends StatefulWidget {
  final StudentProfile profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstName =
  TextEditingController(text: widget.profile.firstName);
  late final TextEditingController _lastName =
  TextEditingController(text: widget.profile.lastName);
  late final TextEditingController _email =
  TextEditingController(text: widget.profile.email);
  late final TextEditingController _address =
  TextEditingController(text: widget.profile.address);
  late final TextEditingController _city =
  TextEditingController(text: widget.profile.city);
  late final TextEditingController _country =
  TextEditingController(text: widget.profile.country);
  late final TextEditingController _postcode =
  TextEditingController(text: widget.profile.postcode);
  late final TextEditingController _phone =
  TextEditingController(text: widget.profile.phone);

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _address.dispose();
    _city.dispose();
    _country.dispose();
    _postcode.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Form(
          key: _formKey,
          child: Column(children: [
            _twoUp(
              _field('First name', _firstName),
              _field('Last name', _lastName),
            ),
            const SizedBox(height: 12),
            _field('Email address', _email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter email';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                }),
            const SizedBox(height: 12),
            _field('Address', _address),
            const SizedBox(height: 12),
            _twoUp(
              _field('City', _city),
              _field('Country', _country),
            ),
            const SizedBox(height: 12),
            _twoUp(
              _field('Postcode', _postcode, keyboardType: TextInputType.number),
              _field('Phone', _phone, keyboardType: TextInputType.phone),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _save,
                child: const Text('Update Profile'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c,
      {TextInputType? keyboardType, String? Function(String?)? validator}) {
    return TextFormField(
      controller: c,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator ?? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }

  Widget _twoUp(Widget a, Widget b) {
    return Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: 12),
        Expanded(child: b),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = StudentProfile(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: _email.text.trim(),
      address: _address.text.trim(),
      city: _city.text.trim(),
      country: _country.text.trim(),
      postcode: _postcode.text.trim(),
      phone: _phone.text.trim(),
      courses: widget.profile.courses, // unchanged here
    );

    Navigator.pop(context, updated);
  }
}
