import 'package:flutter_tts/flutter_tts.dart';

import '../services/lesson_detail_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/permission_service.dart';
import '../services/progress_service.dart';
import '../theme/theme_colors.dart';

class PracticeActivityScreen extends StatefulWidget {
  const PracticeActivityScreen({
    required this.practice,
    required this.lessonTitle,
    required this.scenarios,
    required this.keyLanguage,
    super.key,
  });

  final LessonPracticeItem practice;
  final String lessonTitle;
  final List<LessonScenario> scenarios;
  final List<LessonKeyLanguageItem> keyLanguage;

  static const _modeLabels = {
    // ...
  };
  
  @override
  State<PracticeActivityScreen> createState() => _PracticeActivityScreenState();
}

class _PracticeActivityScreenState extends State<PracticeActivityScreen> {
  bool _started = false;
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    // No game initialization needed here for the main screen state
  }
  
  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }
  
  Future<void> _playPhrase(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  String get _modeLabel =>
      PracticeActivityScreen._modeLabels[widget.practice.mode] ?? 'Practice';

  IconData get _modeIcon {
    switch (widget.practice.mode) {
      case LessonPracticeMode.matching:
        return Icons.link;
      case LessonPracticeMode.multipleChoice:
        return Icons.checklist;
      case LessonPracticeMode.record:
      default:
        return Icons.mic;
    }
  }

  Future<void> _startPractice(BuildContext context) async {
    if (widget.practice.mode == LessonPracticeMode.record &&
        !await PermissionService.ensureMicrophonePermission(context)) {
      return;
    }
    setState(() => _started = true);
    final userId = context.read<AuthProvider>().userId;
    if (userId != null) {
      ProgressService.incrementDailyGoal(userId).catchError((error) {
        debugPrint('Failed to update daily goal: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021726),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: ThemeColors.accent,
                          child: Icon(_modeIcon, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.lessonTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.practice.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.practice.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ..._buildHighlights(),
                    const SizedBox(height: 20),
                    if (_started) _buildSessionArea(),
                  ],
                ),
              ),
            ),
            if (!_started)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => _startPractice(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text('Start $_modeLabel'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHighlights() {
    final highlights = <String>[
      'Practice ${widget.practice.title.toLowerCase()} with guidance',
      if (widget.practice.mode == LessonPracticeMode.record)
        'Record audio and compare pronunciation'
      else if (widget.practice.mode == LessonPracticeMode.matching)
        'Drag and match phrases correctly'
      else
        'Choose the phrase that fits the scenario',
      if (widget.practice.mode == LessonPracticeMode.record)
        'Tap to hear native pronunciation'
      else
        'Instant feedback on your choices',
    ];
    return highlights
        .map(
          (h) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    h,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildSessionArea() {
    final title = widget.practice.title.toLowerCase();
    
    // User requested to ONLY show matching thing in "match greeting".
    if (title.contains('match greeting')) {
      return _buildMatchingSession();
    }
    
    if (widget.practice.mode == LessonPracticeMode.multipleChoice) {
      return _buildMultipleChoiceSession();
    }
    
    return _buildRecordingSession();
  }

  Widget _buildMatchingSession() {
    final pairs = widget.scenarios.map((s) {
      final answer = s.options.isNotEmpty ? s.options.first : '';
      return [s.question, answer];
    }).where((pair) => pair[0].isNotEmpty && pair[1].isNotEmpty).toList();
    
    if (pairs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No matching pairs found for this lesson.',
          style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      );
    }
    
    return _MatchingBoard(pairs: pairs);
  }

  Widget _buildMultipleChoiceSession() {
    final options = [
      'Grammar check',
      'Workplace safety',
      'Casual conversation',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Choose the best answer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ...options.map(
          (option) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF041D25),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.centerLeft,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white12),
                ),
              ),
              child: Text(option),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingSession() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Tap to listen & practice',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        if (widget.keyLanguage.isEmpty)
           const Text(
             'No key phrases available to practice.',
             style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
           ),
        ...widget.keyLanguage.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF041D25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: ThemeColors.accent.withOpacity(0.2),
                  child: IconButton(
                    icon: const Icon(Icons.volume_up, color: ThemeColors.accent),
                    onPressed: () => _playPhrase(item.phrase),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.phrase,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.explanation.isNotEmpty)
                        Text(
                          item.explanation,
                          style: const TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
  
  // ... _buildRecordingCard (removed as it's replaced) ...

  // ... rest of class
}
class _MatchingBoard extends StatefulWidget {
  const _MatchingBoard({required this.pairs});

  final List<List<String>> pairs;

  @override
  State<_MatchingBoard> createState() => _MatchingBoardState();
}

class _MatchingBoardState extends State<_MatchingBoard> {
  late List<String> _shuffledAnswers;
  late Map<int, String?> _userMatches;
  bool _showSuccess = false;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _shuffledAnswers = widget.pairs.map((p) => p[1]).toList()..shuffle();
    _userMatches = {for (var i = 0; i < widget.pairs.length; i++) i: null};
    _showSuccess = false;
    _showError = false;
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  void _checkAnswers() {
    bool allCorrect = true;
    bool allFilled = true;

    for (var i = 0; i < widget.pairs.length; i++) {
      if (_userMatches[i] == null) {
        allFilled = false;
      }
      if (_userMatches[i] != widget.pairs[i][1]) {
        allCorrect = false;
      }
    }

    setState(() {
      if (allCorrect) {
        _showSuccess = true;
        _showError = false;
      } else {
        _showSuccess = false;
        _showError = true;
      }
    });

    if (!allFilled) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please match all items before checking.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Drag answers to match',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        // Draggable answers at top
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _shuffledAnswers.map((answer) {
            final isUsed = _userMatches.values.contains(answer);
            return Draggable<String>(
              data: answer,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: ThemeColors.accent.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    answer,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: _buildAnswerChip(answer, isUsed),
              ),
              child: _buildAnswerChip(answer, isUsed),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        // Questions with drop zones
        ...List.generate(widget.pairs.length, (index) {
          return _buildQuestionSlot(index);
        }),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _resetGame,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Reset'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _checkAnswers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Check Answers'),
              ),
            ),
          ],
        ),
        if (_showSuccess) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Perfect! All matches are correct!',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_showError) ...[
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red),
            ),
            child: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Some matches are incorrect. Try again!',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAnswerChip(String answer, bool isUsed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUsed ? const Color(0xFF041D25) : ThemeColors.accent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUsed ? Colors.white24 : ThemeColors.accent,
        ),
      ),
      child: Text(
        answer,
        style: TextStyle(
          color: isUsed ? Colors.white38 : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildQuestionSlot(int index) {
    final question = widget.pairs[index][0];
    final userAnswer = _userMatches[index];

    return DragTarget<String>(
      onAcceptWithDetails: (details) {
        setState(() {
          // Remove this answer from any other slot
          _userMatches.forEach((key, value) {
            if (value == details.data) {
              _userMatches[key] = null;
            }
          });
          _userMatches[index] = details.data;
          _showSuccess = false; // Reset success/error on change
          _showError = false;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF041D25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: candidateData.isNotEmpty ? ThemeColors.accent : Colors.white12,
              width: candidateData.isNotEmpty ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: userAnswer != null 
                      ? ThemeColors.accent.withOpacity(0.3)
                      : const Color(0xFF021723),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: userAnswer != null ? ThemeColors.accent : Colors.white24,
                  ),
                ),
                child: Text(
                  userAnswer ?? 'Drop answer here',
                  style: TextStyle(
                    color: userAnswer != null ? Colors.white : Colors.white38,
                    fontStyle: userAnswer != null ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

