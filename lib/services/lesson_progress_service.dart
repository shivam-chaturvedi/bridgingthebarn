import '../services/supabase_service.dart';

class LessonProgressService {
  LessonProgressService._();

  static final _client = SupabaseService.client;

  static Future<Set<String>> fetchCompletedModuleIds(String profileId) async {
    try {
      final rows = await _client
          .from('lesson_progress')
          .select('module_id')
          .eq('profile_id', profileId);
      final modules = rows as List<dynamic>? ?? [];
      return modules
          .map((entry) => entry['module_id'] as String?)
          .whereType<String>()
          .toSet();
    } catch (error) {
      return <String>{};
    }
  }

  static Future<void> markLessonComplete({
    required String profileId,
    required String lessonId,
    required String moduleId,
  }) async {
    await _client.from('lesson_progress').upsert(
      {
        'profile_id': profileId,
        'lesson_id': lessonId,
        'module_id': moduleId,
      },
      onConflict: 'profile_id,lesson_id,module_id',
    );
  }
  static Future<List<Map<String, dynamic>>> fetchUserProgress(String profileId) async {
    try {
      final rows = await _client
          .from('lesson_progress')
          .select('lesson_id, module_id, completed_at')
          .eq('profile_id', profileId);
      return (rows as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (error) {
      return [];
    }
  }
}
