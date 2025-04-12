import 'package:flutter/material.dart';

class SubMenuCard extends StatelessWidget {
  final Map<String, dynamic> option;
  final String displayName;
  final BuildContext context;

  const SubMenuCard({
    super.key,
    required this.option,
    required this.displayName,
    required this.context,
  });

 
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(170, 0, 0, 0.5),
      child: InkWell(
        onTap: () {
          if (option['route'] != null) {
            Navigator.pushNamed(context, option['route']);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 150,
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
                    : Icon(option['icon'] as IconData, size: 48, color: Colors.white),
                const SizedBox(height: 10),
                SizedBox(
                  width: 100,
                  child: Text(
                    displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: displayName.length > 15 ? 14 : 16,
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
      ),
    );
  }
}