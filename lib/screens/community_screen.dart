import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/content.dart';
import '../screens/help_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/vocab_screen.dart';
import '../theme/theme_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_more_options.dart';
import '../widgets/common_widgets.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final List<String> _communityFilters = ['All', 'Questions', 'Wins', 'Tips'];
  final List<String> _postCategories = ['Tips', 'Questions', 'Wins'];
  String _selectedFilter = 'All';
  String _selectedPostCategory = 'Tips';
  final List<Map<String, Object>> _communityPosts = [
    {
      'id': 1,
      'author': 'Krishnan',
      'time': '2 hours ago',
      'type': 'Wall of Wins',
      'content':
          'Today I read a message to my daughter in English for the first time! She was so proud of me.',
      'likes': 24,
      'comments': 2,
      'commentsList': <Map<String, String>>[
        {'author': 'Arjun', 'text': 'Amazing job!', 'time': '1 hour ago'},
        {'author': 'Meena', 'text': 'So proud of you!', 'time': '30 min ago'},
      ],
    },
    {
      'id': 2,
      'author': 'Raj',
      'time': '5 hours ago',
      'type': 'Question',
      'content':
          "Question: What's the best way to explain 'hoof care' to the owner? I always get confused with the words.",
      'likes': 12,
      'comments': 1,
      'commentsList': <Map<String, String>>[
        {
          'author': 'Krishnan',
          'text': 'Use simple words like “hoof” and “care”.',
          'time': '4 hours ago',
        },
      ],
    },
    {
      'id': 3,
      'author': 'Priya',
      'time': '1 day ago',
      'type': 'Wall of Wins',
      'content':
          'Completed my first week of lessons! 50 phrases learned. Small steps, but I feel more confident already!',
      'likes': 31,
      'comments': 1,
      'commentsList': <Map<String, String>>[
        {'author': 'Lakshmi', 'text': 'Keep it up! 💪', 'time': '12 hours ago'},
      ],
    },
  ];

  List<Map<String, Object>> get _filteredCommunityPosts {
    if (_selectedFilter == 'All') return _communityPosts;
    return _communityPosts
        .where((post) => (post['type'] as String).contains(_selectedFilter))
        .toList();
  }

  void _addCommunityPost() {
    final text = _postController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _communityPosts.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch,
        'author': 'You',
        'time': 'Just now',
        'type': _selectedPostCategory,
        'content': text,
        'likes': 0,
        'comments': 0,
        'commentsList': <Map<String, String>>[],
      });
      _postController.clear();
      _selectedFilter = 'All';
    });
  }

  void _incrementLike(int id) {
    setState(() {
      final index = _communityPosts.indexWhere((post) => post['id'] == id);
      if (index >= 0) {
        final current = _communityPosts[index];
        current['likes'] = (current['likes'] as int) + 1;
      }
    });
  }

  void _addComment(Map<String, Object> post, String comment) {
    if (comment.trim().isEmpty) return;
    setState(() {
      final list = post['commentsList'] as List<Map<String, String>>;
      list.add({'author': 'You', 'text': comment.trim(), 'time': 'Just now'});
      post['comments'] = (post['comments'] as int) + 1;
    });
  }

  void _showCommentSheet(Map<String, Object> post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF020507),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              final comments =
                  post['commentsList'] as List<Map<String, String>>;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Comments (${comments.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...comments.map(
                      (comment) => ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF0E5469),
                          child: Text(comment['author']![0]),
                        ),
                        title: Text(
                          comment['text']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          comment['time']!,
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                      onChanged: (_) => setSheetState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0E5469),
                          ),
                          onPressed: _commentController.text.trim().isEmpty
                              ? null
                              : () {
                                  _addComment(post, _commentController.text);
                                  _commentController.clear();
                                  Navigator.pop(context);
                                },
                          child: const Text('Add Comment'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<MoreOption> _buildMoreOptions(BuildContext context) {
    return [
      MoreOption(
        label: 'Progress',
        icon: LucideIcons.activity,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ProgressScreen()),
          );
        },
      ),
      MoreOption(
        label: 'Vocab & Phrases',
        icon: Icons.book,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VocabScreen()),
          );
        },
      ),
      MoreOption(
        label: 'Help & Support',
        icon: Icons.headset,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HelpScreen()),
          );
        },
      ),
      MoreOption(
        label: 'Privacy Policy',
        icon: Icons.shield,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PrivacyScreen()),
          );
        },
      ),
    ];
  }

  @override
  void dispose() {
    _postController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: ThemeColors.communityHeaderDark,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'Community',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Share, learn, grow together'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CommunityStat(label: '156', subLabel: 'Active Today'),
                        CommunityStat(label: '89', subLabel: 'Posts This Week'),
                        CommunityStat(label: '342', subLabel: 'Members'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E3B2E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.white70),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Wall of Wins 🎉',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),
                          Text('15 members completed lessons this week!'),
                        ],
                      ),
                    ),
                    const Icon(Icons.auto_graph, color: Colors.white70),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _communityFilters.map((filter) {
                  final selected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    backgroundColor: const Color(0xFF041D25),
                    selectedColor: const Color(0xFF0E5469),
                    labelStyle: const TextStyle(color: Colors.white),
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF041D25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _postController,
                      minLines: 2,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            'Share an achievement, ask a question, or encourage others...',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Category',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _postCategories.map((category) {
                        final selected = _selectedPostCategory == category;
                        return ChoiceChip(
                          label: Text(category),
                          selected: selected,
                          backgroundColor: const Color(0xFF041D25),
                          selectedColor: const Color(0xFF0E5469),
                          labelStyle: TextStyle(color: selected ? Colors.white : Colors.white70),
                          onSelected: (_) => setState(() => _selectedPostCategory = category),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () => _postController.clear(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0E5469),
                          ),
                          onPressed: _addCommunityPost,
                          child: const Text('Post'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: _filteredCommunityPosts
                    .map(_buildCommunityPostCard)
                    .toList(),
              ),
              const SizedBox(height: 16),
              _buildGuidelinesCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3,
        moreOptions: _buildMoreOptions(context),
      ),
    );
  }

  Widget _buildCommunityPostCard(Map<String, Object> post) {
    final comments = post['commentsList'] as List<Map<String, String>>;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF041D26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0E5469),
                child: Text(
                  (post['author'] as String).substring(0, 1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['author'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    post['time'] as String,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E5469),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  post['type'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post['content'] as String,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => _incrementLike(post['id'] as int),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post['likes']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _showCommentSheet(post),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post['comments']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comments.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...comments
                .take(2)
                .map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${comment['author']}: ${comment['text']}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuidelinesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF011B25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.favorite, color: Colors.white70),
              SizedBox(width: 8),
              Text(
                'Community Guidelines',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...communityGuidelines
              .map(
                (rule) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Colors.white70)),
                      Expanded(
                        child: Text(
                          rule,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
