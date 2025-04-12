import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FlotabilidadPage extends StatefulWidget {
  const FlotabilidadPage({super.key});
  @override
  FlotabilidadPageState createState() => FlotabilidadPageState();
}

class FlotabilidadPageState extends State<FlotabilidadPage> {
  double _diametro = 0.0;
  double _pesoTubo = 0.0;
  double _pesoLodo = 0.0;
  double _largo = 0.0;
  double _flotabilidad = 0.0;
  double _pullbackForce = 0.0;

  void _calcular() {
    setState(() {
      double areaSeccion = (3.1416 / 4) * (_diametro * _diametro);
      _flotabilidad = areaSeccion * _largo * _pesoLodo;
      _pullbackForce = _pesoTubo * _largo - _flotabilidad;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.buoyancyCalculator),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contenedor principal para las imágenes y descripciones
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  // Fila de imágenes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Imagen y texto de flotabilidad
                      Flexible(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icon/flotabilidadimg.png',
                              height: 120,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.bubble_chart,
                                size: 60,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              l10n.buoyancy,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Imagen y texto de fuerza de jalado
                      Flexible(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icon/fuerzajaladoimg.png',
                              height: 120,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.bolt,
                                size: 60,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              l10n.pullbackForce,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Descripción combinada debajo de las imágenes
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      l10n.buoyancyDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            // Campos de entrada
            TextField(
              decoration: InputDecoration(labelText: l10n.diameter),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _diametro = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            
            TextField(
              decoration: InputDecoration(labelText: l10n.pipeWeightFlotabilidad),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _pesoTubo = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            SizedBox(height: 10),
            
            TextField(
              decoration: InputDecoration(labelText: l10n.mudWeight),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _pesoLodo = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, bottom: 10),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                  ),
                  children: [
                    TextSpan(text: l10n.typicalRange),
                    TextSpan(
                      text: l10n.rangeValues,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: l10n.equivalentToFlotabilidad),
                    TextSpan(text: l10n.bentonite),
                    TextSpan(text: l10n.polymers),
                    TextSpan(text: l10n.pureWater),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15),
            
            TextField(
              decoration: InputDecoration(labelText: l10n.length),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _largo = double.tryParse(value) ?? 0.0;
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
                l10n.calculate,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Resultados
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      l10n.buoyancyResult(_flotabilidad.toStringAsFixed(2)),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      l10n.pullbackForceResult(_pullbackForce.toStringAsFixed(2)),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}