import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/content.dart';
import '../theme/theme_colors.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  String? _expandedModuleId = 'foundation';

  void _toggleModule(String id) {
    setState(() => _expandedModuleId = _expandedModuleId == id ? null : id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildProgressSummary(),
              const SizedBox(height: 16),
              _buildResumeCard(),
              const SizedBox(height: 16),
              ...modulesData.map(_buildModuleCard).toList(),
              const SizedBox(height: 16),
              _buildStudyTip(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF041C26),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
          const SizedBox(height: 10),
          const Text(
            'Learn English',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Step-by-step lessons for the workplace',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0C2340),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Overall Progress', style: TextStyle(color: Colors.white70)),
              Text('1/8 lessons', style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LinearProgressIndicator(
              value: 0.25,
              minHeight: 10,
              color: ThemeColors.accent,
              backgroundColor: Colors.white12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF041C26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_arrow, color: Colors.white54),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Continue where you left off\nWorkplace Communication',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0E5469),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(Map<String, Object> module) {
    final bool expanded = _expandedModuleId == module['id'];
    final lessons = module['lessons'] as List<Map<String, Object>>;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF041E2A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _toggleModule(module['id'] as String),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0E5469),
                  child: Icon(module['icon'] as IconData, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module['title'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        module['completed'] as String,
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LinearProgressIndicator(
              value: module['progress'] as double,
              minHeight: 8,
              color: const Color(0xFF0EAADC),
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: 12),
            Column(children: lessons.map(_buildLessonItem).toList()),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonItem(Map<String, Object> lesson) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF02131A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              lesson['status'] == 'locked' ? Icons.lock : Icons.play_arrow,
              color: Colors.white54,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  lesson['duration'] as String,
                  style: const TextStyle(color: Colors.white60),
                ),
              ],
            ),
            const Spacer(),
            if (lesson.containsKey('progress'))
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EAADC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  lesson['progress'] as String,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyTip() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C3B33),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Study Tip\nComplete one lesson per day. Consistency is more important than speed!',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

}
