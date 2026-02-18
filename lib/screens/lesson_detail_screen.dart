import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/lesson_detail_service.dart';
import '../services/lesson_progress_service.dart';
import '../services/lesson_service.dart';
import '../screens/lesson_quiz_screen.dart';

String _defaultDurationForModule(String title) {
  if (title.toLowerCase().contains('basic')) return '10 min';
  if (title.toLowerCase().contains('introduction')) return '10 min';
  if (title.toLowerCase().contains('groom')) return '15 min';
  return '12 min';
}

class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({
    super.key,
    required this.lesson,
    this.module,
  });

  final Lesson lesson;
  final LessonModule? module;

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  late final Future<LessonDetailData> _detailFuture;
  late final LessonModule _selectedModule;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _selectedModule = widget.module ??
        (widget.lesson.modules.isNotEmpty
            ? widget.lesson.modules.first
            : LessonModule(
                id: '',
                lessonId: widget.lesson.id,
                title: 'Module',
                content: '',
                position: 0,
              ));
    _detailFuture = LessonDetailService.fetchLessonDetail(widget.lesson.id);
    _loadCompletionState();
  }

  Future<void> _loadCompletionState() async {
    final userId = context.read<AuthProvider>().userId;
    if (userId == null || _selectedModule.id.isEmpty) return;
    final completedIds =
        await LessonProgressService.fetchCompletedModuleIds(userId);
    if (mounted) {
      setState(() {
        _isCompleted = completedIds.contains(_selectedModule.id);
      });
    }
  }

  Future<void> _openQuiz() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LessonQuizScreen(
          lessonId: widget.lesson.id,
          lessonTitle: _selectedModule.title,
          moduleId: _selectedModule.id,
        ),
      ),
    );
    // result == true means the user passed the quiz
    if (result == true && mounted) {
      setState(() => _isCompleted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021726),
      body: SafeArea(
        child: FutureBuilder<LessonDetailData>(
          future: _detailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load lesson: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            final detail = snapshot.data;
            if (detail == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        _buildGoal(detail.goal),
                        const SizedBox(height: 20),
                        _buildKeyPhrases(detail),
                        const SizedBox(height: 20),
                        _buildWorkplaceTip(detail.tip),
                        const SizedBox(height: 24),
                        _isCompleted
                            ? _buildCompletedBadge()
                            : _buildTakeQuizButton(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      color: const Color(0xFF0a1c2a),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Navigator.of(context).pop(_isCompleted),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedModule.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.greenAccent, width: 1.2),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.greenAccent,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _defaultDurationForModule(_selectedModule.title),
            style: const TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF021723),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              'Lesson ${_selectedModule.position + 1}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoal(String goal) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0c2d30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.greenAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(goal, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPhrases(LessonDetailData detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Key Phrases',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...detail.keyLanguage.map((item) {
          final translationList = detail.supportedLanguages
              .map((lang) => '$lang: ${item.translations[lang] ?? ''}')
              .where((line) => line.trim().isNotEmpty)
              .toList();
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF031830),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.volume_up, color: Colors.white70),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.phrase,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (translationList.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    translationList.first,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
                if (item.explanation.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '→ ${item.explanation}',
                    style: const TextStyle(color: Colors.white38),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildWorkplaceTip(String tip) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF212a2f),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.orangeAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(tip, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.greenAccent.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 48),
          SizedBox(height: 10),
          Text(
            'Lesson Completed! 🎉',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'You scored 80% or more on this quiz.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTakeQuizButton() {
    return ElevatedButton.icon(
      onPressed: _openQuiz,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0869d0),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.quiz_rounded),
      label: const Text(
        'Take Quiz to Complete',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
