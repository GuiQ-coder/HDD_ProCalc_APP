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

            SizedBox(height: 30,),

            Image.asset(
             'assets/icon/volcuadradoimg.png',
             height: 150,
             fit: BoxFit.contain,
             errorBuilder: (context, error, stackTrace) => Icon(
               Icons.engineering,
               size: 100,
               color: Colors.blue,
             ),
            ),

          SizedBox(height: 20),

           ElevatedButton(
            onPressed: _calcularVolumen,
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
          SizedBox(height: 16),
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
