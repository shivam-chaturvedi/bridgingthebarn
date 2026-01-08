import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  TranslationService() : _modelManager = OnDeviceTranslatorModelManager();

  final OnDeviceTranslatorModelManager _modelManager;
  final Map<String, String> _cache = {};

  Future<void> _ensureModel(TranslateLanguage target) async {
    final modelTag = target.bcpCode;
    final downloaded = await _modelManager.isModelDownloaded(modelTag);
    if (!downloaded) {
      await _modelManager.downloadModel(modelTag);
    }
  }

  String _cacheKey(String text, TranslateLanguage language) =>
      '${language.bcpCode}|$text';

  Future<String> translate(String text, TranslateLanguage target) async {
    final key = _cacheKey(text, target);
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    await _ensureModel(target);
    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: target,
    );
    try {
      final result = await translator.translateText(text);
      _cache[key] = result;
      return result;
    } finally {
      await translator.close();
    }
  }
}
