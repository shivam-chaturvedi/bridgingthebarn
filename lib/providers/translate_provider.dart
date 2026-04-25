import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

import '../services/gemini_service.dart';
import '../services/permission_service.dart';
import '../services/translation_service.dart';
import '../services/tts_service.dart';
import '../utils/language_utils.dart';

class TranslateProvider extends ChangeNotifier {
  TranslateProvider({
    required this.translationService,
    required this.ttsService,
    required this.geminiService,
    LanguageDefinition? initialLanguage,
  }) : targetLanguage = initialLanguage ?? LanguageUtils.defaultLanguage,
       inputLanguage = initialLanguage ?? LanguageUtils.defaultLanguage {
    _initSpeech();
  }

  final TranslationService translationService;
  final TtsService ttsService;
  final GeminiService geminiService;
  final SpeechToText _speech = SpeechToText();
  final TextEditingController textController = TextEditingController();

  bool isListening = false;
  bool isTranslating = false;
  bool isPlaying = false;
  bool isProcessingSpeech = false;
  String sourceText = '';
  String translatedText = '';
  String recordedText = '';
  String transcribedText = '';
  String detectedLanguageLabel = '';
  LanguageDefinition targetLanguage;
  LanguageDefinition? inputLanguage;
  LanguageDefinition? detectedLanguage;

  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: _handleSpeechStatus,
      onError: _handleSpeechError,
    );
  }

  void _handleSpeechStatus(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized == 'listening') return;
    if (!isListening) return;
    isListening = false;
    notifyListeners();
    Future.microtask(_processRecordedText);
  }

  void _handleSpeechError(SpeechRecognitionError error) {
    if (!isListening) return;
    isListening = false;
    notifyListeners();
  }

  Future<void> toggleRecording(BuildContext context) async {
    if (!await PermissionService.ensureMicrophonePermission(context)) return;
    if (isListening) {
      await _speech.stop();
      isListening = false;
      notifyListeners();
      await _processRecordedText();
      return;
    }

    recordedText = '';
    sourceText = '';
    translatedText = '';
    transcribedText = '';
    detectedLanguageLabel = '';
    textController.clear();
    isListening = true;
    notifyListeners();

    final localeId = (inputLanguage?.locale ?? LanguageUtils.defaultLanguage.locale)
        .replaceAll('-', '_');
    await _speech.listen(
      localeId: localeId,
      listenFor: const Duration(minutes: 2),
      pauseFor: const Duration(seconds: 8),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
      onResult: (result) {
        recordedText = result.recognizedWords;
        notifyListeners();
      },
    );
  }

  Future<void> _processRecordedText() async {
    if (recordedText.trim().isEmpty) return;
    isProcessingSpeech = true;
    notifyListeners();
    try {
      final geminiResult = await geminiService.detectAndNormalize(
        recordedText,
        LanguageUtils.languages,
        inputLanguage,
      );
      final resolvedDetected =
          LanguageUtils.findByName(geminiResult.detectedLanguage) ??
          inputLanguage ??
          LanguageUtils.defaultLanguage;
      detectedLanguageLabel = resolvedDetected.name;
      transcribedText = geminiResult.transcribedText;
      sourceText = geminiResult.transcribedText;
      translatedText = '';
      textController.text = transcribedText;
      detectedLanguage = resolvedDetected;
    } finally {
      isProcessingSpeech = false;
      notifyListeners();
    }
  }

  Future<void> transcribeAndTranslate() async {
    if (sourceText.isEmpty || isProcessingSpeech) return;
    isTranslating = true;
    notifyListeners();
    try {
      translatedText = await translationService.translate(
        sourceText,
        detectedLanguage?.mlKitLanguage ?? TranslateLanguage.english,
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
    translatedText = '';
    notifyListeners();
  }

  void setInputLanguage(LanguageDefinition language) {
    inputLanguage = language;
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

  @override
  void dispose() {
    textController.dispose();
    _speech.stop();
    super.dispose();
  }
}
