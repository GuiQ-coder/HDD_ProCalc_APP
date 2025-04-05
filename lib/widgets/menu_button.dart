import 'package:flutter/material.dart';
import 'package:test_hdd_app/screens/submenu/submenu_page.dart'; // Importa SubMenuPage

class MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final BuildContext context;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const MenuButton({
    super.key,
    required this.label,
    required this.icon,
    required this.context,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 100, // Ancho mínimo
        maxWidth: 300, // Ancho máximo
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondary,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48), // Padding interno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(0, 50), // Altura fija pero ancho flexible
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubMenuPage(label),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min, // Hace que el Row no ocupe todo el ancho
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}