import 'package:flutter/material.dart';

import 'navigation/main_navigation.dart';
import 'theme/theme_colors.dart';

void main() {
  runApp(const BridgingBarnApp());
}

class BridgingBarnApp extends StatelessWidget {
  const BridgingBarnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
