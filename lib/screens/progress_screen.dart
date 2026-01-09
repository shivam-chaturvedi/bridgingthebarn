import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../screens/community_screen.dart';
import '../screens/help_screen.dart';
import '../screens/lessons_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/vocab_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_more_options.dart';
import '../widgets/settings_action_button.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  static const weekData = [
    {'day': 'M', 'value': 0.55},
    {'day': 'T', 'value': 0.7},
    {'day': 'W', 'value': 0.65},
    {'day': 'T', 'value': 0.8},
    {'day': 'F', 'value': 0.6},
    {'day': 'S', 'value': 0.45},
    {'day': 'S', 'value': 0.55},
  ];

  static const skillProgress = [
    {'label': 'Speaking', 'value': 0.65},
    {'label': 'Listening', 'value': 0.78},
    {'label': 'Reading', 'value': 0.45},
    {'label': 'Vocabulary', 'value': 0.52},
  ];

  static const achievements = [
    {
      'title': "Completed 'Horse Care Basics' lesson",
      'subtitle': 'Today',
      'points': '+25',
    },
    {'title': '7-day learning streak!', 'subtitle': 'Today', 'points': '+50'},
    {
      'title': 'Learned 20 new phrases',
      'subtitle': 'Yesterday',
      'points': '+20',
    },
    {
      'title': 'Shared story in community',
      'subtitle': '2 days ago',
      'points': '+15',
    },
  ];

  static const monthlyGoals = [
    {'title': 'Complete 30 lessons', 'value': 0.033, 'target': '1/30'},
    {'title': 'Learn 200 phrases', 'value': 0.635, 'target': '127/200'},
    {'title': 'Help 5 community members', 'value': 0.6, 'target': '3/5'},
  ];

  static const earnedBadges = [
    {
      'title': 'First Steps',
      'subtitle': 'Complete your first lesson',
      'icon': LucideIcons.graduationCap,
    },
    {
      'title': 'Voice Found',
      'subtitle': 'Share your first community post',
      'icon': LucideIcons.messageCircle,
    },
    {
      'title': 'Week Warrior',
      'subtitle': '7 days of learning',
      'icon': LucideIcons.flame,
    },
    {
      'title': 'Phrase Builder',
      'subtitle': 'Learn 50 phrases',
      'icon': LucideIcons.bookOpen,
    },
    {
      'title': 'Vocabulary Master',
      'subtitle': 'Learn 100 phrases',
      'icon': LucideIcons.trophy,
    },
    {
      'title': 'Helping Hand',
      'subtitle': 'Help 5 community members',
      'icon': LucideIcons.heart,
    },
  ];

  static const lockedBadges = [
    {
      'title': 'Horse Whisperer',
      'subtitle': 'All horse care lessons',
      'icon': Icons.pets,
    },
    {
      'title': 'Safety Champion',
      'subtitle': 'All safety lessons',
      'icon': LucideIcons.shieldCheck,
    },
    {
      'title': 'Dedicated Learner',
      'subtitle': '30-day streak',
      'icon': LucideIcons.clock3,
    },
    {
      'title': 'Master Learner',
      'subtitle': 'Complete every lesson',
      'icon': LucideIcons.star,
    },
  ];

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              if (_selectedTab == 1) ...[
                _buildBadgeSection('Earned', ProgressScreen.earnedBadges),
                const SizedBox(height: 20),
                _buildBadgeSection('Keep Going', ProgressScreen.lockedBadges, locked: true),
                const SizedBox(height: 20),
              ] else ...[
                _buildStatsGrid(),
                const SizedBox(height: 20),
                _buildWeekChart(),
                const SizedBox(height: 20),
                _buildSkillProgress(),
                const SizedBox(height: 20),
                _buildAchievements(),
                const SizedBox(height: 20),
                _buildMonthlyGoals(),
                const SizedBox(height: 20),
                _buildKeepGoing(context),
                const SizedBox(height: 20),
              ],
              const SizedBox(height: 40),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF051321),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(LucideIcons.arrowLeft, color: Colors.white70),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SettingsActionButton(),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Track your learning journey',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTab('Overview', LucideIcons.activity, 0)),
              const SizedBox(width: 8),
              Expanded(child: _buildTab('Badges', LucideIcons.award, 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, IconData icon, int index) {
    final active = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0E6A86) : const Color(0xFF041927),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? Colors.white : Colors.transparent),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    const stats = [
      {'label': 'Phrases Learned', 'value': '127'},
      {'label': 'Lessons Done', 'value': '18'},
      {'label': 'Day Streak', 'value': '7'},
      {'label': 'Coins Earned', 'value': '520'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: stats
            .map(
              (item) => Container(
                width: (MediaQuery.of(context).size.width - 64) / 2,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF041C26),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Text(
                      item['value']!,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(item['label']!, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildWeekChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF041E25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This Week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ProgressScreen.weekData
                .map(
                  (entry) => Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 120 * (entry['value'] as double),
                          width: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E5469),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(entry['day'] as String, style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          const Text('Total: 127 phrases this week', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildSkillProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF041E25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Skill Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...ProgressScreen.skillProgress.map(
            (skill) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(skill['label'] as String, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: skill['value'] as double,
                      minHeight: 8,
                      color: const Color(0xFF0E5469),
                      backgroundColor: Colors.white12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${((skill['value'] as double) * 100).round()}%', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF041C26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Recent Achievements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Text('View All', style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 12),
          ...ProgressScreen.achievements.map(
            (achievement) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF02131A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.white54),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(achievement['title']!, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 2),
                        Text(achievement['subtitle']!, style: const TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E5469),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(achievement['points']!, style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyGoals() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF041C26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...ProgressScreen.monthlyGoals.map(
            (goal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Text(goal['title'] as String, style: const TextStyle(color: Colors.white)),
                        Text(goal['target'] as String, style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: goal['value'] as double,
                        minHeight: 8,
                        color: ThemeColors.accent,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeSection(String title, List<Map<String, dynamic>> badges, {bool locked = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(locked ? LucideIcons.lock : LucideIcons.trophy, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                '$title (${badges.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: badges.map((badge) => _buildBadgeCard(badge, locked: locked)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge, {bool locked = false}) {
    final iconData = badge['icon'] as IconData;
    final backgroundColor = locked ? const Color(0xFF011623) : const Color(0xFF041C26);
    final innerCircleColor = locked ? const Color(0xFF061226) : const Color(0xFF0E5469);

    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: innerCircleColor,
            child: locked
                ? const Icon(Icons.lock, color: Colors.white70)
                : Icon(iconData, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            badge['title'] as String,
            style: TextStyle(color: locked ? Colors.white60 : Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            badge['subtitle'] as String,
            style: TextStyle(color: locked ? Colors.white38 : Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildKeepGoing(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF041C26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Keep Going! 💪', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text(
            "You've learned 127 phrases — that's amazing! Just 73 more to reach your goal.",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E5469),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LessonsScreen()),
            ),
            child: const Center(
              child: Text('Continue Learning', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
