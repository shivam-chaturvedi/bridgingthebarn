import 'package:flutter/material.dart';

import '../theme/theme_colors.dart';

class AuthRequiredPlaceholder extends StatelessWidget {
  const AuthRequiredPlaceholder({
    required this.title,
    required this.description,
    required this.onSignIn,
    required this.onSignUp,
    this.footer,
    super.key,
  });

  final String title;
  final String description;
  final Widget? footer;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF042A37),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.lock_open, size: 32, color: ThemeColors.accent),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.accent,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Sign in'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSignUp,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white38),
                    ),
                    child: const Text('Create account'),
                  ),
                ),
              ],
            ),
            if (footer != null) ...[
              const SizedBox(height: 16),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
