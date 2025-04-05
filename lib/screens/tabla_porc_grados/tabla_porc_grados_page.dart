import 'package:flutter/material.dart';
import 'dart:math';

class TablaGradosPorcentajePage extends StatelessWidget {
  const TablaGradosPorcentajePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla de Conversión de Grados a Porcentaje'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Grados')),
            DataColumn(label: Text('Porcentaje')),
          ],
          rows: List.generate(90, (index) {
            double grados = index + 1;
            double porcentaje = tan(grados * 3.1416 / 180) * 100;
            return DataRow(cells: [
              DataCell(Text('$grados°')),
              DataCell(Text('${porcentaje.toStringAsFixed(2)}%')),
            ]);
          }),
        ),
      ),
    );
  }
}
