import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class ProfileService {
  ProfileService._();

  static final _client = SupabaseService.client;

  static Future<void> ensureProfile(User user) async {
    await _client.from('profiles').upsert({
      'id': user.id,
      'email': user.email,
      'full_name': user.userMetadata?['full_name'] as String? ?? user.email,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
