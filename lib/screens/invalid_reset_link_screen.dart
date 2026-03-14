import 'package:flutter/material.dart';

import '../navigation/app_navigation_helpers.dart';
import '../screens/auth_screen.dart';
import '../theme/theme_colors.dart';

class InvalidResetLinkScreen extends StatelessWidget {
  const InvalidResetLinkScreen({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        elevation: 0,
        title: const Text('Reset link unavailable'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Icon(
                Icons.lock_reset,
                size: 48,
                color: Colors.white70,
              ),
              const SizedBox(height: 16),
              const Text(
                'We could not validate the reset link.',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAuthScreen(context, initialTab: AuthTab.signIn);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Request a new reset link'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Return to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
