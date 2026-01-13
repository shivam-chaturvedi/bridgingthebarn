import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/app_navigation_helpers.dart';
import '../providers/auth_provider.dart';
import '../providers/app_language_provider.dart';
import '../screens/lessons_screen.dart';
import '../screens/speak_screen.dart';
import '../services/lesson_service.dart';
import '../services/community_service.dart';
import '../services/progress_service.dart';
import '../services/tts_service.dart';
import '../services/translation_manager.dart';
import '../widgets/common_widgets.dart';
import '../theme/theme_colors.dart';
import '../data/content.dart';

const communityStatsData = [
  {'value': '156', 'label': 'Active Today'},
  {'value': '89', 'label': 'Posts This Week'},
  {'value': '342', 'label': 'Members'},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final TtsService _ttsService = TtsService();
  Future<ProgressMetric>? _progressFuture;
  String? _progressUserId;
  late final Future<List<Lesson>> _lessonsFuture;
  late Future<CommunityStats> _communityStatsFuture;

  @override
  void initState() {
    super.initState();
    _lessonsFuture = LessonService.fetchLessons();
    _communityStatsFuture = CommunityService.fetchStats();
  }

  void _updateProgressFuture(String? userId) {
    if (userId == null) {
      _progressFuture = null;
      _progressUserId = null;
      return;
    }
    if (_progressUserId != userId || _progressFuture == null) {
      _progressFuture = ProgressService.fetchForProfile(userId);
      _progressUserId = userId;
    }
  }

  Future<void> _speakText(BuildContext context, String text) async {
    if (text.isEmpty) return;
    final provider = context.read<AppLanguageProvider>();
    provider.translationStarted();
    try {
      final translated = await TranslationManager.instance.translate(
        text,
        provider.language,
      );
      await _ttsService.speak(translated, provider.language.locale);
    } finally {
      provider.translationFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    _updateProgressFuture(auth.userId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroCard(context),
          const SizedBox(height: 20),
          _buildDailyGoalCard(context, auth),
          const SizedBox(height: 20),
          _buildStatChips(context, auth),
          const SizedBox(height: 30),
          _buildSectionTitle('Learn Phrases'),
          const SizedBox(height: 12),
          _buildPhraseCarousel(),
          const SizedBox(height: 30),
          _buildSectionTitle('Quick Practice'),
          const SizedBox(height: 12),
          ...quickPhrasesData
              .take(4)
              .map((data) => _buildQuickPracticeCard(context, data)),
          const SizedBox(height: 30),
          _buildLiveLessonsSection(context, auth),
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
                    MaterialPageRoute(builder: (_) => const SpeakScreen()),
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
                  onTap: () => navigateToTab(context, 2),
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

  Widget _buildDailyGoalCard(BuildContext context, AuthProvider auth) {
    if (!auth.isSignedIn) {
      return _buildLockedPanel(
        title: 'Daily goal',
        description: 'Sign in to track progress, streaks, and badges.',
        context: context,
      );
    }
    final future = _progressFuture;
    if (future == null) {
      return _buildPlaceholderCard(
        'Daily goal',
        description: 'Loading progress data...',
        child: const LinearProgressIndicator(),
      );
    }
    return FutureBuilder<ProgressMetric>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholderCard(
            'Daily goal',
            child: const LinearProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          if (snapshot.error is UnauthorizedException) {
            return _buildSessionExpiredCard(
              context,
              snapshot.error as UnauthorizedException,
            );
          }
          return _buildPlaceholderCard(
            'Daily goal',
            description: 'Error loading progress: ${snapshot.error}',
          );
        }
        final metric = snapshot.data;
        if (metric == null) {
          return _buildPlaceholderCard(
            'Daily goal',
            description: 'Unable to load progress.',
          );
        }
        final progressText = metric.dailyGoalProgress.toString();
        final targetText = metric.dailyGoalTarget > 0
            ? metric.dailyGoalTarget.toString()
            : '—';
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF0B3C47),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily goal',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 6),
              Text(
                progressText,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Phrases completed',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                'Target: $targetText',
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSessionExpiredCard(
    BuildContext context,
    UnauthorizedException error,
  ) {
    final auth = context.read<AuthProvider>();
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
          const Text(
            'Daily goal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your session expired. Sign in again to refresh progress.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text(
            error.message,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              await auth.signOut();
              openAuthScreen(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Sign in again'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChips(BuildContext context, AuthProvider auth) {
    if (!auth.isSignedIn) {
      return _buildLockedPanel(
        title: 'Streaks & badges',
        description: 'Sign in to unlock lifetime streaks, badges, and lessons.',
        context: context,
      );
    }
    final future = _progressFuture;
    if (future == null) {
      return const SizedBox();
    }
    return FutureBuilder<ProgressMetric>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholderChips();
        }
        final metric = snapshot.data;
        if (metric == null) {
          return _buildPlaceholderChips();
        }
        final stats = [
          {'value': '${metric.streak}', 'label': 'Streak'},
          {'value': '${metric.badges.length}', 'label': 'Badges'},
          {'value': '${metric.lessonsCompleted}', 'label': 'Lessons'},
        ];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stats.map((entry) {
            return Expanded(
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
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry['label']!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLiveLessonsSection(BuildContext context, AuthProvider auth) {
    if (!auth.isSignedIn) {
      return _buildLockedPanel(
        title: 'Live lessons',
        description: 'Sign in to browse the latest lessons from Supabase.',
        context: context,
      );
    }
    return FutureBuilder<List<Lesson>>(
      future: _lessonsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final lessons = snapshot.data ?? [];
        if (lessons.isEmpty) {
          return const Text(
            'Lessons are coming soon.',
            style: TextStyle(color: Colors.white70),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'Live Lessons',
              actionLabel: 'View all',
              onAction: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const LessonsScreen())),
            ),
            const SizedBox(height: 12),
            ...lessons
                .take(3)
                .map((lesson) => _buildLessonCard(context, lesson)),
          ],
        );
      },
    );
  }

  Widget _buildLessonCard(BuildContext context, Lesson lesson) {
    final moduleNames = lesson.modules
        .take(3)
        .map((module) => module.title)
        .join(' • ');
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const LessonsScreen())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF041E2A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(lesson.summary, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.menu_book, color: Colors.white54, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${lesson.modules.length} modules · $moduleNames',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedPanel({
    required String title,
    required String description,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0B2C39),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => openAuthScreen(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderCard(
    String title, {
    String? description,
    Widget? child,
  }) {
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
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(color: Colors.white70)),
          ],
          const SizedBox(height: 12),
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildPlaceholderChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        3,
        (_) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF07212B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: const [SizedBox(height: 14), SizedBox(height: 8)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel)),
      ],
    );
  }

  Widget _buildPhraseCarousel() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        scrollDirection: Axis.horizontal,
        itemCount: quickPhrasesData.length,
        itemBuilder: (context, index) {
          final data = quickPhrasesData[index];
          return _buildQuickPracticeCard(context, data);
        },
      ),
    );
  }

  Widget _buildQuickPracticeCard(
    BuildContext context,
    Map<String, Object> data,
  ) {
    final phrase = data['phrase'] as String? ?? data['label'] as String? ?? '';
    final translation = data['translation'] as String? ?? '';
    return GestureDetector(
      onTap: () => _speakText(context, phrase),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF041E2A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              phrase,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(translation, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityStats() {
    return FutureBuilder<CommunityStats>(
      future: _communityStatsFuture,
      builder: (context, snapshot) {
        final stats = snapshot.data;
        final labels = ['Active Today', 'Posts This Week', 'Members'];
        final values = [
          snapshot.connectionState == ConnectionState.waiting
              ? '--'
              : '${stats?.activeToday ?? '--'}',
          snapshot.connectionState == ConnectionState.waiting
              ? '--'
              : '${stats?.postsThisWeek ?? '--'}',
          snapshot.connectionState == ConnectionState.waiting
              ? '--'
              : '${stats?.members ?? '--'}',
        ];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            labels.length,
            (index) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF041521),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      values[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[index],
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF041C26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Daily tip',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Review your notes before bed—Short daily reviews protect your learning streak.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
