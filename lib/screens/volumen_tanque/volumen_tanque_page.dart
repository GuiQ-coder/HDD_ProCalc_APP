import 'package:flutter/material.dart';

class VolumenTanquePage extends StatefulWidget {
  const VolumenTanquePage({super.key});
  @override
  VolumenTanquePageState createState() => VolumenTanquePageState();
}

class VolumenTanquePageState extends State<VolumenTanquePage> {
  double _alto = 0.0;
  double _ancho = 0.0;
  double _largo = 0.0;
  double _volumen = 0.0;

  void _calcularVolumen() {
    setState(() {
      _volumen = _alto * _ancho * _largo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volumen del Tanque'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Alto (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _alto = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Ancho (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _ancho = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Largo (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _largo = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularVolumen,
              child: Text('Calcular Volumen'),
            ),
            SizedBox(height: 20),
            Text(
              'Volumen: ${_volumen.toStringAsFixed(2)} m³',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
