import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_hdd_app/screens/submenu/submenu_options.dart';
import 'package:test_hdd_app/constants/category_ids.dart';

class SubMenuPage extends StatelessWidget {
  final String categoryId;

  const SubMenuPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
   
    final bool isLanguageSettings = categoryId == 'language';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCategoryTitle(categoryId, l10n)),
      ),
      body: isLanguageSettings
          ? ListView(
              children: getOptions(categoryId, context),
            )
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(8),
              children: getOptions(categoryId, context),
            ),
    );
  }

  String _getCategoryTitle(String categoryId, AppLocalizations l10n) {
    switch(categoryId) {
      case CategoryIds.driller: return l10n.driller;
      case CategoryIds.navigator: return l10n.navigator;
      case CategoryIds.fluids: return l10n.fluids;
      case CategoryIds.settings: return l10n.settings;
      case 'all': return l10n.allItems;
      default: return categoryId;
    }
  }
}