import 'package:flutter/material.dart';

import '../utils/language_utils.dart';

class AppLanguageProvider extends ChangeNotifier {
  AppLanguageProvider() : _language = LanguageUtils.defaultLanguage;

  LanguageDefinition _language;
  int _pendingTranslations = 0;

  LanguageDefinition get language => _language;
  bool get translationInProgress => _pendingTranslations > 0;

  void setLanguage(LanguageDefinition language) {
    if (_language.code == language.code) return;
    _language = language;
    notifyListeners();
  }

  void translationStarted() {
    _pendingTranslations++;
    notifyListeners();
  }

  void translationFinished() {
    if (_pendingTranslations > 0) {
      _pendingTranslations--;
      notifyListeners();
    }
  }
}
