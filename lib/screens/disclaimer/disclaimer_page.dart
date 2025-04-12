import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../providers/locale_provider.dart';
import 'package:test_hdd_app/screens/menu/menu_page.dart';

class DisclaimerPage extends StatefulWidget {
  const DisclaimerPage({super.key});

  @override
  State<DisclaimerPage> createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  bool _isAccepted = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context, theme, l10n),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Text(
                      l10n.disclaimerText,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          _buildBottomSection(context, theme, l10n),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return AppBar( // Retorna directamente un AppBar
      title: Text(
        l10n.disclaimerTitle,
        style: theme.textTheme.headlineMedium,
      ),
      backgroundColor: theme.colorScheme.secondary,
      toolbarHeight: 80,
      actions: [
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {
            final provider = Provider.of<LocaleProvider>(context, listen: false);
            final newLocale = provider.locale.languageCode == 'es' 
                ? const Locale('en') 
                : const Locale('es');
            provider.setLocale(newLocale);
          },
        ),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _isAccepted,
                onChanged: (bool? value) => setState(() => _isAccepted = value ?? false),
                activeColor: theme.colorScheme.secondary,
              ),
              Text(l10n.acceptTerms, style: theme.textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isAccepted
                ? () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MenuPage()),
                      (Route<dynamic> route) => false,
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: theme.colorScheme.onSecondary,
              backgroundColor: _isAccepted
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.secondary.withOpacity(0.5),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.continueButton),
          ),
        ],
      ),
    );
  }
}