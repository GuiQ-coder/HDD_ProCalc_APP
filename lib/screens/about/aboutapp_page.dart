import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de a aplicación'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('HDD Pro Calc APP'),
            subtitle: Text('HDD ProCalc is a professional mobile application developed with Flutter to create a cross-platform solution (iOS and Android) designed to assist technicians, engineers, and professionals in the Horizontal Directional Drilling (HDD) industry. The app provides essential calculations, reference manuals, and utilities to optimize drilling operations, improve accuracy, and reduce errors in the field.'),
            onTap: () {

            },
          ),
        ]),
      );
    }
   }