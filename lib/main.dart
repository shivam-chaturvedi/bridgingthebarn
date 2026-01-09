import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'navigation/main_navigation.dart';
import 'providers/app_language_provider.dart';
import 'theme/theme_colors.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    if (kReleaseMode) {
      Zone.current.handleUncaughtError(
        details.exception,
        details.stack ?? StackTrace.current,
      );
    } else {
      FlutterError.presentError(details);
    }
  };
  ErrorWidget.builder = (details) => AppErrorWidget(details: details);

  runZonedGuarded(
    () => runApp(const BridgingBarnApp()),
    (error, stack) {
      debugPrint('Uncaught app error: $error\n$stack');
    },
  );
}

class BridgingBarnApp extends StatelessWidget {
  const BridgingBarnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppLanguageProvider(),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Bridging the Barn',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ThemeColors.accent,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: ThemeColors.primary,
          fontFamily: 'SFProDisplay',
        ),
        home: const MainNavigation(),
      ),
    );
  }
}

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key, required this.details});

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ThemeColors.primary,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.white70,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Oops! Something went wrong.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'We logged it for you. Tap the button below to try again—everything should be back to normal.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.accent,
                  ),
                  onPressed: () {
                    _navigatorKey.currentState?.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainNavigation()),
                      (route) => false,
                    );
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
