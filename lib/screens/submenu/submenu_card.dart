import 'package:flutter/material.dart';
import 'package:test_hdd_app/configuration/navigation_utils.dart';

class SubMenuCard extends StatelessWidget {
  final Map<String, dynamic> option;
  final BuildContext context;

  const SubMenuCard({
    super.key,
    required this.option,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(170, 0, 0, 0.5),
      child: InkWell(
        onTap: () => option['route'] != null 
            ? navigateToRoute(context, option['route'])
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              option['icon'] is String
                  ? Image.asset(
                      option['icon'],
                      width: 64,
                      height: 64,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 48),
                    )
                  : Icon(option['icon'], size: 48, color: Colors.white),
              const SizedBox(height: 10),
              SizedBox(
                width: 100, // Ancho fijo para alinear todas las tarjetas
                child: Text(
                  option['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: option['name'].length > 15 ? 14 : 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}