import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/theme_colors.dart';

class ProgressScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
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
          _buildKeepGoing(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      decoration: const BoxDecoration(
        color: Color(0xFFF39922),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(LucideIcons.arrowLeft, color: Colors.black),
              SizedBox(width: 12),
              Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Track your learning journey',
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTab('Overview', true),
              const SizedBox(width: 8),
              _buildTab('Badges', false),
              const SizedBox(width: 8),
              _buildTab('Shop', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool active) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? ThemeColors.primary : ThemeColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? Colors.white : Colors.transparent),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
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
                width:
                    (MediaQueryData.fromWindow(
                          WidgetsBinding.instance.window,
                        ).size.width -
                        64) /
                    2,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF041C26),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Text(
                      item['value']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['label']!,
                      style: const TextStyle(color: Colors.white70),
                    ),
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
        color: const Color(0xFF041C26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: weekData
                .map(
                  (entry) => Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 120 * (entry['value'] as double),
                          width: 26,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E5469),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          entry['day'] as String,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          const Text(
            'Total: 127 phrases this week',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillProgress() {
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
          const Text(
            'Skill Progress',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...skillProgress.map(
            (skill) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill['label'] as String,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: skill['value'] as double,
                            minHeight: 8,
                            color: const Color(0xFF0E5469),
                            backgroundColor: Colors.white12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${((skill['value'] as double) * 100).round()}%',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
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
              Text(
                'Recent Achievements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text('View All', style: TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 12),
          ...achievements.map(
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
                        Text(
                          achievement['title']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          achievement['subtitle']!,
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E5469),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      achievement['points']!,
                      style: const TextStyle(color: Colors.white),
                    ),
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
          const Text(
            'Monthly Goals',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...monthlyGoals.map(
            (goal) {
              final title = goal['title'] as String;
              final target = goal['target'] as String;
              final value = goal['value'] as double;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          target,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: value,
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

  Widget _buildKeepGoing() {
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
          const Text(
            'Keep Going! 💪',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            "You've learned 127 phrases — that's amazing! Just 73 more to reach your goal.",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E5469),
            ),
            onPressed: () {},
            child: const Center(child: Text('Continue Learning')),
          ),
        ],
      ),
    );
  }
}
