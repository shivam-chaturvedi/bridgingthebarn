import '../utils/language_utils.dart';
import '../services/translation_service.dart';

class TranslationManager {
  TranslationManager._internal();

  static final TranslationManager instance = TranslationManager._internal();

  final TranslationService _translationService = TranslationService();
  final Map<String, Map<String, String>> _cache = {};

  Future<String> translate(String text, LanguageDefinition language) async {
    if (text.isEmpty) return text;
    if (language.code == 'en') return text;

    final languageCache = _cache.putIfAbsent(language.code, () => {});
    if (languageCache.containsKey(text)) {
      return languageCache[text]!;
    }

    try {
      final result = await _translationService.translate(text, language.mlKitLanguage);
      languageCache[text] = result;
      return result;
    } catch (_) {
      return text;
    }
  }
}
