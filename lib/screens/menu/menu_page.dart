import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_hdd_app/widgets/menu_button.dart';
import 'package:test_hdd_app/screens/submenu/submenu_page.dart';
import 'package:test_hdd_app/constants/category_ids.dart';

class MenuItem {
  final String id;
  final IconData icon;

  MenuItem({required this.id, required this.icon});
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
  final List<MenuItem> menuItems = [
    MenuItem(id: CategoryIds.driller, icon: Icons.construction),
    MenuItem(id: CategoryIds.navigator, icon: Icons.explore),
    MenuItem(id: CategoryIds.fluids, icon: Icons.water),
    MenuItem(id: 'all', icon: Icons.format_list_bulleted),
    MenuItem(id: CategoryIds.settings, icon: Icons.settings),
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
                children: menuItems.map((MenuItem item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Column(
                      children: [
                        MenuButton(
                          label: _getCategoryName(item.id, l10n),
                          icon: item.icon,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          onPressed: () => _navigateToSubMenu(context, item.id),
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

  String _getCategoryName(String id, AppLocalizations l10n) {
    switch(id) {
      case CategoryIds.driller: return l10n.driller;
      case CategoryIds.navigator: return l10n.navigator;
      case CategoryIds.fluids: return l10n.fluids;
      case CategoryIds.settings: return l10n.settings;
      case 'all': return l10n.allItems;
      default: return id;
    }
  }

  void _navigateToSubMenu(BuildContext context, String categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubMenuPage(categoryId: categoryId),
      ),
    );
  }
}