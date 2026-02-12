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
}
