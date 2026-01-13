import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/profile_service.dart';
import '../services/supabase_service.dart';

/// Simplified user data used for presentation in the app.
class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
  });

  final String id;
  final String email;
  final String displayName;

  factory AppUser.fromSupabase(User user) {
    final metadata = user.userMetadata ?? <String, dynamic>{};
    final displayName =
        (metadata['full_name'] as String?) ?? user.email ?? 'Bridging Barn Member';
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      displayName: displayName,
    );
  }
}

class AuthProvider extends ChangeNotifier {
  late final StreamSubscription _authSubscription;

  AuthProvider() {
    _authSubscription = SupabaseService.client.auth.onAuthStateChange.listen(
      (event) => _handleSession(event.session?.user),
    );
    _handleSession(SupabaseService.client.auth.currentUser);
  }

  AppUser? _user;
  bool _isProcessing = false;

  bool get isSignedIn => _user != null;
  bool get isProcessing => _isProcessing;
  String get displayName => _user?.displayName ?? 'Bridging Barn Member';
  String get email => _user?.email ?? '';
  String? get userId => _user?.id;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setProcessing(true);
    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw const AuthException('Unable to sign in at this time.');
      }
      await _storeUser(user);
    } finally {
      _setProcessing(false);
    }
  }

  Future<void> signUp({
    required String displayName,
    required String email,
    required String password,
  }) async {
    _setProcessing(true);
    try {
      final response = await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': displayName},
      );
      final user = response.user;
      if (user == null) {
        throw const AuthException('Unable to create an account right now.');
      }
      await _storeUser(user);
    } finally {
      _setProcessing(false);
    }
  }

  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> resetPassword(String email) {
    return SupabaseService.client.auth.resetPasswordForEmail(email);
  }

  Future<void> refreshUser() async {
    await _handleSession(SupabaseService.client.auth.currentUser);
  }

  Future<void> _handleSession(User? user) async {
    if (user == null) {
      _user = null;
      notifyListeners();
      return;
    }
    await _storeUser(user);
  }

  Future<void> _storeUser(User user) async {
    await ProfileService.ensureProfile(user);
    _user = AppUser.fromSupabase(user);
    notifyListeners();
  }

  void _setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
