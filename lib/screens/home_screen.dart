import 'package:flutter/material.dart';
import '../screens/lessons_screen.dart';
import '../screens/speak_screen.dart';
import '../widgets/common_widgets.dart';
import 'vocab_topic_screen.dart';
import '../theme/theme_colors.dart';
import '../data/content.dart';
import '../data/vocab_data.dart';
import '../widgets/settings_action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroCard(context),
          const SizedBox(height: 20),
          _buildDailyGoalCard(),
          const SizedBox(height: 20),
          _buildStatChips(),
          const SizedBox(height: 30),
          _buildSectionTitle('Learn Phrases'),
          const SizedBox(height: 12),
          _buildPhraseCarousel(),
          const SizedBox(height: 30),
          _buildSectionTitle('Quick Practice'),
          const SizedBox(height: 12),
          ...quickPhrasesData.take(4).map(_buildQuickPracticeCard),
          const SizedBox(height: 30),
          _buildSectionTitle('Wall of Wins', actionLabel: 'View All'),
          const SizedBox(height: 12),
          ...winStoriesData.map(_buildWinCard),
          const SizedBox(height: 30),
          _buildSectionTitle('Our Community'),
          const SizedBox(height: 12),
          _buildCommunityStats(),
          const SizedBox(height: 30),
          _buildDailyTip(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeColors.card,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Bridging the Barn',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              const SettingsActionButton(),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Transforming lives through language & community',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              StatChip(icon: Icons.local_fire_department, label: '7 days'),
              SizedBox(width: 12),
              StatChip(icon: Icons.star, label: '520 coins'),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SpeakScreen(),
                    ),
                  ),
                  child: const HeroButton(
                    icon: Icons.mic,
                    label: 'Tap to Speak',
                    subLabel: 'Instant translation',
                    backgroundColor: Color(0xFF0E5469),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LessonsScreen(),
                    ),
                  ),
                  child: const HeroButton(
                    icon: Icons.play_arrow,
                    label: 'Continue Learning',
                    subLabel: 'Next: Horse Care',
                    backgroundColor: Color(0xFFFACC47),
                    iconColor: Colors.black,
                    textColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0B3C47),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Daily Goal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text('35/50 phrases', style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.7,
              minHeight: 8,
              color: ThemeColors.accentAlt,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChips() {
    final stats = [
      {'value': '127', 'label': 'Phrases'},
      {'value': '18', 'label': 'Lessons'},
      {'value': '7', 'label': 'Streak'},
      {'value': '6', 'label': 'Badges'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stats
          .map(
            (entry) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF07212B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Text(
                      entry['value']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry['label']!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSectionTitle(String title, {String? actionLabel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        if (actionLabel != null)
          Text(
            actionLabel,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
      ],
    );
  }

  Widget _buildPhraseCarousel() {
    final featuredTopics = vocabTopics.take(6).toList();
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: featuredTopics.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final topic = featuredTopics[index];
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VocabTopicScreen(topic: topic)),
            ),
            child: Container(
              width: 170,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF041E25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(topic.icon, style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    topic.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    topic.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickPracticeCard(Map<String, String> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
        color: const Color(0xFF03212C),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['label']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data['translation']!,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const Icon(Icons.volume_up, color: Colors.white38),
        ],
      ),
    );
  }

  Widget _buildWinCard(Map<String, String> story) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF082732),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(Icons.emoji_events, color: ThemeColors.accent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  story['summary']!,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(story['time']!, style: const TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }

  Widget _buildCommunityStats() {
    final stats = [
      {'value': '84+', 'label': 'Job Phrases'},
      {'value': '16', 'label': 'Categories'},
      {'value': '100%', 'label': 'Free'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stats
          .map(
            (entry) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF041B24),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      entry['value']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry['label']!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDailyTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B403C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Daily Tip',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          Text(
            'Practice with your horse! Try speaking English phrases while grooming. Your horse won\'t judge, and you\'ll build confidence!',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            '— Maira, English Coach',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
