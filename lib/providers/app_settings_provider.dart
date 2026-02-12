import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  bool _translateUiCopy = true;
  bool _autoPlayAudio = true;
  bool _highlightKeyPhrases = true;

  bool get translateUiCopy => _translateUiCopy;
  bool get autoPlayAudio => _autoPlayAudio;
  bool get highlightKeyPhrases => _highlightKeyPhrases;

  void setTranslateUiCopy(bool value) {
    if (_translateUiCopy == value) return;
    _translateUiCopy = value;
    notifyListeners();
  }

  void setAutoPlayAudio(bool value) {
    if (_autoPlayAudio == value) return;
    _autoPlayAudio = value;
    notifyListeners();
  }

  void setHighlightKeyPhrases(bool value) {
    if (_highlightKeyPhrases == value) return;
    _highlightKeyPhrases = value;
    notifyListeners();
  }

  void toggleTranslateUiCopy() => setTranslateUiCopy(!_translateUiCopy);

  void toggleAutoPlayAudio() => setAutoPlayAudio(!_autoPlayAudio);

  void toggleHighlightKeyPhrases() =>
      setHighlightKeyPhrases(!_highlightKeyPhrases);
}
