import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../data/vocab_data.dart';
import '../providers/app_language_provider.dart';
import '../screens/community_screen.dart';
import '../screens/help_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/progress_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_more_options.dart';
import '../widgets/settings_action_button.dart';
import '../widgets/translatable_text.dart';
import 'vocab_topic_screen.dart';

class VocabScreen extends StatelessWidget {
  const VocabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<AppLanguageProvider>();
    final translationActive = languageProvider.translationInProgress;
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        title: const TranslatableText(
          text: 'Vocab & Phrases',
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
        actions: const [SettingsActionButton()],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (languageProvider.translationInProgress) ...[
                  _buildTranslationProgressBar(),
                  const SizedBox(height: 12),
                ],
                const TranslatableText(
                  text: 'Phrases Learned 0/84',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                const TranslatableText(text: '0% Complete', style: TextStyle(color: Colors.white38)),
                const SizedBox(height: 16),
                const TranslatableText(
                  text: 'Browse by Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: vocabTopics.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final topic = vocabTopics[index];
                      return _CategoryCard(topic: topic);
                    },
                  ),
                ),
              ],
            ),
          ),
          if (translationActive) _buildTranslationOverlay(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3,
        moreOptions: _buildMoreOptions(context),
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
        label: 'Help & Support',
        icon: LucideIcons.headset,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HelpScreen()),
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

  Widget _buildTranslationProgressBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.translate, color: Colors.white70, size: 18),
              SizedBox(width: 8),
              Text(
                'Translation in progress',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(
            color: Color(0xFF0E5469),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: Container(
          color: Colors.black.withOpacity(0.65),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF0E5469),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Translation in progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We are translating the vocab list in the background. It will keep working while you explore.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.topic});

  final VocabTopic topic;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VocabTopicScreen(topic: topic)),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF041D25),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF0E5469),
              child: Text(topic.icon, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 16),
            Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatableText(
                  text: topic.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                TranslatableText(
                  text: topic.description,
                  style: const TextStyle(color: Colors.white60),
                ),
              ],
            ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
