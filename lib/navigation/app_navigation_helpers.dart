import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/main_navigation.dart';
import '../providers/auth_provider.dart';
import '../screens/auth_screen.dart';
import '../widgets/auth_required_placeholder.dart';

Future<void> navigateToTab(BuildContext context, int index) {
  return Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => MainNavigation(initialIndex: index)),
    (route) => false,
  );
}

Future<void> openAuthScreen(
  BuildContext context, {
  AuthTab initialTab = AuthTab.signIn,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => AuthScreen(initialTab: initialTab)),
  );
}

void showAuthRequiredSheet(
  BuildContext context, {
  required String feature,
}) {
  void openAuthForTab(AuthTab tab) {
    Navigator.of(context).pop();
    openAuthScreen(context, initialTab: tab);
  }

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF02141F),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: AuthRequiredPlaceholder(
          title: 'Unlock $feature',
          description: 'Sign in to $feature and keep participating, sharing, and tracking your progress.',
          onSignIn: () => openAuthForTab(AuthTab.signIn),
          onSignUp: () => openAuthForTab(AuthTab.signUp),
        ),
      );
    },
  );
}

void navigateToProtectedScreen({
  required BuildContext context,
  required String feature,
  required Widget screen,
}) {
  Navigator.pop(context);
  final auth = context.read<AuthProvider>();
  if (auth.isSignedIn) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  } else {
    showAuthRequiredSheet(context, feature: feature);
  }
}
