import '../utils/language_utils.dart';
import '../services/translation_service.dart';

class TranslationManager {
  TranslationManager._internal();

  static final TranslationManager instance = TranslationManager._internal();

  final TranslationService _translationService = TranslationService();
  final Map<String, Map<String, String>> _cache = {};
  final Map<String, Future<String>> _pendingRequests = {};

  String? cached(String text, LanguageDefinition language) {
    final languageCache = _cache[language.code];
    return languageCache?[text];
  }

  Future<String> translate(String text, LanguageDefinition language) async {
    if (text.isEmpty) return text;
    if (language.code == 'en') return text;

    final cacheKey = '${language.code}|$text';
    if (_cache[language.code]?.containsKey(text) ?? false) {
      return _cache[language.code]![text]!;
    }
    if (_pendingRequests.containsKey(cacheKey)) {
      return _pendingRequests[cacheKey]!;
    }

    final languageCache = _cache.putIfAbsent(language.code, () => {});
    final request = _translationService
        .translate(text, language.mlKitLanguage)
        .then((result) {
      languageCache[text] = result;
      _pendingRequests.remove(cacheKey);
      return result;
    }).catchError((_) {
      _pendingRequests.remove(cacheKey);
      return text;
    });
    _pendingRequests[cacheKey] = request;
    return request;
  }
}
