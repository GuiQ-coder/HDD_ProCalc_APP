import 'package:flutter/material.dart';

class EspacioAnularPage extends StatefulWidget {
  const EspacioAnularPage({super.key});
  @override
  EspacioAnularPageState createState() => EspacioAnularPageState();
}

class EspacioAnularPageState extends State<EspacioAnularPage> {
  double _diametroMayor = 0.0;
  double _diametroMenor = 0.0;
  double _longitud = 0.0;
  double _volumen = 0.0;

  void _calcularVolumen() {
    setState(() {
      double radioMayor = _diametroMayor / 2;
      double radioMenor = _diametroMenor / 2;
      _volumen = 3.1416 * (radioMayor * radioMayor - radioMenor * radioMenor) * _longitud;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espacio Anular'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Diámetro mayor (pulgadas)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _diametroMayor = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Diámetro menor (pulgadas)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _diametroMenor = double.tryParse(value) ?? 0.0;
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
