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
            style: ElevatedButton.styleFrom(
               backgroundColor: Theme.of(context).colorScheme.secondary,
               foregroundColor: Colors.white,
               padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
               ),
             ),
             child: Text(
               'CALCULAR',
               style: TextStyle(
                 fontSize: 16,
                 fontWeight: FontWeight.bold,
               ),
            ),
          ),
          SizedBox(height: 20),

            Image.asset(
             'assets/icon/profdist_es.png',
             height: 150,
             fit: BoxFit.contain,
             errorBuilder: (context, error, stackTrace) => Icon(
               Icons.engineering,
               size: 100,
               color: Colors.blue,
             ),
            ),

            SizedBox(height: 25),

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
