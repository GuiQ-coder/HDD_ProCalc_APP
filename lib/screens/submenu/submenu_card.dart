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
        onTap: () => navigateToRoute(context, option['route']),
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
            Text(
              option['name'],
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}