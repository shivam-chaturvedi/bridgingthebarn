import '../services/supabase_service.dart';

class LessonModule {
  LessonModule({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.content,
    required this.position,
  });

  final String id;
  final String lessonId;
  final String title;
  final String content;
  final int position;
}

class Lesson {
  Lesson({
    required this.id,
    required this.title,
    required this.summary,
    required this.position,
    required this.modules,
  });

  final String id;
  final String title;
  final String summary;
  final int position;
  final List<LessonModule> modules;
}

class LessonService {
  LessonService._();

  static final _client = SupabaseService.client;

  static Future<List<Lesson>> fetchLessons() async {
    final response = await _client
        .from('lessons')
        .select('id, title, summary, position, lesson_modules(id, title, content, position)')
        .order('position');

    final lessonsJson = response as List<dynamic>? ?? [];
    final lessons = lessonsJson.cast<Map<String, dynamic>>().map((lessonJson) {
      final modulesJson = lessonJson['lesson_modules'] as List<dynamic>? ?? [];
      final modules = modulesJson.cast<Map<String, dynamic>>().map((moduleJson) {
        return LessonModule(
          id: moduleJson['id'] as String,
          lessonId: lessonJson['id'] as String,
          title: moduleJson['title'] as String? ?? 'Module',
          content: moduleJson['content'] as String? ?? '',
          position: moduleJson['position'] as int? ?? 0,
        );
      }).toList()
        ..sort((a, b) => a.position.compareTo(b.position));

      return Lesson(
        id: lessonJson['id'] as String,
        title: lessonJson['title'] as String? ?? 'Lesson',
        summary: lessonJson['summary'] as String? ?? '',
        position: lessonJson['position'] as int? ?? 0,
        modules: modules,
      );
    }).toList();

    lessons.sort((a, b) => a.position.compareTo(b.position));
    return lessons;
  }
}
