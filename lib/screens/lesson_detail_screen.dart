import 'package:flutter/material.dart';

import '../services/lesson_detail_service.dart';
import '../services/lesson_service.dart';
import '../services/permission_service.dart';
import '../screens/practice_activity_screen.dart';
import '../theme/theme_colors.dart';

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
  LessonDetailData? _currentDetail;

  @override
  void initState() {
    super.initState();
    // Use provided module or first module from lesson
    _selectedModule = widget.module ?? 
        (widget.lesson.modules.isNotEmpty ? widget.lesson.modules.first : 
         LessonModule(id: '', lessonId: widget.lesson.id, title: 'Module', content: '', position: 0));
    _detailFuture = LessonDetailService.fetchLessonDetail(widget.lesson.id);
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
            if (detail != null) {
              _currentDetail = detail;
            }
            if (detail == null) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(detail),
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
                        _buildPracticeActivities(detail),
                        const SizedBox(height: 16),
                        _buildWorkplaceTip(detail.tip),
                        const SizedBox(height: 24),
                        _buildCompletionButton(),
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

  Widget _buildHeader(LessonDetailData detail) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      color: const Color(0xFF0a1c2a),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedModule.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
              .map((lang) => '${lang}: ${item.translations[lang] ?? ''}')
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
        }).toList(),
      ],
    );
  }

  Widget _buildPracticeActivities(LessonDetailData detail) {
    // Filter out "Record your introduction"
    final filteredPractices = detail.practices.where((p) => 
      !p.title.toLowerCase().contains('record your introduction')
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Practice Activities',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...filteredPractices.map((practice) {
          return GestureDetector(
            onTap: () => _handlePracticeTap(practice),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF031830),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Icon(_practiceIcon(practice.mode), color: Colors.white70),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          practice.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          practice.description,
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Tap to start',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Future<void> _handlePracticeTap(LessonPracticeItem practice) async {
    if (practice.mode == LessonPracticeMode.record &&
        !await PermissionService.ensureMicrophonePermission(context)) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PracticeActivityScreen(
          practice: practice,
          lessonTitle: widget.lesson.title,
          scenarios: _currentDetail!.scenarios,
          keyLanguage: _currentDetail!.keyLanguage,
        ),
      ),
    );
  }

  IconData _practiceIcon(LessonPracticeMode mode) {
    switch (mode) {
      case LessonPracticeMode.matching:
        return Icons.link;
      case LessonPracticeMode.multipleChoice:
        return Icons.checklist;
      case LessonPracticeMode.record:
      default:
        return Icons.mic;
    }
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

  Widget _buildCompletionButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0869d0),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Mark Lesson Complete'),
    );
  }
}
