import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../student/home/student_shell.dart';
import '../lecturer/home/lecturer_home_page.dart';
import '../admin/home/admin_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username =
  TextEditingController(text: "Namgay Peldon");
  final TextEditingController _password = TextEditingController();

  bool _showPw = false;
  String? _selectedRole;
  final List<String> _roles = const ['Student', 'Lecturer', 'Admin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Login form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/logo.png', height: 90),
                        const SizedBox(height: 12),
                        const Text(
                          'Log in to your account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kNavy,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Role dropdown FIRST
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Select your role',
                            prefixIcon: Icon(Icons.badge),
                            border: OutlineInputBorder(),
                          ),
                          items: _roles
                              .map((r) => DropdownMenuItem(
                            value: r,
                            child: Text(r),
                          ))
                              .toList(),
                          onChanged: (val) {
                            setState(() => _selectedRole = val);
                            // Auto-focus username after selecting role
                            Future.delayed(Duration(milliseconds: 100), () {
                              FocusScope.of(context).nextFocus();
                            });
                          },
                          validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please select a role' : null,
                        ),
                        const SizedBox(height: 12),

                        // Username field
                        TextFormField(
                          controller: _username,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter your username' : null,
                        ),
                        const SizedBox(height: 12),

                        // Password field
                        TextFormField(
                          controller: _password,
                          obscureText: !_showPw,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _showPw = !_showPw),
                              icon: Icon(
                                  _showPw ? Icons.visibility : Icons.visibility_off),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (v) =>
                          (v == null || v.isEmpty) ? 'Enter your password' : null,
                        ),
                        const SizedBox(height: 18),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onLoginPressed,
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 48)),
                            child: const Text('Log in'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLoginPressed() {
    if (!_formKey.currentState!.validate()) return;

    final name =
    _username.text.trim().isEmpty ? 'User' : _username.text.trim();
    final role = _selectedRole;

    if (role == 'Student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => StudentShell(displayName: name),
        ),
      );
    } else if (role == 'Lecturer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LecturerHomePage(lecturerName: name),
        ),
      );
    } else if (role == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminHomePage(adminName: name),
        ),
      );
    }
  }
}
