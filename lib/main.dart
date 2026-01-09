import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'navigation/main_navigation.dart';
import 'providers/app_language_provider.dart';
import 'theme/theme_colors.dart';

void main() {
  runApp(const BridgingBarnApp());
}

class BridgingBarnApp extends StatelessWidget {
  const BridgingBarnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppLanguageProvider(),
      child: MaterialApp(
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
