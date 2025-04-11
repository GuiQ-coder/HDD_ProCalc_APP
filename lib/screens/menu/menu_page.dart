import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:test_hdd_app/widgets/menu_button.dart';
import 'package:test_hdd_app/providers/locale_provider.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final menuItems = [
      {'label': l10n.driller, 'icon': Icons.construction},
      {'label': l10n.navigator, 'icon': Icons.explore},
      {'label': l10n.fluids, 'icon': Icons.water},
      {'label': l10n.allItems, 'icon': Icons.format_list_bulleted},
      {'label': l10n.settings, 'icon': Icons.settings},
    ];

    return Scaffold(

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              const SizedBox(height: 140),
              
              
              Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/iconApp/IconApp.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              const SizedBox(height: 64),
              
              
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: menuItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal:80),
                      child: Column(
                        children: [
                          MenuButton(
                            label: item['label'] as String,
                            icon: item['icon'] as IconData,
                            context: context,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),

                          const SizedBox(height: 16),
                        
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
