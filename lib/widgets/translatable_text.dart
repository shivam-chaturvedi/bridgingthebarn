import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_language_provider.dart';
import '../services/translation_manager.dart';

class TranslatableText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final language = context.watch<AppLanguageProvider>().language;
    final future = TranslationManager.instance.translate(text, language);
    return FutureBuilder<String>(
      future: future,
      builder: (_, snapshot) {
        final isDone = snapshot.connectionState == ConnectionState.done;
        final display = isDone && snapshot.hasData ? snapshot.data! : text;
        final baseStyle = style ?? const TextStyle(color: Colors.white);
        final subduedStyle = !isDone && baseStyle.color != null
            ? baseStyle.copyWith(color: baseStyle.color!.withOpacity(0.65))
            : baseStyle;
        return Text(
          display,
          style: subduedStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          semanticsLabel: semanticsLabel,
        );
      },
    );
  }
}
