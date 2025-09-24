import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class GreetingPage extends StatefulWidget {
  final String userName;
  final Widget targetPage; // The page to navigate to
  final String logoPath; // CIHE logo asset

  const GreetingPage({
    super.key,
    required this.userName,
    required this.targetPage,
    required this.logoPath,
  });

  @override
  State<GreetingPage> createState() => _GreetingPageState();
}

class _GreetingPageState extends State<GreetingPage>
    with TickerProviderStateMixin {
  bool _showWelcome = true;

  late AnimationController _logoController;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    // 🎬 Logo pulsing animation (0.9 → 1.1 with easing)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // After 2 sec → change text
    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showWelcome = false);
    });

    // After 5 sec → move to dashboard
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => widget.targetPage,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.userName.trim().split(' ').first;

    return Scaffold(
      backgroundColor: kNavy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔹 Pulsing CIHE Logo
                ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    widget.logoPath,
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 32),

                // 🔹 Animated text
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  child: _showWelcome
                      ? Text(
                    "Hi, $firstName 👋",
                    key: const ValueKey(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : Column(
                    key: const ValueKey(2),
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Please wait...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "We’re getting your page ready",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
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
