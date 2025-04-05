import 'package:flutter/material.dart';

class TablaCurvasTuberiasPage extends StatelessWidget {
  const TablaCurvasTuberiasPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla de Curvas de Tuberías'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Diámetro (pulgadas)')),
            DataColumn(label: Text('Radio de curvatura (m)')),
            DataColumn(label: Text('Grados por tubo')),
            DataColumn(label: Text('Porcentaje por barra')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('2 3/8"')),
              DataCell(Text('30.0')),
              DataCell(Text('12.0°')),
              DataCell(Text('3.33%')),
            ]),
            DataRow(cells: [
              DataCell(Text('2 7/8"')),
              DataCell(Text('35.0')),
              DataCell(Text('10.0°')),
              DataCell(Text('2.86%')),
            ]),
            // Agrega más filas según sea necesario
          ],
        ),
      ),
    );
  }
}

