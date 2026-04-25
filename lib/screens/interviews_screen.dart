import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/interviews_service.dart';
import '../theme/theme_colors.dart';

class InterviewsScreen extends StatefulWidget {
  const InterviewsScreen({super.key});

  @override
  State<InterviewsScreen> createState() => _InterviewsScreenState();
}

class _InterviewsScreenState extends State<InterviewsScreen> {
  final InterviewsService _service = InterviewsService();
  final TextEditingController _searchController = TextEditingController();

  bool _loading = true;
  List<InterviewVideo> _all = const [];
  List<DateTime> _weeks = const [];
  DateTime? _selectedWeekStart;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFilters);
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final videos = await _service.listInterviews();
      if (!mounted) return;
      _all = videos;
      _weeks = _extractWeeks(videos);
      _selectedWeekStart ??= _weeks.isNotEmpty ? _weeks.first : null;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load interviews: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    if (!mounted) return;
    setState(() {});
  }

  List<InterviewVideo> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    final week = _selectedWeekStart;
    return _all.where((video) {
      final matchesWeek = week == null || _isSameDate(video.weekStart, week);
      if (!matchesWeek) return false;
      if (query.isEmpty) return true;
      final haystack = '${video.title}\n${video.description}'.toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  InterviewVideo? get _weeklyFeatured {
    final week = _selectedWeekStart;
    if (week == null) return null;
    final inWeek = _all.where((v) => _isSameDate(v.weekStart, week)).toList();
    if (inWeek.isEmpty) return null;
    inWeek.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return inWeek.first;
  }

  @override
  Widget build(BuildContext context) {
    final featured = _weeklyFeatured;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Interviews'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _buildSearch(),
                  const SizedBox(height: 12),
                  _buildWeekFilter(),
                  const SizedBox(height: 16),
                  if (featured != null) ...[
                    _buildSectionTitle('Weekly video'),
                    const SizedBox(height: 10),
                    _InterviewCard(
                      video: featured,
                      onPlay: () => _openExternally(featured),
                      videoId: _extractYoutubeVideoId(featured.youtubeUrl),
                      isFeatured: true,
                    ),
                    const SizedBox(height: 18),
                  ],
                  _buildSectionTitle('All videos'),
                  const SizedBox(height: 10),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        'No videos match your search/filter.',
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ...filtered.map(
                      (video) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _InterviewCard(
                          video: video,
                          onPlay: () => _openExternally(video),
                          videoId: _extractYoutubeVideoId(video.youtubeUrl),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0F14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search by title or description...',
          hintStyle: TextStyle(color: Colors.white38),
          icon: Icon(Icons.search, color: Colors.white54),
        ),
      ),
    );
  }

  Widget _buildWeekFilter() {
    if (_weeks.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _weeks.map((week) {
          final selected =
              _selectedWeekStart != null && _isSameDate(_selectedWeekStart!, week);
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(_formatWeek(week)),
              selected: selected,
              onSelected: (_) => setState(() => _selectedWeekStart = week),
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
              ),
              selectedColor: const Color(0xFF0E6C92),
              backgroundColor: Colors.white10,
              side: const BorderSide(color: Colors.white10),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Future<void> _openExternally(InterviewVideo video) async {
    final videoId = _extractYoutubeVideoId(video.youtubeUrl);
    if (videoId == null || videoId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid YouTube link')),
      );
      return;
    }

    final uri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open YouTube')),
      );
    }
  }

  static List<DateTime> _extractWeeks(List<InterviewVideo> videos) {
    final unique = <String, DateTime>{};
    for (final v in videos) {
      final date = DateTime.utc(v.weekStart.year, v.weekStart.month, v.weekStart.day);
      unique[date.toIso8601String().split('T').first] = date;
    }
    final list = unique.values.toList();
    list.sort((a, b) => b.compareTo(a));
    return list;
  }

  static bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _formatWeek(DateTime weekStart) {
    final y = weekStart.year.toString().padLeft(4, '0');
    final m = weekStart.month.toString().padLeft(2, '0');
    final d = weekStart.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String? _extractYoutubeVideoId(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    try {
      final uri = Uri.parse(trimmed);
      final host = uri.host.toLowerCase();
      if (host == 'youtu.be') {
        final segs = uri.pathSegments;
        if (segs.isNotEmpty && segs.first.length == 11) return segs.first;
      }
      if (host.endsWith('youtube.com')) {
        final v = uri.queryParameters['v'];
        if (v != null && v.length == 11) return v;
        final segs = uri.pathSegments;
        final embedIndex = segs.indexOf('embed');
        if (embedIndex != -1 && segs.length > embedIndex + 1) {
          final id = segs[embedIndex + 1];
          if (id.length == 11) return id;
        }
        final shortsIndex = segs.indexOf('shorts');
        if (shortsIndex != -1 && segs.length > shortsIndex + 1) {
          final id = segs[shortsIndex + 1];
          if (id.length == 11) return id;
        }
      }
    } catch (_) {
      // ignore parse errors, fall through
    }

    if (trimmed.length == 11 &&
        RegExp(r'^[-_a-zA-Z0-9]{11}$').hasMatch(trimmed)) {
      return trimmed;
    }
    return null;
  }

  static String _youtubeThumbnailUrl(String videoId) {
    return 'https://i3.ytimg.com/vi/$videoId/hqdefault.jpg';
  }
}

class _InterviewCard extends StatelessWidget {
  const _InterviewCard({
    required this.video,
    required this.onPlay,
    required this.videoId,
    this.isFeatured = false,
  });

  final InterviewVideo video;
  final VoidCallback onPlay;
  final String? videoId;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = videoId == null
        ? null
        : _InterviewsScreenState._youtubeThumbnailUrl(videoId!);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isFeatured ? Colors.white24 : Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (thumbnailUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.white10,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white54,
                          size: 56,
                        ),
                      ),
                    ),
                    Container(color: Colors.black.withValues(alpha: 0.15)),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(onTap: onPlay),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  video.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: onPlay,
                icon: const Icon(Icons.play_circle_fill),
                color: const Color(0xFF6C63FF),
                iconSize: 34,
                tooltip: 'Play',
              ),
            ],
          ),
          if (video.description.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              video.description,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.white54),
              const SizedBox(width: 6),
              Text(
                'Week start: ${_InterviewsScreenState._formatWeek(video.weekStart)}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
