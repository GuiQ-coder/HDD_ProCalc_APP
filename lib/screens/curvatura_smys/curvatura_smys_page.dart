import 'package:flutter/material.dart';

class RadioSMYSPage extends StatefulWidget {
  const RadioSMYSPage({super.key});
  @override
  RadioSMYSPageState createState() => RadioSMYSPageState();
}

class RadioSMYSPageState extends State<RadioSMYSPage> {
  double _diametro = 0.0;
  double _limiteCedencia = 0.0;
  double _longitudTubo = 0.0;
  double _radioCurvatura = 0.0;
  double _gradosPorTubo = 0.0;
  double _porcentajePorBarra = 0.0;

  void _calcular() {
    setState(() {
      _radioCurvatura = (_diametro * 1000) / (2 * _limiteCedencia);
      _gradosPorTubo = 360 / (_longitudTubo / _radioCurvatura);
      _porcentajePorBarra = (_gradosPorTubo / 360) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Radio por SMYS'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
                        // Imagen representativa
                  Image.asset(
                    'assets/icon/radiocurvatura.png',
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.circle_outlined,
                      size: 100,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 16),
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
              decoration: InputDecoration(labelText: 'Límite de cedencia (PSI)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _limiteCedencia = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Longitud del tubo (metros)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _longitudTubo = double.tryParse(value) ?? 0.0;
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
          SizedBox(height: 16),
            Text(
              'Radio de curvatura: ${_radioCurvatura.toStringAsFixed(2)} m',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Grados por tubo: ${_gradosPorTubo.toStringAsFixed(2)}°',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Porcentaje por barra: ${_porcentajePorBarra.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
