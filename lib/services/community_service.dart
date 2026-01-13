import 'package:postgrest/postgrest.dart';

import '../services/supabase_service.dart';

class CommunityComment {
  CommunityComment({
    required this.id,
    required this.postId,
    required this.profileId,
    required this.authorName,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String postId;
  final String profileId;
  final String authorName;
  final String comment;
  final DateTime createdAt;

  factory CommunityComment.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    return CommunityComment(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      profileId: json['profile_id'] as String,
      authorName: profile?['full_name'] as String? ?? 'Member',
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class CommunityPost {
  CommunityPost({
    required this.id,
    required this.profileId,
    required this.authorName,
    required this.content,
    required this.category,
    required this.type,
    required this.likeCount,
    required this.likedByUser,
    required this.createdAt,
    required this.comments,
  });

  final String id;
  final String profileId;
  final String authorName;
  final String content;
  final String category;
  final String type;
  final int likeCount;
  final bool likedByUser;
  final DateTime createdAt;
  final List<CommunityComment> comments;

  factory CommunityPost.fromJson(
    Map<String, dynamic> json,
    List<CommunityComment> comments, {
    required bool likedByUser,
    required int likeCount,
  }) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    return CommunityPost(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      authorName: profile?['full_name'] as String? ?? 'Member',
      content: json['content'] as String,
      category: json['category'] as String? ?? 'Tips',
      type: json['type'] as String? ?? 'post',
      likeCount: likeCount,
      likedByUser: likedByUser,
      createdAt: DateTime.parse(json['created_at'] as String),
      comments: comments,
    );
  }
}

class CommunityStats {
  CommunityStats({
    required this.activeToday,
    required this.postsThisWeek,
    required this.members,
  });

  final int activeToday;
  final int postsThisWeek;
  final int members;
}

class CommunityService {
  CommunityService._();

  static final _client = SupabaseService.client;

  static Future<CommunityStats> fetchStats() async {
    final now = DateTime.now().toUtc();
    final startOfDay = DateTime.utc(now.year, now.month, now.day);
    final startOfWeek = startOfDay.subtract(
      Duration(days: startOfDay.weekday - 1),
    );
    try {
      final todayResponse = await _client
          .from('community_posts')
          .select('id')
          .gte('created_at', startOfDay.toIso8601String())
          .count(CountOption.exact);
      final weekResponse = await _client
          .from('community_posts')
          .select('id')
          .gte('created_at', startOfWeek.toIso8601String())
          .count(CountOption.exact);
      final membersResponse = await _client
          .from('profiles')
          .select('id')
          .count(CountOption.exact);
      return CommunityStats(
        activeToday: todayResponse.count,
        postsThisWeek: weekResponse.count,
        members: membersResponse.count,
      );
    } catch (error) {
      throw Exception('Failed to load community stats: $error');
    }
  }

  static Future<List<CommunityPost>> fetchPosts({String? currentUserId}) async {
    try {
      final postData = await _client
          .from('community_posts')
          .select(
            'id, content, category, type, created_at, profile_id, profiles(full_name), '
            'community_post_likes(profile_id)',
          )
          .order('created_at', ascending: false);
      final commentData = await _client
          .from('community_comments')
          .select(
            'id, post_id, comment, profile_id, created_at, profiles(full_name)',
          )
          .order('created_at', ascending: true);

      final posts = postData as List<dynamic>? ?? [];
      final comments = commentData as List<dynamic>? ?? [];

      final commentsByPost = <String, List<CommunityComment>>{};
      for (final commentJson in comments.cast<Map<String, dynamic>>()) {
        final comment = CommunityComment.fromJson(commentJson);
        commentsByPost.putIfAbsent(comment.postId, () => []).add(comment);
      }

      return posts.cast<Map<String, dynamic>>().map((post) {
        final likes = post['community_post_likes'] as List<dynamic>? ?? [];
        final likeCount = likes.length;
        final likedByUser =
            currentUserId != null &&
            likes.any(
              (entry) => (entry['profile_id'] as String?) == currentUserId,
            );
        return CommunityPost.fromJson(
          post,
          commentsByPost[post['id'] as String] ?? [],
          likedByUser: likedByUser,
          likeCount: likeCount,
        );
      }).toList();
    } catch (error) {
      throw Exception('Failed to load community data: $error');
    }
  }

  static Future<void> addPost({
    required String profileId,
    required String content,
    required String category,
    required String type,
  }) async {
    try {
      await _client.from('community_posts').insert({
        'profile_id': profileId,
        'content': content,
        'category': category,
        'type': type,
      });
    } catch (error) {
      throw Exception('Failed to create community post: $error');
    }
  }

  static Future<bool> toggleLike({
    required String postId,
    required String profileId,
  }) async {
    try {
      final existing = await _client
          .from('community_post_likes')
          .select('id')
          .match({'post_id': postId, 'profile_id': profileId})
          .maybeSingle();
      if (existing != null) {
        await _client.from('community_post_likes').delete().match({
          'post_id': postId,
          'profile_id': profileId,
        });
        return false;
      }
      await _client.from('community_post_likes').insert({
        'post_id': postId,
        'profile_id': profileId,
      });
      return true;
    } catch (error) {
      throw Exception('Failed to toggle like: $error');
    }
  }

  static Future<void> addComment({
    required String postId,
    required String profileId,
    required String comment,
  }) async {
    try {
      await _client.from('community_comments').insert({
        'post_id': postId,
        'profile_id': profileId,
        'comment': comment,
      });
    } catch (error) {
      throw Exception('Failed to add comment: $error');
    }
  }
}
