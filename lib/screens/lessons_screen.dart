import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/app_navigation_helpers.dart';
import '../providers/auth_provider.dart';
import '../screens/auth_screen.dart';
import '../services/lesson_progress_service.dart';
import '../services/lesson_service.dart';
import '../services/progress_service.dart';
import '../screens/lesson_detail_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/auth_required_placeholder.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

String defaultDurationForModule(String title) {
  if (title.toLowerCase().contains('basic')) return '10 min';
  if (title.toLowerCase().contains('introduction')) return '10 min';
  if (title.toLowerCase().contains('groom')) return '15 min';
  return '12 min';
}

class _LessonPayload {
  _LessonPayload({
    required this.lessons,
    required this.progress,
    required this.completedModuleIds,
  });

  final List<Lesson> lessons;
  final ProgressMetric progress;
  final Set<String> completedModuleIds;
}

class _LessonsScreenState extends State<LessonsScreen> {
  Future<_LessonPayload>? _payload;
  String? _payloadUserId;
  String? _expandedLessonId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = context.read<AuthProvider>().userId;
    if (userId != null) {
      _ensurePayload(userId);
    }
  }

  Future<_LessonPayload> _loadPayload(String userId) async {
    final lessons = await LessonService.fetchLessons();
    final progress = await ProgressService.fetchForProfile(userId);
    final completedModuleIds =
        await LessonProgressService.fetchCompletedModuleIds(userId);
    return _LessonPayload(
      lessons: lessons,
      progress: progress,
      completedModuleIds: completedModuleIds,
    );
  }

  void _ensurePayload(String userId) {
    if (_payloadUserId == userId && _payload != null) return;
    _payloadUserId = userId;
    _payload = _loadPayload(userId);
  }

  void _toggleLesson(String lessonId) {
    setState(() {
      _expandedLessonId = _expandedLessonId == lessonId ? null : lessonId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isSignedIn) {
      return Scaffold(
        backgroundColor: ThemeColors.primary,
        body: AuthRequiredPlaceholder(
          title: 'Sign in to view lessons',
          description: 'Lessons and progress live in your Supabase profile.',
          onSignIn: () => openAuthScreen(context),
          onSignUp: () => openAuthScreen(context, initialTab: AuthTab.signUp),
        ),
      );
    }

    final userId = auth.userId!;
    _ensurePayload(userId);

    return Scaffold(
      backgroundColor: const Color(0xFF021726),
      body: SafeArea(
        child: FutureBuilder<_LessonPayload>(
          future: _payload,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Failed to load lessons: ${snapshot.error}'),
              );
            }
            final payload = snapshot.data;
            if (payload == null) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, payload.progress, payload.lessons.length),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      children: [
                        if (payload.lessons.isNotEmpty)
                          _buildContinueCard(
                            payload,
                            payload.completedModuleIds,
                          ),
                        const SizedBox(height: 16),
                        ...payload.lessons
                            .map(
                              (lesson) => _buildLessonPlanCard(
                                lesson,
                                payload.completedModuleIds,
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ProgressMetric progress,
    int totalLessons,
  ) {
    final completed = progress.lessonsCompleted;
    final ratio = totalLessons == 0
        ? 0.0
        : (completed / totalLessons).clamp(0.0, 1.0);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFffd358),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Learn English',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Step-by-step lessons for the workplace',
            style: TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFffe2b9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Overall Progress',
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  '${completed}/${totalLessons} lessons',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10,
              color: const Color(0xFF0b2e3b),
              backgroundColor: const Color(0xFF001019),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueCard(
    _LessonPayload payload,
    Set<String> completedModuleIds,
  ) {
    final lesson = payload.lessons.first;
    if (lesson.modules.isEmpty) return const SizedBox.shrink();
    final nextModule = lesson.modules.firstWhere(
      (module) => !completedModuleIds.contains(module.id),
      orElse: () => lesson.modules.first,
    );
    return InkWell(
      onTap: () => _openModuleDetail(lesson, nextModule),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0a2230),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: const Icon(
            Icons.play_circle_fill,
            color: Colors.white70,
            size: 32,
          ),
          title: const Text(
            'Continue where you left off',
            style: TextStyle(color: Colors.white70),
          ),
          subtitle: Text(
            '${lesson.title} • ${nextModule.title}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonPlanCard(Lesson lesson, Set<String> completedModuleIds) {
    final totalModules = lesson.modules.length;
    final completedModules = lesson.modules
        .where((module) => completedModuleIds.contains(module.id))
        .length;
    final progress = totalModules == 0 ? 0.0 : completedModules / totalModules;
    final expanded = _expandedLessonId == lesson.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0a2230),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleLesson(lesson.id),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF0c3d4f),
                    child: Icon(_lessonIcon(lesson.title), color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$completedModules/$totalModules lessons completed',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: const Color(0xFF02101c),
                            color: ThemeColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) _buildModuleList(lesson, completedModuleIds),
        ],
      ),
    );
  }

  Widget _buildModuleList(Lesson lesson, Set<String> completedModuleIds) {
    return Column(
      children: lesson.modules.map((module) {
        final completed = completedModuleIds.contains(module.id);
        return _buildModuleRow(lesson, module, completed);
      }).toList(),
    );
  }

  Widget _buildModuleRow(Lesson lesson, LessonModule module, bool completed) {
    final percent = completed
        ? '100%'
        : module.position == 0
        ? 'New'
        : 'Next';
    return InkWell(
      onTap: () => _openModuleDetail(lesson, module),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF031830),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.play_circle_outline,
              color: completed ? Colors.greenAccent : Colors.white70,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    defaultDurationForModule(module.title),
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                percent,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openModuleDetail(Lesson lesson, LessonModule module) {
    final userId = context.read<AuthProvider>().userId;
    if (userId != null) {
      ProgressService.incrementDailyGoal(userId).catchError((error) {
        debugPrint('Failed to increment daily goal: $error');
      });
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            LessonDetailScreen(lesson: lesson, module: module),
      ),
    );
  }

  IconData _lessonIcon(String title) {
    switch (title) {
      case 'Foundation English':
        return Icons.school;
      case 'Horse Care English':
        return Icons.pets;
      case 'Safety & Your Rights':
        return Icons.shield;
      default:
        return Icons.menu_book;
    }
  }
}
