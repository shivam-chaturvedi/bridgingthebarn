import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../screens/community_screen.dart';
import '../screens/help_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/vocab_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_more_options.dart';
import '../widgets/settings_action_button.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        elevation: 0,
        title: const Text('Privacy Policy'),
        actions: const [SettingsActionButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your data, your control',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'We only collect what is necessary to keep your experience safe, personalized, and useful.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'What we collect',
              children: [
                'Profile information (name, language, email).',
                'Lesson progress, badges, and streak data.',
                'Optional community posts and feedback.',
              ],
            ),
            _buildSection(
              title: 'How we use it',
              children: [
                'To personalize lessons and bookmark your spot.',
                'To provide translation/tts services on device.',
                'To improve the product by analyzing aggregated usage.',
              ],
            ),
            _buildSection(
              title: 'Third parties',
              children: [
                'We do not sell your data.',
                'Translation engines run locally or via trusted partners.',
                'No analytics are attached to your identity unless you opt in.',
              ],
            ),
            _buildSection(
              title: 'Your rights',
              children: [
                'Download or delete your profile anytime from Settings.',
                'Opt out of push/sms notifications always available in Settings.',
                'Contact support@bridgingbarn.com for any privacy requests.',
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Security & Storage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your data is encrypted on device, backups are stored with industry standard protections, and shared content is anonymized by default.',
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
        label: 'Community',
        icon: LucideIcons.userPlus,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CommunityScreen()),
          );
        },
      ),
      MoreOption(
        label: 'Progress',
        icon: LucideIcons.activity,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProgressScreen()),
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
