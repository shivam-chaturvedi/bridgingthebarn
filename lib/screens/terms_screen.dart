import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../screens/account_screen.dart';
import '../screens/community_screen.dart';
import '../navigation/app_navigation_helpers.dart';
import '../screens/help_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/vocab_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_more_options.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        elevation: 0,
        title: const Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fair use for a fair community',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'These terms guide how you and Bridging Barn show up in the app. '
              'Posts, translations, and lessons are for personal, non-commercial use only.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Your commitment',
              children: [
                'Be honest with your profile information.',
                'Respect fellow learners, moderators, and support staff.',
                'Do not post personal or confidential information.',
              ],
            ),
            _buildSection(
              title: 'Our promise',
              children: [
                'We will keep your data safe and deliver the experience you expect.',
                'We reserve the right to remove content that violates these guidelines.',
                'We support you directly from help@bridgingbarn.com.',
              ],
            ),
            _buildSection(
              title: 'Usage & availability',
              children: [
                'Access may be paused for maintenance or legal reasons.',
                'You are responsible for keeping your sign in details secure.',
                'We may update these terms; changes will be communicated inside the app.',
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Dispute resolution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'We do our best to resolve issues quickly. '
              'If you ever need to raise a concern, email help@bridgingbarn.com and we will respond within two business days.',
              style: TextStyle(color: Colors.white70),
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

  Widget _buildSection({
    required String title,
    required List<String> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          ...children.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $item',
                style: const TextStyle(color: Colors.white60),
              ),
            ),
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
        label: 'Help & Support',
        icon: LucideIcons.headset,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HelpScreen()),
          );
        },
      ),
    ];
  }
}
