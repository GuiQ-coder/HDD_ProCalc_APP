import 'package:flutter/material.dart';

class FluidoNecesarioPage extends StatefulWidget {
  const FluidoNecesarioPage({super.key});
  @override
  FluidoNecesarioPageState createState() => FluidoNecesarioPageState();
}

class FluidoNecesarioPageState extends State<FluidoNecesarioPage> {
  double _diametro = 0.0;
  double _longitud = 0.0;
  double _volumenTunel = 0.0;
  double _aguaMinima = 0.0;
  double _volumenRecorte = 0.0;

  void _calcular() {
    setState(() {
      double radio = _diametro / 2;
      _volumenTunel = 3.1416 * radio * radio * _longitud;
      _aguaMinima = _volumenTunel * 0.1; // 10% del volumen del túnel
      _volumenRecorte = _volumenTunel * 0.05; // 5% del volumen del túnel
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fluido Necesario'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Diámetro (pulgadas)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _diametro = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Longitud (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _longitud = double.tryParse(value) ?? 0.0;
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
              'Volumen del túnel final: ${_volumenTunel.toStringAsFixed(2)} m³',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Agua mínima requerida: ${_aguaMinima.toStringAsFixed(2)} m³',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Volumen total de recorte: ${_volumenRecorte.toStringAsFixed(2)} m³',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
