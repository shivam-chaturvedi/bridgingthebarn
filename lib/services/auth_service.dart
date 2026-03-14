import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class AuthService {
  AuthService._();

  static SupabaseClient get _client => SupabaseService.client;

  static Session? get currentSession => _client.auth.currentSession;

  static Future<void> updatePassword({required String password}) async {
    await _ensureRecoverySession();
    await _client.auth.updateUser(UserAttributes(password: password));
  }

  static Future<void> signOut() => _client.auth.signOut();

  static Future<void> _ensureRecoverySession() async {
    if (_client.auth.currentSession == null) {
      throw const AuthException('Recovery session is not available.');
    }
  }
}
