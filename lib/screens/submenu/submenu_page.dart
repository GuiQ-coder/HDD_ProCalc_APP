import 'package:flutter/material.dart';
import 'package:test_hdd_app/screens/submenu/submenu_options.dart';

class SubMenuPage extends StatelessWidget {
  final String title;
  const SubMenuPage(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: getOptions(title, context),
        ),
      ),
    );
  }
}