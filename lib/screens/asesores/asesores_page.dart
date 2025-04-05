import 'package:flutter/material.dart';

class AsesoresPage extends StatelessWidget {
  const AsesoresPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asesores'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Asesor 1'),
            subtitle: Text('Contacto: asesor1@example.com'),
            onTap: () {
              // Aquí puedes abrir un correo o redirigir a una página de contacto
            },
          ),
          ListTile(
            title: Text('Asesor 2'),
            subtitle: Text('Contacto: asesor2@example.com'),
            onTap: () {
              // Aquí puedes abrir un correo o redirigir a una página de contacto
            },
          ),
          // Agrega más asesores aquí
        ],
      ),
    );
  }
}