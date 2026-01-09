import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../navigation/app_navigation_helpers.dart';
import '../theme/theme_colors.dart';
import 'app_more_options.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    required this.moreOptions,
    super.key,
  });

  final int currentIndex;
  final List<MoreOption> moreOptions;

  void _onTap(BuildContext context, int index) {
    if (index == 3) {
      showAppMoreOptions(context, moreOptions);
      return;
    }
    navigateToTab(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: ThemeColors.primary,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(LucideIcons.house), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.languages), label: 'Translate'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.bookOpen), label: 'Lessons'),
        BottomNavigationBarItem(icon: Icon(LucideIcons.menu), label: 'More'),
      ],
    );
  }
}
