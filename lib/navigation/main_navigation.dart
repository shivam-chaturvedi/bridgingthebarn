import 'package:flutter/material.dart';

import '../screens/community_screen.dart';
import '../screens/home_screen.dart';
import '../screens/lessons_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/speak_screen.dart';
import '../screens/vocab_screen.dart';
import '../theme/theme_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static final _tabs = [
    const HomeScreen(),
    const SpeakScreen(),
    const LessonsScreen(),
  ];

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF02121B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MoreOptionTile(
                label: 'Community',
                icon: LucideIcons.userPlus,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CommunityScreen()),
                  );
                },
              ),
              _MoreOptionTile(
                label: 'Progress',
                icon: LucideIcons.activity,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProgressScreen()),
                  );
                },
              ),
              _MoreOptionTile(
                label: 'Vocab & Phrases',
                icon: LucideIcons.bookOpen,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VocabScreen()),
                  );
                },
              ),
              _MoreOptionTile(
                label: 'Help & Support',
                icon: LucideIcons.headset,
                onTap: () {
                  Navigator.pop(context);
                  _showInfoDialog(
                    context,
                    'Help & Support',
                    'Reach out to support@bridgingbarn.com for assistance.',
                  );
                },
              ),
              _MoreOptionTile(
                label: 'Privacy Policy',
                icon: LucideIcons.shieldCheck,
                onTap: () {
                  Navigator.pop(context);
                  _showInfoDialog(
                    context,
                    'Privacy Policy',
                    'We value your privacy. Data stays on device unless you opt-in.',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF041B24),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: ThemeColors.primary,
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _tabs),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          return BottomNavigationBar(
            backgroundColor: ThemeColors.primary,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == _tabs.length) {
                _showMoreOptions(context);
                return;
              }
              setState(() => _selectedIndex = index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.house),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.languages),
                label: 'Translate',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.bookOpen),
                label: 'Lessons',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.menu),
                label: 'More',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MoreOptionTile extends StatelessWidget {
  const _MoreOptionTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
