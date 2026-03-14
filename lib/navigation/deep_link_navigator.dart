import 'package:flutter/material.dart';

import '../screens/invalid_reset_link_screen.dart';
import '../screens/reset_password_screen.dart';
import '../services/deep_link_handler.dart';

class DeepLinkNavigator {
  DeepLinkNavigator({required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  Future<void> navigate(DeepLinkResult result) async {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    switch (result.intent) {
      case DeepLinkIntent.resetPassword:
        await navigator.push(
          MaterialPageRoute(
            builder: (_) => const ResetPasswordScreen(),
            settings: const RouteSettings(name: 'ResetPassword'),
          ),
        );
        break;
      case DeepLinkIntent.invalid:
        await navigator.push(
          MaterialPageRoute(
            builder: (_) => InvalidResetLinkScreen(
              message: result.message ?? 'The reset link could not be verified.',
            ),
            settings: const RouteSettings(name: 'InvalidResetLink'),
          ),
        );
        break;
      case DeepLinkIntent.none:
        break;
    }
  }
}
