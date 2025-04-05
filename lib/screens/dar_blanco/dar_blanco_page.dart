import 'package:flutter/material.dart';
import 'dart:math';

class DarEnElBlancoPage extends StatefulWidget {
  const DarEnElBlancoPage({super.key});
  @override
  DarEnElBlancoPageState createState() => DarEnElBlancoPageState();
}

class DarEnElBlancoPageState extends State<DarEnElBlancoPage> {
  double _profundidadActual = 0.0;
  double _porcentajeActual = 0.0;
  double _distanciaHorizontal = 0.0;
  double _profundidadRequerida = 0.0;
  double _anguloNecesario = 0.0;

  void _calcular() {
    setState(() {
      // Fórmula corregida
      _anguloNecesario = atan((_profundidadRequerida - _profundidadActual) / _distanciaHorizontal) * (180 / pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dar en el Blanco'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Profundidad actual (cm)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _profundidadActual = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Porcentaje actual'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _porcentajeActual = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Distancia horizontal (cm)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _distanciaHorizontal = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Profundidad requerida (cm)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _profundidadRequerida = double.tryParse(value) ?? 0.0;
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
              'Ángulo necesario: ${_anguloNecesario.toStringAsFixed(2)}°',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
