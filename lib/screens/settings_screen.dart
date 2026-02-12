import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/app_language_provider.dart';
import '../providers/app_settings_provider.dart';
import '../theme/theme_colors.dart';
import '../utils/language_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: Consumer2<AppLanguageProvider, AppSettingsProvider>(
        builder: (context, languageProvider, settingsProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Personalize the experience',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildLanguageTile(languageProvider),
              const SizedBox(height: 20),
              const Text(
                'Experience Controls',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                value: settingsProvider.translateUiCopy,
                onChanged: settingsProvider.setTranslateUiCopy,
                activeColor: Colors.green,
                title: const Text('Translate UI copy'),
                subtitle: const Text(
                  'Render text and labels in the selected language',
                ),
                secondary: const Icon(Icons.translate),
                dense: true,
              ),
              SwitchListTile(
                value: settingsProvider.autoPlayAudio,
                onChanged: settingsProvider.setAutoPlayAudio,
                activeColor: Colors.green,
                title: const Text('Auto play audio'),
                subtitle: const Text('Play phrases automatically when tapped'),
                secondary: const Icon(Icons.volume_up),
                dense: true,
              ),
              SwitchListTile(
                value: settingsProvider.highlightKeyPhrases,
                onChanged: settingsProvider.setHighlightKeyPhrases,
                activeColor: Colors.green,
                title: const Text('Highlight key phrases'),
                subtitle: const Text('Emphasize new vocabulary across the app'),
                secondary: const Icon(Icons.highlight),
                dense: true,
              ),
              const SizedBox(height: 20),
              const Text(
                'Permissions & Support',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: const Icon(Icons.shield),
                title: const Text('Manage app permissions'),
                subtitle: const Text(
                  'Ensure microphone, storage, and audio can run',
                ),
                trailing: TextButton(
                  onPressed: openAppSettings,
                  child: const Text('Open'),
                ),
                onTap: openAppSettings,
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: const Icon(Icons.support_agent),
                title: const Text('Contact support'),
                subtitle: const Text('Report issues or ask about app features'),
                trailing: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email support@bridgingbarn.com'),
                      ),
                    );
                  },
                  child: const Text('Email'),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email support@bridgingbarn.com'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Language packs refreshed')),
                  );
                },
                child: const Text('Refresh language packs'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageTile(AppLanguageProvider provider) {
    final language = provider.language;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: const Text('App language'),
      subtitle: Text('${language.flag} ${language.name}'),
      trailing: DropdownButton<LanguageDefinition>(
        value: language,
        dropdownColor: ThemeColors.primary,
        style: const TextStyle(color: Colors.white),
        underline: const SizedBox.shrink(),
        items: LanguageUtils.languages
            .map(
              (language) => DropdownMenuItem(
                value: language,
                child: Text('${language.flag} ${language.name}'),
              ),
            )
            .toList(),
        onChanged: (language) {
          if (language != null) {
            provider.setLanguage(language);
          }
        },
      ),
    );
  }
}
