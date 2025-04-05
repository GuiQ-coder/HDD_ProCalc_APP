import 'package:flutter/material.dart';
import 'package:test_hdd_app/widgets/menu_button.dart';



class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'label': 'Perforador', 'icon': Icons.construction},
      {'label': 'Navegador', 'icon': Icons.explore},
      {'label': 'Fluidos', 'icon': Icons.water},
      {'label': 'Todo', 'icon': Icons.format_list_bulleted},
      {'label': 'Opciones', 'icon': Icons.settings},
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              const SizedBox(height: 140), // Espacio superior
              
              // Logo Arriba
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
              
              // Botones en columna
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
