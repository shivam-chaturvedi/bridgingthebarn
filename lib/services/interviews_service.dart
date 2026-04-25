import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class InterviewVideo {
  const InterviewVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.weekStart,
    required this.youtubeUrl,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime weekStart;
  final String youtubeUrl;
  final DateTime createdAt;

  factory InterviewVideo.fromRow(Map<String, dynamic> row) {
    return InterviewVideo(
      id: row['id'] as String,
      title: row['title'] as String? ?? '',
      description: row['description'] as String? ?? '',
      weekStart: DateTime.parse(row['week_start'] as String),
      youtubeUrl: row['youtube_url'] as String? ?? '',
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}

class InterviewsService {
  InterviewsService({SupabaseClient? client})
    : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<List<InterviewVideo>> listInterviews({
    DateTime? weekStart,
    String? query,
  }) async {
    final PostgrestFilterBuilder request = _client.from('interviews').select();

    if (weekStart != null) {
      final weekStartDate = DateTime.utc(
        weekStart.year,
        weekStart.month,
        weekStart.day,
      ).toIso8601String().split('T').first;
      request.eq('week_start', weekStartDate);
    }

    final normalizedQuery = query?.trim();
    if (normalizedQuery != null && normalizedQuery.isNotEmpty) {
      request.or(
        'title.ilike.%$normalizedQuery%,description.ilike.%$normalizedQuery%',
      );
    }

    final rows = await request
        .order('week_start', ascending: false)
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(InterviewVideo.fromRow)
        .toList();
  }

  static DateTime weekStartUtc(DateTime date) {
    final utc = DateTime.utc(date.year, date.month, date.day);
    final daysFromMonday = (utc.weekday - DateTime.monday) % 7;
    return utc.subtract(Duration(days: daysFromMonday));
  }
}
