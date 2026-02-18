import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/lesson_detail_service.dart';
import '../services/lesson_progress_service.dart';
import '../services/progress_service.dart';
import '../theme/theme_colors.dart';

class LessonQuizScreen extends StatefulWidget {
  const LessonQuizScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.moduleId,
  });

  final String lessonId;
  final String lessonTitle;
  final String moduleId;

  @override
  State<LessonQuizScreen> createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends State<LessonQuizScreen> {
  late Future<List<LessonQuizQuestion>> _quizFuture;
  int _currentIndex = 0;
  int _correctAnswers = 0;
  String? _selectedOptionId;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _quizFuture = LessonDetailService.fetchQuizQuestions(widget.lessonId);
  }

  void _selectOption(LessonQuizQuestion question, LessonQuizOption option) {
    if (_answered) return;
    setState(() {
      _selectedOptionId = option.id;
      _answered = true;
      if (option.isCorrect) _correctAnswers++;
    });
  }

  void _nextQuestion(List<LessonQuizQuestion> questions) {
    if (_currentIndex < questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionId = null;
        _answered = false;
      });
    } else {
      _showResultDialog(questions.length);
    }
  }

  Future<void> _showResultDialog(int total) async {
    final score = total > 0 ? (_correctAnswers / total * 100).round() : 0;
    final passed = score >= 80;

    if (passed) {
      final userId = context.read<AuthProvider>().userId;
      if (userId != null) {
        try {
          await LessonProgressService.markLessonComplete(
            profileId: userId,
            lessonId: widget.lessonId,
            moduleId: widget.moduleId,
          );
          await ProgressService.incrementDailyGoal(userId, amount: 5)
              .catchError((_) => ProgressService.fetchForProfile(userId).then((m) => m));
        } catch (_) {}
      }
    }

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0a1c2a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.emoji_events_rounded : Icons.replay_rounded,
              color: passed ? Colors.amber : Colors.orangeAccent,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              passed ? 'Lesson Complete! 🎉' : 'Keep Practising!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You scored $score%\n($_correctAnswers / $total correct)',
              style: const TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            if (!passed) ...[
              const SizedBox(height: 6),
              const Text(
                'You need 80% or more to complete this lesson.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            if (passed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop(true); // return true = completed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back to Lesson'),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop(false);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Exit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _restartQuiz();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _correctAnswers = 0;
      _selectedOptionId = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021726),
      body: SafeArea(
        child: FutureBuilder<List<LessonQuizQuestion>>(
          future: _quizFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load quiz: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            final questions = snapshot.data ?? [];
            if (questions.isEmpty) {
              return _buildEmptyState();
            }
            return _buildQuizBody(questions);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        _buildTopBar(null),
        const Expanded(
          child: Center(
            child: Text(
              'No quiz questions available for this lesson yet.',
              style: TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(List<LessonQuizQuestion>? questions) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      color: const Color(0xFF0a1c2a),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lessonTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (questions != null)
                  Text(
                    'Question ${_currentIndex + 1} of ${questions.length}',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizBody(List<LessonQuizQuestion> questions) {
    final question = questions[_currentIndex];
    final progress = (_currentIndex + 1) / questions.length;

    return Column(
      children: [
        _buildTopBar(questions),
        // Progress bar
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white12,
          valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.accent),
          minHeight: 4,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Question number badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ThemeColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ThemeColors.accent.withOpacity(0.4)),
                  ),
                  child: Text(
                    'Q${_currentIndex + 1}',
                    style: TextStyle(
                      color: ThemeColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                // Question text
                Text(
                  question.question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                // Answer options
                ...question.options.map((option) {
                  return _buildOptionTile(question, option);
                }),
                const SizedBox(height: 24),
                // Next / Finish button
                if (_answered)
                  ElevatedButton(
                    onPressed: () => _nextQuestion(questions),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      _currentIndex < questions.length - 1
                          ? 'Next Question'
                          : 'See Results',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile(LessonQuizQuestion question, LessonQuizOption option) {
    final isSelected = _selectedOptionId == option.id;
    final showResult = _answered;

    Color borderColor = Colors.white12;
    Color bgColor = const Color(0xFF031830);
    Color textColor = Colors.white70;
    Widget? trailingIcon;

    if (showResult) {
      if (option.isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.withOpacity(0.12);
        textColor = Colors.white;
        trailingIcon = const Icon(Icons.check_circle, color: Colors.green, size: 20);
      } else if (isSelected && !option.isCorrect) {
        borderColor = Colors.red;
        bgColor = Colors.red.withOpacity(0.12);
        textColor = Colors.white54;
        trailingIcon = const Icon(Icons.cancel, color: Colors.red, size: 20);
      }
    } else if (isSelected) {
      borderColor = ThemeColors.accent;
      bgColor = ThemeColors.accent.withOpacity(0.15);
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => _selectOption(question, option),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: showResult && option.isCorrect ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option.optionText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: isSelected || (showResult && option.isCorrect)
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              trailingIcon,
            ],
          ],
        ),
      ),
    );
  }
}
