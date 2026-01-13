import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../navigation/app_navigation_helpers.dart';
import '../providers/auth_provider.dart';
import '../screens/auth_screen.dart';
import '../services/lesson_service.dart';
import '../services/progress_service.dart';
import '../theme/theme_colors.dart';
import '../widgets/auth_required_placeholder.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonPayload {
  _LessonPayload({
    required this.lessons,
    required this.progress,
  });

  final List<Lesson> lessons;
  final ProgressMetric progress;
}

class _LessonsScreenState extends State<LessonsScreen> {
  String? _expandedLessonId;
  String? _expandedModuleId;
  Future<_LessonPayload>? _payload;
  String? _payloadUserId;

  Future<_LessonPayload> _loadPayload(String userId) async {
    try {
      final lessons = await LessonService.fetchLessons();
      final progress = await ProgressService.fetchForProfile(userId);
      return _LessonPayload(lessons: lessons, progress: progress);
    } catch (error) {
      debugPrint('Failed to load lessons payload: $error');
      return _LessonPayload(
        lessons: [],
        progress: ProgressMetric.empty(),
      );
    }
  }

  void _ensurePayload(String userId) {
    if (_payloadUserId != userId) {
      _payloadUserId = userId;
      _payload = _loadPayload(userId);
    }
  }

  void _retryLessons(String userId) {
    setState(() {
      _payload = _loadPayload(userId);
    });
  }

  void _toggleLesson(String lessonId) {
    setState(() {
      if (_expandedLessonId == lessonId) {
        _expandedLessonId = null;
        _expandedModuleId = null;
      } else {
        _expandedLessonId = lessonId;
        _expandedModuleId = null;
      }
    });
  }

  void _toggleModule(String moduleId) {
    setState(() {
      _expandedModuleId = _expandedModuleId == moduleId ? null : moduleId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isSignedIn) {
      return Scaffold(
        backgroundColor: ThemeColors.primary,
        appBar: AppBar(
          backgroundColor: ThemeColors.primary,
          elevation: 0,
          title: const Text('Lessons'),
        ),
        body: AuthRequiredPlaceholder(
          title: 'Sign in to view lessons',
          description: 'Lessons and progress are saved to your Supabase profile.',
          onSignIn: () => openAuthScreen(context),
          onSignUp: () => openAuthScreen(context, initialTab: AuthTab.signUp),
        ),
      );
    }

    final userId = auth.userId!;
    _ensurePayload(userId);

    return Scaffold(
      backgroundColor: ThemeColors.primary,
      body: SafeArea(
          child: FutureBuilder<_LessonPayload>(
            future: _payload,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return _buildLessonError(userId);
              }
              final payload = snapshot.data;
              if (payload == null) {
                return _buildLessonError(userId);
              }
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildProgressSummary(payload),
                  const SizedBox(height: 16),
                  if (payload.lessons.isEmpty)
                    _buildEmptyLessons(context)
                  else ...[
                    ...payload.lessons.map((lesson) => _buildLessonCard(lesson, payload)),
                  ],
                  const SizedBox(height: 16),
                  _buildStudyTip(),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF041C26),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Learn English',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Step-by-step lessons for the workplace',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSummary(_LessonPayload payload) {
    final totalLessons = payload.lessons.length;
    final completed = payload.progress.lessonsCompleted;
    final progressValue = totalLessons > 0
        ? (completed / totalLessons).clamp(0.0, 1.0)
        : 0.0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0C2340),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Overall Progress', style: TextStyle(color: Colors.white70)),
              Text(
                '$completed/$totalLessons lessons',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 10,
              color: ThemeColors.accent,
              backgroundColor: Colors.white12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyLessons(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.4;
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.menu_book, size: 48, color: Colors.white54),
            SizedBox(height: 16),
            Text(
              'No lessons added yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'New lessons are synchronized from Supabase. Check back soon!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonError(String userId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.redAccent.withOpacity(0.8)),
          const SizedBox(height: 12),
          const Text(
            'Something went wrong while loading lessons.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _retryLessons(userId),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.accent,
              foregroundColor: Colors.black,
            ),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(Lesson lesson, _LessonPayload payload) {
    final expanded = _expandedLessonId == lesson.id;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF041E2A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _toggleLesson(lesson.id),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0E5469),
                  child: Text(
                    lesson.title[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lesson.summary,
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: 12),
            ...lesson.modules.map((module) => _buildModuleTile(module)).toList(),
          ],
          if (!expanded)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '${lesson.modules.length} modules',
                style: const TextStyle(color: Colors.white54),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModuleTile(LessonModule module) {
    final expanded = _expandedModuleId == module.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            module.title,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Icon(
            expanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.white60,
          ),
          onTap: () => _toggleModule(module.id),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8, bottom: 12),
            child: Text(
              module.content,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
      ],
    );
  }

  Widget _buildStudyTip() {
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
          Text('Study tip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text(
            'Breaking lessons into short chunks keeps focus sharp and builds muscle memory.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
