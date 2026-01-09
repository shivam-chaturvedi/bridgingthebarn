import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/translate_provider.dart';
import '../services/translation_service.dart';
import '../services/tts_service.dart';
import '../theme/theme_colors.dart';
import '../utils/language_utils.dart';
import '../widgets/settings_action_button.dart';

class SpeakScreen extends StatelessWidget {
  const SpeakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TranslateProvider(
        translationService: TranslationService(),
        ttsService: TtsService(),
      ),
      child: const _SpeakScreenBody(),
    );
  }
}

class _SpeakScreenBody extends StatelessWidget {
  const _SpeakScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TranslateProvider>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        elevation: 0,
        title: const Text('Speak & Translate'),
        actions: const [SettingsActionButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(provider, context),
            const SizedBox(height: 16),
            _buildStepIndicator(),
            const SizedBox(height: 16),
            _buildRecordCard(provider, context),
            const SizedBox(height: 16),
            _buildTranscribeCard(provider),
            const SizedBox(height: 16),
            _buildLanguageSelector(provider, context),
            const SizedBox(height: 16),
            _buildPlaybackCard(provider, context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TranslateProvider provider, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0F2D37),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Need to translate something?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text(
            'Speak in Tamil, Malayalam, or Hindi',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E6C92),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => provider.toggleRecording(context),
            icon: const Icon(Icons.mic, color: Colors.white),
            label: const Text('Tap to Speak', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Record', 'Transcribe', 'Language', 'Audio'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: steps
          .asMap()
          .entries
          .map(
            (entry) => Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white10,
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.value,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildRecordCard(TranslateProvider provider, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 1 • Record',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () => provider.toggleRecording(context),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: provider.isListening
                      ? Colors.redAccent
                      : Colors.white24,
                  child: Icon(
                    provider.isListening ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  provider.isListening
                      ? 'Listening...'
                      : 'Press to record English speech',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              if (provider.isListening)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTranscribeCard(TranslateProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 2 • Transcribe',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: provider.textController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Captured English text appears here',
              hintStyle: TextStyle(color: Colors.white30),
            ),
            onChanged: provider.updateSourceText,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E5469),
            ),
            onPressed: provider.isTranslating
                ? null
                : provider.transcribeAndTranslate,
            child: provider.isTranslating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Transcribe & Translate'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(
    TranslateProvider provider,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () => _showLanguagePicker(context, provider),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Text(
              provider.targetLanguage.flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step 3 • Select language',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${provider.targetLanguage.name} • ${provider.targetLanguage.locale}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, TranslateProvider provider) {
    String filter = '';
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF03070B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final availableLanguages = LanguageUtils.languages;
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = availableLanguages
                .where((lang) =>
                    lang.name.toLowerCase().contains(filter.toLowerCase()) ||
                    lang.code.toLowerCase().contains(filter.toLowerCase()))
                .toList();
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0F14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search languages...',
                          hintStyle: TextStyle(color: Colors.white38),
                          icon: Icon(Icons.search, color: Colors.white54),
                        ),
                        onChanged: (value) => setState(() => filter = value),
                      ),
                    ),
                  ),
                  LimitedBox(
                    maxHeight: MediaQuery.of(context).size.height * 0.55,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final language = filtered[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 2,
                          ),
                          leading: Text(language.flag, style: const TextStyle(fontSize: 24)),
                          title: Text(
                            language.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            language.locale,
                            style: const TextStyle(color: Colors.white54),
                          ),
                          trailing: provider.targetLanguage.code == language.code
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                          onTap: () {
                            provider.setTargetLanguage(language);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlaybackCard(TranslateProvider provider, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step 4 • Play Audio',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            provider.translatedText.isEmpty
                ? 'Translated text appears here'
                : provider.translatedText,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
            ),
            onPressed: provider.isPlaying ? null : provider.playTranslation,
            icon: const Icon(Icons.play_arrow),
            label: Text(provider.isPlaying ? 'Playing...' : 'Play Audio'),
          ),
        ],
      ),
    );
  }
}
