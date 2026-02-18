import '../services/supabase_service.dart';

class LessonKeyLanguageItem {
  LessonKeyLanguageItem({
    required this.phrase,
    required this.translations,
    required this.explanation,
    this.example,
  });

  final String phrase;
  final Map<String, String> translations;
  final String explanation;
  final String? example;
}

enum LessonPracticeMode { matching, multipleChoice, record }

class LessonPracticeItem {
  LessonPracticeItem({
    required this.title,
    required this.description,
    required this.mode,
  });

  final String title;
  final String description;
  final LessonPracticeMode mode;
}

class LessonScenario {
  LessonScenario({
    required this.title,
    required this.description,
    required this.question,
    required this.options,
  });

  final String title;
  final String description;
  final String question;
  final List<String> options;
}

class LessonQuizOption {
  LessonQuizOption({
    required this.id,
    required this.optionText,
    required this.isCorrect,
  });

  final String id;
  final String optionText;
  final bool isCorrect;
}

class LessonQuizQuestion {
  LessonQuizQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  final String id;
  final String question;
  final List<LessonQuizOption> options;
}

class LessonDetailData {
  LessonDetailData({
    required this.goal,
    required this.tip,
    required this.supportedLanguages,
    required this.keyLanguage,
    required this.practices,
    required this.scenarios,
  });

  final String goal;
  final String tip;
  final List<String> supportedLanguages;
  final List<LessonKeyLanguageItem> keyLanguage;
  final List<LessonPracticeItem> practices;
  final List<LessonScenario> scenarios;
}

class LessonDetailService {
  LessonDetailService._();

  static final _client = SupabaseService.client;

  static LessonPracticeMode _practiceModeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'matching':
        return LessonPracticeMode.matching;
      case 'multiple_choice':
      case 'multiplechoice':
      case 'multiple-choice':
        return LessonPracticeMode.multipleChoice;
      default:
        return LessonPracticeMode.record;
    }
  }

  static Future<LessonDetailData> fetchLessonDetail(String lessonId) async {
    final lessonRow = await _client
        .from('lessons')
        .select('goal, tip, supported_languages')
        .eq('id', lessonId)
        .maybeSingle();

    final keyRows = await _client
        .from('lesson_key_language')
        .select('phrase, translations, explanation, example')
        .eq('lesson_id', lessonId)
        .order('position');

    final practiceRows = await _client
        .from('lesson_practices')
        .select('title, description, mode')
        .eq('lesson_id', lessonId)
        .order('position');

    final scenarioRows = await _client
        .from('lesson_scenarios')
        .select('id, title, description, question')
        .eq('lesson_id', lessonId)
        .order('position');

    final scenarioIds = (scenarioRows as List<dynamic>? ?? [])
        .map((row) => row['id'] as String?)
        .where((id) => id != null)
        .toList();

    var scenarioOptions = <Map<String, dynamic>>[];
    if (scenarioIds.isNotEmpty) {
      final optionsResponse = await _client
          .from('lesson_scenario_options')
          .select('scenario_id, option_text')
          .filter('scenario_id', 'in', scenarioIds);
      scenarioOptions = (optionsResponse as List<dynamic>).cast<Map<String, dynamic>>();
    }

    final supportedLanguagesJson = (lessonRow?['supported_languages'] as List<dynamic>?) ?? [];
    final languages = supportedLanguagesJson.map((item) => item?.toString() ?? '').where((value) => value.isNotEmpty).toList();

    final keyLanguage = (keyRows as List<dynamic>? ?? []).cast<Map<String, dynamic>>().map((row) {
      final translations = (row['translations'] as Map<String, dynamic>? ?? {}).map((key, value) => MapEntry(key.toString(), value?.toString() ?? ''));
      return LessonKeyLanguageItem(
        phrase: row['phrase'] as String? ?? '',
        translations: translations,
        explanation: row['explanation'] as String? ?? '',
        example: row['example'] as String?,
      );
    }).toList();

    final practices = (practiceRows as List<dynamic>? ?? []).cast<Map<String, dynamic>>().map((row) {
      return LessonPracticeItem(
        title: row['title'] as String? ?? '',
        description: row['description'] as String? ?? '',
        mode: _practiceModeFromString(row['mode'] as String? ?? ''),
      );
    }).toList();

    final scenarioMap = <String, List<String>>{};
    for (final row in scenarioOptions) {
      final scenarioId = row['scenario_id'] as String?;
      final text = row['option_text'] as String? ?? '';
      if (scenarioId == null) continue;
      scenarioMap.putIfAbsent(scenarioId, () => []).add(text);
    }

    final scenarios = (scenarioRows as List<dynamic>? ?? []).cast<Map<String, dynamic>>().map((row) {
      final id = row['id'] as String? ?? '';
      return LessonScenario(
        title: row['title'] as String? ?? '',
        description: row['description'] as String? ?? '',
        question: row['question'] as String? ?? '',
        options: scenarioMap[id] ?? [],
      );
    }).toList();

    return LessonDetailData(
      goal: lessonRow?['goal'] as String? ?? '',
      tip: lessonRow?['tip'] as String? ?? '',
      supportedLanguages: languages,
      keyLanguage: keyLanguage,
      practices: practices,
      scenarios: scenarios,
    );
  }

  static Future<List<LessonQuizQuestion>> fetchQuizQuestions(String lessonId) async {
    final quizRows = await _client
        .from('lesson_quizzes')
        .select('id, question')
        .eq('lesson_id', lessonId)
        .order('position');

    final quizList = (quizRows as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    if (quizList.isEmpty) return [];

    final quizIds = quizList.map((r) => r['id'] as String).toList();

    final optionRows = await _client
        .from('lesson_quiz_options')
        .select('id, quiz_id, option_text, is_correct')
        .filter('quiz_id', 'in', quizIds)
        .order('position');

    final optionList = (optionRows as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    final optionMap = <String, List<LessonQuizOption>>{};
    for (final row in optionList) {
      final quizId = row['quiz_id'] as String? ?? '';
      optionMap.putIfAbsent(quizId, () => []).add(
        LessonQuizOption(
          id: row['id'] as String? ?? '',
          optionText: row['option_text'] as String? ?? '',
          isCorrect: row['is_correct'] as bool? ?? false,
        ),
      );
    }

    return quizList.map((row) {
      final id = row['id'] as String? ?? '';
      return LessonQuizQuestion(
        id: id,
        question: row['question'] as String? ?? '',
        options: optionMap[id] ?? [],
      );
    }).toList();
  }
}
