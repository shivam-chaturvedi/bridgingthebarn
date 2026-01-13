import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../data/content.dart';
import '../navigation/app_navigation_helpers.dart';
import '../providers/auth_provider.dart';
import '../screens/account_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/help_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/vocab_screen.dart';
import '../services/community_service.dart';
import '../theme/theme_colors.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/app_more_options.dart';
import '../widgets/auth_required_placeholder.dart';
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
  late Future<List<CommunityPost>> _postsFuture;
  late Future<CommunityStats> _statsFuture;
  String _selectedFilter = 'All';
  String _selectedPostCategory = 'Tips';
  bool _isPosting = false;
  String? _postsUserId;

  @override
  void initState() {
    super.initState();
    _postsFuture = CommunityService.fetchPosts();
    _statsFuture = CommunityService.fetchStats();
  }

  Future<void> _refreshPosts(String userId) async {
    final postsFuture = CommunityService.fetchPosts(currentUserId: userId);
    final statsFuture = CommunityService.fetchStats();
    setState(() {
      _postsFuture = postsFuture;
      _statsFuture = statsFuture;
    });
    await Future.wait([postsFuture, statsFuture]);
  }

  Future<void> _submitPost() async {
    final content = _postController.text.trim();
    if (content.isEmpty) return;
    final profileId = context.read<AuthProvider>().userId;
    if (profileId == null) return;
    setState(() => _isPosting = true);
    try {
      await CommunityService.addPost(
        profileId: profileId,
        content: content,
        category: _selectedPostCategory,
        type: 'post',
      );
      _postController.clear();
      _selectedFilter = 'All';
      await _refreshPosts(profileId);
    } finally {
      setState(() => _isPosting = false);
    }
  }

  Future<void> _toggleLike(CommunityPost post, String userId) async {
    try {
      await CommunityService.toggleLike(postId: post.id, profileId: userId);
    } finally {
      await _refreshPosts(userId);
    }
  }

  void _ensurePosts(String userId) {
    if (_postsUserId == userId) return;
    _postsUserId = userId;
    _postsFuture = CommunityService.fetchPosts(currentUserId: userId);
    _statsFuture = CommunityService.fetchStats();
  }

  void _showCommentSheet(CommunityPost post) {
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
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Comments (${post.comments.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...post.comments.map(
                      (comment) => ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF0E5469),
                          child: Text(comment.authorName[0]),
                        ),
                        title: Text(
                          comment.comment,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          comment.authorName,
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
                              : () async {
                                  final profileId = context
                                      .read<AuthProvider>()
                                      .userId;
                                  if (profileId == null) return;
                                  final navigator = Navigator.of(context);
                                  await CommunityService.addComment(
                                    postId: post.id,
                                    profileId: profileId,
                                    comment: _commentController.text.trim(),
                                  );
                                  _commentController.clear();
                                  navigator.pop();
                                  await _refreshPosts(profileId);
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
        label: 'Account',
        icon: LucideIcons.user,
        onTap: () {
          navigateToProtectedScreen(
            context: context,
            feature: 'Account',
            screen: const AccountScreen(),
          );
        },
      ),
      MoreOption(
        label: 'Progress',
        icon: LucideIcons.activity,
        onTap: () {
          navigateToProtectedScreen(
            context: context,
            feature: 'Progress',
            screen: const ProgressScreen(),
          );
        },
      ),
      MoreOption(
        label: 'Vocab & Phrases',
        icon: Icons.book,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const VocabScreen()));
        },
      ),
      MoreOption(
        label: 'Help & Support',
        icon: Icons.headset,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const HelpScreen()));
        },
      ),
      MoreOption(
        label: 'Privacy Policy',
        icon: Icons.shield,
        onTap: () {
          Navigator.pop(context);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const PrivacyScreen()));
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
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isSignedIn) {
          return Scaffold(
            backgroundColor: ThemeColors.primary,
            body: SafeArea(
              child: AuthRequiredPlaceholder(
                title: 'Community members only',
                description:
                    'Sign in to share stories, ask questions, and celebrate wins.',
                onSignIn: () => openAuthScreen(context),
                onSignUp: () =>
                    openAuthScreen(context, initialTab: AuthTab.signUp),
              ),
            ),
            bottomNavigationBar: AppBottomNavigationBar(
              currentIndex: 3,
              moreOptions: _buildMoreOptions(context),
            ),
          );
        }
        final userId = auth.userId!;
        _ensurePosts(userId);
        final communityContent = RefreshIndicator(
          onRefresh: () => _refreshPosts(userId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
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
                      _buildLiveStats(),
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
                      onSelected: (_) =>
                          setState(() => _selectedFilter = filter),
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
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.white70,
                            ),
                            onSelected: (_) => setState(
                              () => _selectedPostCategory = category,
                            ),
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
                            onPressed: _isPosting ? null : _submitPost,
                            child: _isPosting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Post'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildLiveStats(),
                const SizedBox(height: 16),
                FutureBuilder<List<CommunityPost>>(
                  future: _postsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Unable to load posts.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    }
                    final posts = snapshot.data ?? [];
                    final filtered = _selectedFilter == 'All'
                        ? posts
                        : posts
                              .where(
                                (post) =>
                                    post.category.contains(_selectedFilter),
                              )
                              .toList();
                    if (filtered.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No posts yet – add the first win!',
                            style: TextStyle(color: Colors.white60),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: filtered
                          .map((post) => _buildCommunityPostCard(post, userId))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildGuidelinesCard(),
              ],
            ),
          ),
        );
        return Scaffold(
          backgroundColor: ThemeColors.primary,
          body: SafeArea(child: communityContent),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: 3,
            moreOptions: _buildMoreOptions(context),
          ),
        );
      },
    );
  }

  Widget _buildLiveStats() {
    return FutureBuilder<CommunityStats>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: const [
              CommunityStat(label: '--', subLabel: 'Active Today'),
              CommunityStat(label: '--', subLabel: 'Posts This Week'),
              CommunityStat(label: '--', subLabel: 'Members'),
            ],
          );
        }
        final stats = snapshot.data;
        if (snapshot.hasError || stats == null) {
          return Row(
            children: const [
              CommunityStat(label: '—', subLabel: 'Active Today'),
              CommunityStat(label: '—', subLabel: 'Posts This Week'),
              CommunityStat(label: '—', subLabel: 'Members'),
            ],
          );
        }
        return Row(
          children: [
            CommunityStat(
              label: '${stats.activeToday}',
              subLabel: 'Active Today',
            ),
            CommunityStat(
              label: '${stats.postsThisWeek}',
              subLabel: 'Posts This Week',
            ),
            CommunityStat(label: '${stats.members}', subLabel: 'Members'),
          ],
        );
      },
    );
  }

  Widget _buildCommunityPostCard(CommunityPost post, String userId) {
    final comments = post.comments;
    final liked = post.likedByUser;
    final heartIcon = liked ? Icons.favorite : Icons.favorite_border;
    final heartColor = liked ? Colors.redAccent : Colors.white70;
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
                  post.authorName[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${post.createdAt.toLocal()}'.split(' ')[0],
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
                  post.type,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.content, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => _toggleLike(post, userId),
                child: Row(
                  children: [
                    Icon(heartIcon, color: heartColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likeCount}',
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
                      '${comments.length}',
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
                            '${comment.authorName}: ${comment.comment}',
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
