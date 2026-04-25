import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../utils/language_utils.dart';

class GeminiDetectionResult {
  const GeminiDetectionResult({
    required this.detectedLanguage,
    required this.transcribedText,
    required this.englishText,
  });

  final String detectedLanguage;
  final String transcribedText;
  final String englishText;
}

class GeminiService {
  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  List<String> get _apiKeys {
    return [
          dotenv.env['GEMINI_API_KEY'],
          dotenv.env['GEMINI_API_KEY1'],
          dotenv.env['GEMINI_API_KEY2'],
          dotenv.env['GEMINI_API_KEY3'],
        ]
        .where((key) => key != null && key.trim().isNotEmpty)
        .cast<String>()
        .toList();
  }

  Future<GeminiDetectionResult> detectAndNormalize(
    String text,
    List<LanguageDefinition> supportedLanguages,
    LanguageDefinition? expectedLanguage,
  ) async {
    final keys = _apiKeys;
    if (keys.isEmpty) {
      return _fallbackResult(text, supportedLanguages, expectedLanguage);
    }

    for (final apiKey in keys) {
      final result = await _tryFetchDetection(
        text,
        supportedLanguages,
        expectedLanguage,
        apiKey,
      );
      if (result != null) return result;
    }

    return _fallbackResult(text, supportedLanguages, expectedLanguage);
  }

  GeminiDetectionResult _fallbackResult(
    String text,
    List<LanguageDefinition> supportedLanguages,
    LanguageDefinition? expectedLanguage,
  ) {
    final fallbackLanguage =
        expectedLanguage?.name ??
        (supportedLanguages.isNotEmpty
            ? supportedLanguages.first.name
            : 'English');
    return GeminiDetectionResult(
      detectedLanguage: fallbackLanguage,
      transcribedText: text,
      englishText: text,
    );
  }

  Future<GeminiDetectionResult?> _tryFetchDetection(
    String text,
    List<LanguageDefinition> supportedLanguages,
    LanguageDefinition? expectedLanguage,
    String apiKey,
  ) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateText',
    ).replace(queryParameters: {'key': apiKey});

    final supportedList = supportedLanguages
        .map((lang) => '${lang.name} [code=${lang.code}, locale=${lang.locale}]')
        .join(', ');
    final expectedLabel =
        expectedLanguage?.name ?? 'the user selected language';
    final expectedLocale = expectedLanguage?.locale ?? 'the user\'s locale';
    final promptText =
        '''
You are a precise bi-lingual transcription assistant.
The user spoke in $expectedLabel ($expectedLocale) using natural conversational speech that may mix romanized words. 
First, detect the language they spoke and return the language code (for example: "hi", "ta", "en") from the supported list (the app has already selected $expectedLabel but confirm you treated the transcript as that language). 
Next, write the transcript in clean, properly capitalized and spaced native text for that language (keep any punctuation the speaker intended, convert romanized representations to the proper script, and do not transliterate back to English). 
Finally, provide an accurate English paraphrase that captures the meaning of what was said.
Supported languages include: $supportedList.
Respond only with a JSON object containing three keys: "detectedLanguage", "transcribedText", and "englishText".

Examples:
- Input: "kaam chal raha hai" → Detected: "hi", Transcribed: "काम चल रहा है", English: "Work is going on".
- Input: "today I will finish this" → Detected: "en", Transcribed: "Today I will finish this", English: "Today I will finish this".

Transcript:
$text
''';

    final payload = {
      'prompt': {'text': promptText},
      'temperature': 0.2,
      'topP': 0.9,
      'candidateCount': 1,
    };

    try {
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode >= 400) return null;

      final body = jsonDecode(response.body) as Map<String, dynamic>?;
      final candidates = body?['candidates'] as List<dynamic>?;
      final rawOutput = _extractOutput(candidates);
      if (rawOutput == null) return null;

      final parsed = jsonDecode(rawOutput) as Map<String, dynamic>;
      final detected = (parsed['detectedLanguage'] as String?)?.trim();
      final transcribedText = (parsed['transcribedText'] as String?)?.trim();
      final englishText = (parsed['englishText'] as String?)?.trim();
      final fallbackLanguage =
          expectedLanguage?.name ??
          (supportedLanguages.isNotEmpty
              ? supportedLanguages.first.name
              : 'English');
      return GeminiDetectionResult(
        detectedLanguage: detected?.isNotEmpty == true
            ? detected!
            : fallbackLanguage,
        transcribedText: transcribedText?.isNotEmpty == true
            ? transcribedText!
            : text,
        englishText: englishText?.isNotEmpty == true ? englishText! : text,
      );
    } catch (_) {
      return null;
    }
  }

  static String? _extractOutput(List<dynamic>? candidates) {
    if (candidates == null || candidates.isEmpty) return null;
    final candidate = candidates.first as Map<String, dynamic>?;
    if (candidate == null) return null;

    final output = candidate['output'] as String?;
    if (output != null && output.trim().isNotEmpty) {
      return output;
    }

    final content = candidate['content'] as List<dynamic>?;
    if (content != null && content.isNotEmpty) {
      final first = content.first as Map<String, dynamic>?;
      final text = first?['text'] as String?;
      if (text != null && text.trim().isNotEmpty) {
        return text;
      }
    }

    return null;
  }

  Future<String?> translateText({
    required String text,
    required LanguageDefinition sourceLanguage,
    required LanguageDefinition targetLanguage,
  }) async {
    final keys = _apiKeys;
    if (keys.isEmpty) return null;

    final promptText = '''
You are a precise translation assistant.
Translate the following text spoken in ${sourceLanguage.name} (${sourceLanguage.locale}) into ${targetLanguage.name} (${targetLanguage.locale}).
Preserve meaning, idioms, and formatting; do not add explanations.
Return only a JSON object with one key: "translatedText".

Text:
$text
''';

    final payload = {
      'prompt': {'text': promptText},
      'temperature': 0.2,
      'topP': 0.9,
      'candidateCount': 1,
    };

    for (final apiKey in keys) {
      final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateText',
      ).replace(queryParameters: {'key': apiKey});
      try {
        final response = await _client.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );
        if (response.statusCode >= 400) continue;
        final body = jsonDecode(response.body) as Map<String, dynamic>?;
        final candidates = body?['candidates'] as List<dynamic>?;
        final rawOutput = _extractOutput(candidates);
        if (rawOutput == null) continue;
        final parsed = jsonDecode(rawOutput) as Map<String, dynamic>;
        final translatedText = (parsed['translatedText'] as String?)?.trim();
        if (translatedText != null && translatedText.isNotEmpty) {
          return translatedText;
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }
}
