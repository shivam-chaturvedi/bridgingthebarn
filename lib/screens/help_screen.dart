import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../navigation/app_navigation_helpers.dart';
import '../screens/account_screen.dart';
import '../screens/community_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/vocab_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_more_options.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        elevation: 0,
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We are here to help',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Need a hand with lessons, audio, or your account? Choose the option below and we will respond shortly.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            _buildSupportCard(
              icon: LucideIcons.messageSquare,
              label: 'Live chat',
              detail: 'Tap to start a conversation with our coaches',
              accent: ThemeColors.accentAlt,
            ),
            const SizedBox(height: 12),
            _buildSupportCard(
              icon: LucideIcons.mail,
              label: 'Email support',
              detail: 'support@bridgingbarn.com • response in < 24 hrs',
              accent: ThemeColors.accent,
            ),
            const SizedBox(height: 12),
            _buildSupportCard(
              icon: LucideIcons.phone,
              label: 'Call us',
              detail: '+65 1234 5678 (Mon-Fri, 9am-6pm)',
              accent: Colors.greenAccent,
            ),
            const SizedBox(height: 24),
            const Text(
              'Frequently asked',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildFAQ(
              title: 'How do I reset my progress?',
              content:
                  'Go to Lessons → tap the gear icon → Reset progress, then restart from the beginning.',
            ),
            _buildFAQ(
              title: 'Can I share feedback?',
              content:
                  'Use the “Feedback” link inside the Community tab. Share wins or improvement ideas there.',
            ),
            _buildFAQ(
              title: 'Is my audio private?',
              content:
                  'Yes, recordings stay on your device. You can delete them anytime from settings.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3,
        moreOptions: _buildMoreOptions(context),
      ),
    );
  }

  Widget _buildSupportCard({
    required IconData icon,
    required String label,
    required String detail,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF041E26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: accent,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 18),
        ],
      ),
    );
  }

  Widget _buildFAQ({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  List<MoreOption> _buildMoreOptions(BuildContext context) {
    return [
      MoreOption(
        label: 'Account',
        icon: LucideIcons.user,
        onTap: () {
          navigateToProtectedScreen(
            context: context,
            feature: 'Account',
            screen: const AccountScreen(),
          );
        },
      ),
      MoreOption(
        label: 'Community',
        icon: LucideIcons.userPlus,
        onTap: () {
          navigateToProtectedScreen(
            context: context,
            feature: 'Community',
            screen: const CommunityScreen(),
          );
        },
      ),
      MoreOption(
        label: 'Progress',
        icon: LucideIcons.activity,
        onTap: () {
          navigateToProtectedScreen(
            context: context,
            feature: 'Progress',
            screen: const ProgressScreen(),
          );
        },
      ),
      MoreOption(
        label: 'Vocab & Phrases',
        icon: LucideIcons.bookOpen,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VocabScreen()),
          );
        },
      ),
      MoreOption(
        label: 'Privacy Policy',
        icon: LucideIcons.shieldCheck,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PrivacyScreen()),
          );
        },
      ),
    ];
  }
}
