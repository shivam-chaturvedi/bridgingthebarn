import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class LanguageDefinition {
  const LanguageDefinition({
    required this.code,
    required this.name,
    required this.flag,
    required this.mlKitLanguage,
    required this.locale,
  });

  final String code;
  final String name;
  final String flag;
  final TranslateLanguage mlKitLanguage;
  final String locale;
}

class LanguageUtils {
  static const languages = [
    LanguageDefinition(
      code: 'en',
      name: 'English',
      flag: '🇺🇸',
      mlKitLanguage: TranslateLanguage.english,
      locale: 'en-US',
    ),
    LanguageDefinition(
      code: 'zh',
      name: '中文',
      flag: '🇨🇳',
      mlKitLanguage: TranslateLanguage.chinese,
      locale: 'zh-CN',
    ),
    LanguageDefinition(
      code: 'ms',
      name: 'Bahasa Melayu',
      flag: '🇲🇾',
      mlKitLanguage: TranslateLanguage.malay,
      locale: 'ms-MY',
    ),
    LanguageDefinition(
      code: 'hi',
      name: 'हिंदी',
      flag: '🇮🇳',
      mlKitLanguage: TranslateLanguage.hindi,
      locale: 'hi-IN',
    ),
    LanguageDefinition(
      code: 'ta',
      name: 'தமிழ்',
      flag: '🇮🇳',
      mlKitLanguage: TranslateLanguage.tamil,
      locale: 'ta-IN',
    ),
    LanguageDefinition(
      code: 'te',
      name: 'తెలుగు',
      flag: '🇮🇳',
      mlKitLanguage: TranslateLanguage.telugu,
      locale: 'te-IN',
    ),
    LanguageDefinition(
      code: 'kn',
      name: 'ಕನ್ನಡ',
      flag: '🇮🇳',
      mlKitLanguage: TranslateLanguage.kannada,
      locale: 'kn-IN',
    ),
    LanguageDefinition(
      code: 'mr',
      name: 'मराठी',
      flag: '🇮🇳',
      mlKitLanguage: TranslateLanguage.marathi,
      locale: 'mr-IN',
    ),
    LanguageDefinition(
      code: 'bn',
      name: 'বাংলা',
      flag: '🇮🇳',
      mlKitLanguage: TranslateLanguage.bengali,
      locale: 'bn-IN',
    ),
    LanguageDefinition(
      code: 'gu',
      name: 'ગુજરાતી',
      flag: '🇮🇳',
      mlKitLanguage: TranslateLanguage.gujarati,
      locale: 'gu-IN',
    ),
  ];

  static LanguageDefinition get defaultLanguage =>
      languages.firstWhere((l) => l.code == 'en');

  static final Map<String, String> _aliasToCode = {
    'english': 'en',
    'hindi': 'hi',
    'tamil': 'ta',
    'telugu': 'te',
    'kannada': 'kn',
    'marathi': 'mr',
    'marati': 'mr',
    'bengali': 'bn',
    'bangla': 'bn',
    'gujarati': 'gu',
    'gujrati': 'gu',
    'chinese': 'zh',
    'mandarin': 'zh',
    'zhongwen': 'zh',
    'malay': 'ms',
    'melayu': 'ms',
    'bahasamelayu': 'ms',
  };

  static String _normalizeLocale(String input) =>
      input.trim().toLowerCase().replaceAll('_', '-');

  static String _normalizeAsciiToken(String input) =>
      input.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');

  static LanguageDefinition? findByName(String name) {
    final raw = name.trim();
    if (raw.isEmpty) return null;

    final normalized = raw.toLowerCase();
    final normalizedLocale = _normalizeLocale(raw);
    final normalizedAscii = _normalizeAsciiToken(raw);

    for (final lang in languages) {
      final langLocale = _normalizeLocale(lang.locale);
      if (lang.name.toLowerCase() == normalized ||
          lang.code.toLowerCase() == normalized ||
          langLocale == normalizedLocale ||
          _normalizeAsciiToken(langLocale) == normalizedAscii) {
        return lang;
      }
    }

    final localeMatches = RegExp(
      r'\b[a-z]{2}[-_][a-z]{2}\b',
      caseSensitive: false,
    ).allMatches(raw);
    for (final match in localeMatches) {
      final token = match.group(0);
      if (token == null) continue;
      final candidate = _normalizeLocale(token);
      for (final lang in languages) {
        if (_normalizeLocale(lang.locale) == candidate) return lang;
      }
    }

    final codeMatches = RegExp(
      r'\b[a-z]{2}\b',
      caseSensitive: false,
    ).allMatches(raw);
    for (final match in codeMatches) {
      final token = match.group(0);
      if (token == null) continue;
      final code = token.toLowerCase();
      for (final lang in languages) {
        if (lang.code.toLowerCase() == code) return lang;
      }
    }

    final aliasCode = _aliasToCode[normalizedAscii];
    if (aliasCode != null) {
      for (final lang in languages) {
        if (lang.code == aliasCode) return lang;
      }
    }
    return null;
  }
}
