import 'package:flutter/material.dart';

class ProfundidadDistanciaPage extends StatefulWidget {
  const ProfundidadDistanciaPage({super.key});
  @override
  ProfundidadDistanciaPageState createState() => ProfundidadDistanciaPageState();
}

class ProfundidadDistanciaPageState extends State<ProfundidadDistanciaPage> {
  double _pendiente = 0.0;
  double _distancia = 0.0;
  double _profundidad = 0.0;

  void _calcular() {
    setState(() {
      _profundidad = _pendiente * _distancia / 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profundidad por Distancia'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Pendiente (%)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _pendiente = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Distancia (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _distancia = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            Text(
              'Profundidad: ${_profundidad.toStringAsFixed(2)} metros',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
