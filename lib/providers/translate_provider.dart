import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/translation_service.dart';
import '../services/tts_service.dart';
import '../utils/language_utils.dart';

class TranslateProvider extends ChangeNotifier {
  TranslateProvider({
    required this.translationService,
    required this.ttsService,
  }) {
    _initSpeech();
  }

  final TranslationService translationService;
  final TtsService ttsService;
  final SpeechToText _speech = SpeechToText();
  final TextEditingController textController = TextEditingController();

  bool isListening = false;
  bool isTranslating = false;
  bool isPlaying = false;
  String sourceText = '';
  String translatedText = '';
  LanguageDefinition targetLanguage = LanguageUtils.defaultLanguage;

  Future<void> _initSpeech() async {
    await _speech.initialize();
  }

  Future<bool> _ensurePermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;
    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  Future<void> toggleRecording() async {
    if (!await _ensurePermission()) return;
    if (isListening) {
      await _speech.stop();
      isListening = false;
      notifyListeners();
      return;
    }
    isListening = true;
    notifyListeners();
    await _speech.listen(
      localeId: 'en_US',
      onResult: (result) {
        sourceText = result.recognizedWords;
        textController.text = sourceText;
        notifyListeners();
      },
    );
  }

  Future<void> transcribeAndTranslate() async {
    if (sourceText.isEmpty) return;
    isTranslating = true;
    notifyListeners();
    try {
      translatedText = await translationService.translate(
        sourceText,
        targetLanguage.mlKitLanguage,
      );
    } catch (_) {
      translatedText = sourceText;
    } finally {
      isTranslating = false;
      notifyListeners();
    }
  }

  void setTargetLanguage(LanguageDefinition language) {
    targetLanguage = language;
    notifyListeners();
  }

  Future<void> playTranslation() async {
    if (translatedText.isEmpty) return;
    isPlaying = true;
    notifyListeners();
    await ttsService.speak(translatedText, targetLanguage.locale);
    isPlaying = false;
    notifyListeners();
  }

  void updateSourceText(String text) {
    sourceText = text;
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    _speech.stop();
    super.dispose();
  }
}
