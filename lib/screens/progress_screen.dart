import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../navigation/app_navigation_helpers.dart';
import '../providers/auth_provider.dart';
import '../screens/account_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/community_screen.dart';
import '../screens/help_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/vocab_screen.dart';
import '../services/progress_service.dart';
import '../theme/theme_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_more_options.dart';
import '../widgets/auth_required_placeholder.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _selectedTab = 0;
  Future<ProgressMetric>? _metricFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileId = context.read<AuthProvider>().userId;
    if (profileId != null) {
      _metricFuture ??= ProgressService.fetchForProfile(profileId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          backgroundColor: ThemeColors.primary,
          body: SafeArea(
            child: auth.isSignedIn
                ? FutureBuilder<ProgressMetric>(
                    future: _metricFuture,
                    builder: (context, snapshot) {
                      final metric = snapshot.data;
                      final loading =
                          snapshot.connectionState == ConnectionState.waiting;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(metric, loading),
                            const SizedBox(height: 20),
                            if (_selectedTab == 1) ...[
                              _buildBadgeList(metric),
                              const SizedBox(height: 20),
                            ] else ...[
                              _buildStatsGrid(metric),
                              const SizedBox(height: 20),
                              _buildDailyGoalCard(metric),
                              const SizedBox(height: 20),
                              _buildLessonSummary(metric),
                              const SizedBox(height: 20),
                              _buildKeepGoing(context, metric),
                            ],
                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    },
                  )
                : AuthRequiredPlaceholder(
                    title: 'Progress tracking is for members',
                    description:
                        'Sign in to see your streak, badges, and monthly goals in one place.',
                    onSignIn: () => openAuthScreen(context),
                    onSignUp: () =>
                        openAuthScreen(context, initialTab: AuthTab.signUp),
                  ),
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: 3,
            moreOptions: _buildMoreOptions(context),
          ),
        );
      },
    );
  }

  List<MoreOption> _buildMoreOptions(BuildContext context) {
    return [
      MoreOption(
        label: 'Account',
        icon: LucideIcons.user,
        onTap: () => navigateToProtectedScreen(
          context: context,
          feature: 'Account',
          screen: const AccountScreen(),
        ),
      ),
      MoreOption(
        label: 'Community',
        icon: LucideIcons.userPlus,
        onTap: () => navigateToProtectedScreen(
          context: context,
          feature: 'Community',
          screen: const CommunityScreen(),
        ),
      ),
      MoreOption(
        label: 'Progress',
        icon: LucideIcons.activity,
        onTap: () => navigateToProtectedScreen(
          context: context,
          feature: 'Progress',
          screen: const ProgressScreen(),
        ),
      ),
      MoreOption(
        label: 'Vocab & Phrases',
        icon: LucideIcons.bookOpen,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const VocabScreen()));
        },
      ),
      MoreOption(
        label: 'Help & Support',
        icon: LucideIcons.headset,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const HelpScreen()));
        },
      ),
      MoreOption(
        label: 'Privacy Policy',
        icon: LucideIcons.shieldCheck,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const PrivacyScreen()));
        },
      ),
    ];
  }

  Widget _buildHeader(ProgressMetric? metric, bool loading) {
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
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Track your learning journey',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            loading
                ? 'Loading your latest streak…'
                : 'Streak: ${metric?.streak ?? 0} days · Badges: ${metric?.badges.length ?? 0}',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(ProgressMetric? metric) {
    final stats = [
      {'label': 'Day Streak', 'value': '${metric?.streak ?? 0}'},
      {'label': 'Badges', 'value': '${metric?.badges.length ?? 0}'},
      {'label': 'Lessons Done', 'value': '${metric?.lessonsCompleted ?? 0}'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: stats.map((item) {
          return Container(
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
                  style: const TextStyle(
                    fontSize: 28,
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDailyGoalCard(ProgressMetric? metric) {
    final progress = metric?.dailyGoalProgress ?? 0;
    final target = metric?.dailyGoalTarget ?? 50;
    final ratio = target > 0
        ? (progress / target).clamp(0.0, 1.0).toDouble()
        : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF041C26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Goal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '$progress / $target phrases',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 10,
                color: ThemeColors.accent,
                backgroundColor: Colors.white12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ratio >= 1
                  ? 'Goal reached! Keep the streak going.'
                  : 'Keep practicing to hit today’s goal.',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonSummary(ProgressMetric? metric) {
    final lessons = metric?.lessonsCompleted ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF041C26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lessons completed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '$lessons lessons completed',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'All of this is synced with Supabase so it stays accurate across devices.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeList(ProgressMetric? metric) {
    final badges = metric?.badges ?? [];
    if (badges.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF041C26),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: const Text(
            'Badges will appear here once you complete lessons and reach milestones.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: badges
            .map(
              (badge) => Chip(
                label: Text(badge),
                backgroundColor: const Color(0xFF0E5469),
                labelStyle: const TextStyle(color: Colors.white),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildKeepGoing(BuildContext context, ProgressMetric? metric) {
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
          Text(
            metric == null
                ? "Your progress is on its way—keep learning and we'll report back."
                : "You're on a ${metric.streak}-day streak and have ${metric.badges.length} badge${metric.badges.length == 1 ? '' : 's'}.",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E5469),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => navigateToTab(context, 2),
            child: const Center(
              child: Text(
                'Continue Learning',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
