import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_language_provider.dart';
import '../providers/app_settings_provider.dart';
import '../services/translation_manager.dart';
import '../utils/language_utils.dart';

class TranslatableText extends StatefulWidget {
  const TranslatableText({
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.semanticsLabel,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final String? semanticsLabel;

  @override
  State<TranslatableText> createState() => _TranslatableTextState();
}

class _TranslatableTextState extends State<TranslatableText> {
  late LanguageDefinition _language;
  late Future<String> _translationFuture;
  late AppLanguageProvider _languageProvider;
  late AppSettingsProvider _settingsProvider;
  String? _lastText;
  bool _isLanguageInitialized = false;
  bool _translateUiCopyEnabled = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _languageProvider = Provider.of<AppLanguageProvider>(context);
    _settingsProvider = Provider.of<AppSettingsProvider>(context);
    _updateTranslation(force: true);
  }

  @override
  void didUpdateWidget(covariant TranslatableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _updateTranslation(force: true);
    }
  }

  void _updateTranslation({bool force = false}) {
    final newLanguage = _languageProvider.language;
    final shouldTranslate = _settingsProvider.translateUiCopy;
    final languageChanged =
        !_isLanguageInitialized || newLanguage.code != _language.code;
    final textChanged = _lastText != widget.text;
    final settingsChanged = shouldTranslate != _translateUiCopyEnabled;
    if (!languageChanged && !textChanged && !settingsChanged && !force) {
      return;
    }

    _translateUiCopyEnabled = shouldTranslate;
    _language = newLanguage;
    _isLanguageInitialized = true;
    _lastText = widget.text;
    if (!shouldTranslate || newLanguage.code == 'en') {
      _translationFuture = Future.value(widget.text);
      setState(() {});
      return;
    }

    final cached = TranslationManager.instance.cached(widget.text, _language);
    if (cached != null) {
      _translationFuture = Future.value(cached);
      setState(() {});
      return;
    }
    _languageProvider.translationStarted();
    _translationFuture = TranslationManager.instance
        .translate(widget.text, _language)
        .whenComplete(_languageProvider.translationFinished);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.style ?? const TextStyle(color: Colors.white);
    return FutureBuilder<String>(
      future: _translationFuture,
      builder: (_, snapshot) {
        final isDone = snapshot.connectionState == ConnectionState.done;
        final display = isDone && snapshot.hasData
            ? snapshot.data!
            : widget.text;
        final subduedStyle = !isDone && baseStyle.color != null
            ? baseStyle.copyWith(color: baseStyle.color!.withOpacity(0.65))
            : baseStyle;
        return Text(
          display,
          style: subduedStyle,
          textAlign: widget.textAlign,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
          softWrap: widget.softWrap,
          semanticsLabel: widget.semanticsLabel,
        );
      },
    );
  }
}
