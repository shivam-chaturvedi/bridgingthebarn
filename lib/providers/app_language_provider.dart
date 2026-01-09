import 'package:flutter/material.dart';

import '../utils/language_utils.dart';

class AppLanguageProvider extends ChangeNotifier {
  AppLanguageProvider() : _language = LanguageUtils.defaultLanguage;

  LanguageDefinition _language;

  LanguageDefinition get language => _language;

  void setLanguage(LanguageDefinition language) {
    if (_language.code == language.code) return;
    _language = language;
    notifyListeners();
  }
}
