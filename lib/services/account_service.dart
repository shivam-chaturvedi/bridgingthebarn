import 'dart:convert';

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
    final currentSession = _client.auth.currentSession;
    final userEmail = _client.auth.currentUser?.email;

    if (currentSession == null || userEmail == null) {
      throw const AuthException('No signed-in account found.');
    }

    try {
      final response = await _client.functions.invoke(
        'delete-user-account',
        headers: {
          'Authorization': 'Bearer ${currentSession.accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': userEmail}),
      );

      if (response.status != 200) {
        throw Exception(response.data.toString());
      }
    } catch (error) {
      throw Exception('Could not delete account: $error');
    }

    await _client.auth.signOut();
  }

}
