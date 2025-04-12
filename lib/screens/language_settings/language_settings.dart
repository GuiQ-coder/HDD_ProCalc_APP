import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:test_hdd_app/providers/locale_provider.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
        backgroundColor: theme.colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectLanguage,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            _buildLanguageTile(
              context: context,
              locale: const Locale('es'),
              languageName: 'Español',
              currentLocale: localeProvider.locale,
              onChanged: (newLocale) {
                localeProvider.setLocale(newLocale);
              },
            ),
            _buildLanguageTile(
              context: context,
              locale: const Locale('en'),
              languageName: 'English',
              currentLocale: localeProvider.locale,
              onChanged: (newLocale) {
                localeProvider.setLocale(newLocale);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required Locale locale,
    required String languageName,
    required Locale currentLocale,
    required ValueChanged<Locale> onChanged,
  }) {
    final theme = Theme.of(context);
    final isSelected = locale.languageCode == currentLocale.languageCode;

    return Card(
      color: isSelected 
          ? theme.colorScheme.secondary.withOpacity(0.2)
          : theme.colorScheme.surface,
      elevation: 2,
      child: ListTile(
        leading: Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected ? theme.colorScheme.secondary : theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        title: Text(
          languageName,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Text(
          locale.languageCode.toUpperCase(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        onTap: () => onChanged(locale),
      ),
    );
  }
}