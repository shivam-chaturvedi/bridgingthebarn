import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService() : _flutterTts = FlutterTts();

  final FlutterTts _flutterTts;

  Future<void> speak(String text, String locale) async {
    await _flutterTts.setLanguage(locale);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async => _flutterTts.stop();
}
