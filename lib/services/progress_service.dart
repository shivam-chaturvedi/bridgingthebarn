import 'package:postgrest/postgrest.dart';

import '../services/supabase_service.dart';

class UnauthorizedException implements Exception {
  UnauthorizedException([this.message = 'Unauthorized']);

  final String message;

  @override
  String toString() => 'UnauthorizedException: $message';
}

class ProgressMetric {
  ProgressMetric({
    required this.id,
    required this.profileId,
    required this.streak,
    required this.badges,
    required this.updatedAt,
    required this.dailyGoalProgress,
    required this.dailyGoalTarget,
    required this.lessonsCompleted,
  });

  final String id;
  final String profileId;
  final int streak;
  final List<String> badges;
  final DateTime updatedAt;
  final int dailyGoalProgress;
  final int dailyGoalTarget;
  final int lessonsCompleted;

  factory ProgressMetric.fromJson(Map<String, dynamic> json) {
    final badgesData = json['badges'] as List<dynamic>? ?? [];
    return ProgressMetric(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      streak: json['streak'] as int? ?? 0,
      badges: badgesData.map((e) => e as String).toList(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      dailyGoalProgress: json['daily_goal_progress'] as int? ?? 0,
      dailyGoalTarget: json['daily_goal_target'] as int? ?? 50,
      lessonsCompleted: json['lessons_completed'] as int? ?? 0,
    );
  }

  factory ProgressMetric.empty() {
    return ProgressMetric(
      id: 'empty',
      profileId: '',
      streak: 0,
      badges: const [],
      updatedAt: DateTime.now().toUtc(),
      dailyGoalProgress: 0,
      dailyGoalTarget: 50,
      lessonsCompleted: 0,
    );
  }
}

class ProgressService {
  ProgressService._();

  static final _client = SupabaseService.client;

  static Future<ProgressMetric> fetchForProfile(String profileId) async {
    try {
      final rows = await _client
          .from('progress_metrics')
          .select()
          .eq('profile_id', profileId)
          .order('updated_at', ascending: false)
          .limit(1);
      final result = rows as List<dynamic>? ?? [];
      if (result.isNotEmpty) {
        return ProgressMetric.fromJson(result.first as Map<String, dynamic>);
      }
    } catch (error) {
      if (error is PostgrestException && error.code == 'PGRST303') {
        throw UnauthorizedException(error.message);
      }
      throw Exception('Failed to load progress metrics: $error');
    }

    try {
      final PostgrestMap insert = await _client
          .from('progress_metrics')
          .insert({'profile_id': profileId})
          .select()
          .single();
      return ProgressMetric.fromJson(insert);
    } catch (error) {
      throw Exception('Failed to create progress metrics: $error');
    }
  }
}
