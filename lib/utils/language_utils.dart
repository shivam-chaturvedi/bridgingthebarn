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
      code: 'ml',
      name: 'മലയാളം',
      flag: '🇮🇳',
      mlKitLanguage: TranslateLanguage.malay,
      locale: 'ml-IN',
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
      languages.firstWhere((l) => l.code == 'ta');
}
