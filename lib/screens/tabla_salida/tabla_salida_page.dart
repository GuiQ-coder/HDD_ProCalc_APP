import 'package:flutter/material.dart';



class TablaSalidasPage extends StatefulWidget {
  const TablaSalidasPage({super.key});
  @override
  TablaSalidasPageState createState() => TablaSalidasPageState();
}

class TablaSalidasPageState extends State<TablaSalidasPage> {
  int _numeroBarra = 0;
  double _flexion = 0.0;
  double _inicial = 0.0;
  double _salida = 0.0;
  double _largoBarra = 0.0;
  double _elevacion = 0.0;
  List<Map<String, dynamic>> _tabla = [];

  void _calcular() {
    setState(() {
      _tabla = List.generate(_numeroBarra, (index) {
        double flexionActual = _flexion * (index + 1);
        double salidaActual = _salida * (index + 1);
        double elevacionActual = _elevacion * (index + 1);
        return {
          'Barra': index + 1,
          'Flexión': flexionActual.toStringAsFixed(2),
          'Salida': salidaActual.toStringAsFixed(2),
          'Elevación': elevacionActual.toStringAsFixed(2),
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla de Salidas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Número de barra'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numeroBarra = int.tryParse(value) ?? 0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Flexión (%)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _flexion = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Inicial (%)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _inicial = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Salida (%)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _salida = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Largo de barra (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _largoBarra = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Elevación'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _elevacion = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Barra')),
                    DataColumn(label: Text('Flexión (%)')),
                    DataColumn(label: Text('Salida (%)')),
                    DataColumn(label: Text('Elevación')),
                  ],
                  rows: _tabla.map((data) {
                    return DataRow(cells: [
                      DataCell(Text(data['Barra'].toString())),
                      DataCell(Text(data['Flexión'])),
                      DataCell(Text(data['Salida'])),
                      DataCell(Text(data['Elevación'])),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
