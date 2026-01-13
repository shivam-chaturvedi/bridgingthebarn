import 'package:gotrue/gotrue.dart';

import 'profile_service.dart';
import 'supabase_service.dart';

/// Helper for account-level operations that need to touch both auth and profile data.
class AccountService {
  AccountService._();

  static final _client = SupabaseService.client;

  /// Updates the signed-in user with the provided information.
  static Future<void> updateAccount({
    String? displayName,
    String? email,
    String? password,
  }) async {
    final attributes = UserAttributes(
      email: email,
      password: password,
      data: displayName != null ? {'full_name': displayName} : null,
    );
    if (attributes.toJson().isEmpty) return;

    final response = await _client.auth.updateUser(attributes);
    final updatedUser = response.user;
    if (updatedUser == null) {
      throw const AuthException('Unable to update the account at this time.');
    }

    await ProfileService.ensureProfile(updatedUser);
  }

  /// Removes the signed-in profile row and signs the user out.
  static Future<void> deleteAccount() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      throw const AuthException('No signed-in account found.');
    }

    try {
      await _client.from('profiles').delete().eq('id', currentUser.id);
    } catch (error) {
      throw Exception('Could not delete profile: $error');
    }

    await _client.auth.signOut();
  }
}
