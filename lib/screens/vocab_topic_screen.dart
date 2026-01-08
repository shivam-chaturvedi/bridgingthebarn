import 'package:flutter/material.dart';

import '../data/vocab_data.dart';

class VocabTopicScreen extends StatelessWidget {
  const VocabTopicScreen({required this.topic, super.key});

  final VocabTopic topic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF031824),
      appBar: AppBar(
        backgroundColor: const Color(0xFF041B24),
        title: Text(topic.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Vocabulary',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: topic.vocab
                  .map(
                    (word) => Container(
                      padding: const EdgeInsets.all(12),
                      width:
                          (MediaQueryData.fromWindow(
                                WidgetsBinding.instance.window,
                              ).size.width -
                              64) /
                          3,
                      decoration: BoxDecoration(
                        color: const Color(0xFF041D25),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            word,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Translation / Explanation',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Essential Phrases',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: topic.phrases.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final phrase = topic.phrases[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF02131A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white54),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                phrase,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Translation / explanation',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white24,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0E5469),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Text(
                  'Tap to hear audio',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
