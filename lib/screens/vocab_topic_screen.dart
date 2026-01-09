import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:provider/provider.dart';

import '../data/vocab_data.dart';
import '../providers/app_language_provider.dart';
import '../screens/community_screen.dart';
import '../screens/help_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/vocab_screen.dart';
import '../services/tts_service.dart';
import '../services/translation_manager.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_more_options.dart';
import '../widgets/translatable_text.dart';

class VocabTopicScreen extends StatelessWidget {
  VocabTopicScreen({required this.topic, super.key});

  final VocabTopic topic;
  final TtsService _ttsService = TtsService();

  Future<void> _playText(BuildContext context, String text) async {
    final provider = context.read<AppLanguageProvider>();
    provider.translationStarted();
    try {
      final translated =
          await TranslationManager.instance.translate(text, provider.language);
      await _ttsService.speak(translated, provider.language.locale);
    } finally {
      provider.translationFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final vocabTileWidth = (screenWidth - 64) / 3;

    return Scaffold(
      backgroundColor: const Color(0xFF031824),
      appBar: AppBar(
        backgroundColor: const Color(0xFF041B24),
        title: TranslatableText(text: topic.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const TranslatableText(
              text: 'Key Vocabulary',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: topic.vocab
                    .map(
                      (word) => GestureDetector(
                        onTap: () => _playText(context, word),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          width: vocabTileWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFF041D25),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TranslatableText(
                                  text: word,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const TranslatableText(
                                  text: 'Translation / Explanation',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
            const TranslatableText(
              text: 'Essential Phrases',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: topic.phrases.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                    final phrase = topic.phrases[index];
                    return GestureDetector(
                      onTap: () => _playText(context, phrase),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF02131A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.play_arrow, color: Colors.white54),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TranslatableText(
                                    text: phrase,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  const TranslatableText(
                                    text: 'Translation / explanation',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white24,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E5469),
                  borderRadius: BorderRadius.circular(18),
                ),
              child: const Center(
                child: TranslatableText(
                  text: 'Tap to hear audio',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ),
            ],
          ),
        ),
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
