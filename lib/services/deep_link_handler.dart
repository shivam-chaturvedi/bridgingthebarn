import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

enum DeepLinkIntent {
  none,
  resetPassword,
  invalid,
}

class DeepLinkResult {
  const DeepLinkResult._({
    required this.intent,
    this.uri,
    this.message,
  });

  factory DeepLinkResult.reset({required Uri uri}) {
    return DeepLinkResult._(
      intent: DeepLinkIntent.resetPassword,
      uri: uri,
    );
  }

  factory DeepLinkResult.invalid({required String message, Uri? uri}) {
    return DeepLinkResult._(
      intent: DeepLinkIntent.invalid,
      uri: uri,
      message: message,
    );
  }

  const DeepLinkResult.none()
      : intent = DeepLinkIntent.none,
        uri = null,
        message = null;

  final DeepLinkIntent intent;
  final Uri? uri;
  final String? message;
}

class DeepLinkHandler {
  const DeepLinkHandler();

  Future<DeepLinkResult> handle(Uri uri) async {
    if (!_isResetPath(uri)) {
      return const DeepLinkResult.none();
    }

    final query = uri.queryParameters;
    if (query['type']?.toLowerCase() != 'recovery') {
      return DeepLinkResult.invalid(
        message: 'The link is not a password recovery link.',
        uri: uri,
      );
    }

    final accessToken = query['access_token'];
    final refreshToken = query['refresh_token'];
    if (accessToken == null || refreshToken == null) {
      return DeepLinkResult.invalid(
        message: 'The recovery link is missing tokens.',
        uri: uri,
      );
    }

    try {
      await SupabaseService.client.auth.signOut();
      final response = await SupabaseService.client.auth.getSessionFromUrl(uri);
      final session = response.session;
      if (session?.accessToken == null || session?.refreshToken == null) {
        return DeepLinkResult.invalid(
          message: 'Could not restore the recovery session.',
          uri: uri,
        );
      }
      return DeepLinkResult.reset(uri: uri);
    } on AuthException catch (error) {
      return DeepLinkResult.invalid(
        message: error.message ?? 'Invalid or expired reset link.',
        uri: uri,
      );
    } catch (error) {
      return DeepLinkResult.invalid(
        message: 'Unable to process the reset link.',
        uri: uri,
      );
    }
  }

  bool _isResetPath(Uri uri) {
    final maybePath = uri.path.replaceFirst('/', '').toLowerCase();
    final host = uri.host.toLowerCase();
    if (maybePath == 'reset-password' || host == 'reset-password') {
      return true;
    }
    if (uri.scheme == 'https' && maybePath.startsWith('reset-password')) {
      return true;
    }
    return false;
  }
}
