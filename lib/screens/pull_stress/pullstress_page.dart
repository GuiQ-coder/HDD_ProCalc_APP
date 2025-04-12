import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

class PullStressHDPEPage extends StatefulWidget {
  const PullStressHDPEPage({super.key});
  @override
  PullStressHDPEPageState createState() => PullStressHDPEPageState();
}

class PullStressHDPEPageState extends State<PullStressHDPEPage> {
  double _diametroExterno = 0.0;
  double _espesorPared = 0.0;
  double _resultado = 0.0;
  String _tipoMaterial = 'PE100';
  String _errorMessage = '';

  final Map<String, double> resistenciaMaterial = {
    'PE100': 25.0,
    'PE80': 20.0,
  };

  void _calcularResistencia() {
    setState(() {
      if (_diametroExterno <= 0 || _espesorPared <= 0) {
        _errorMessage = AppLocalizations.of(context)!.invalidValuesError;
        _resultado = 0.0;
        return;
      }
      
      if (_espesorPared >= _diametroExterno / 2) {
        _errorMessage = AppLocalizations.of(context)!.thicknessError;
        _resultado = 0.0;
        return;
      }
      
      _errorMessage = '';
      double resistencia = resistenciaMaterial[_tipoMaterial] ?? 25.0;
      double areaSeccion = pi * (_diametroExterno - _espesorPared) * _espesorPared;
      _resultado = resistencia * areaSeccion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hdpePullStrengthCalculator),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/icon/pipeline.png',
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.error,
                      size: 100,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  Text(
                    l10n.hdpeDescription,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  
                  // Selector de material
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _tipoMaterial,
                      isExpanded: true,
                      underline: SizedBox(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                      ),
                      items: resistenciaMaterial.keys.map((String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text('${l10n.materialType}: $key (${resistenciaMaterial[key]} MPa)'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _tipoMaterial = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Campo de diámetro externo
                  TextField(
                    decoration: InputDecoration(
                      labelText: l10n.outerDiameterPS,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _diametroExterno = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, left: 12),
                    child: Text(
                      l10n.exampleDiameter,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Campo de espesor de pared
                  TextField(
                    decoration: InputDecoration(
                      labelText: l10n.wallThickness,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _espesorPared = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4, left: 12),
                    child: Text(
                      l10n.exampleThickness,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  

                  ElevatedButton(
                    onPressed: _calcularResistencia,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.calculateStrength,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Mostrar error si existe
                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(
                          color: Colors.red[800],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  // Resultado
                  Card(
                    margin: EdgeInsets.only(top: 20),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            l10n.maxTensileStrength,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            l10n.newtons(_resultado.toStringAsFixed(2)),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),

                          Text(
                            l10n.kilonewtons((_resultado / 1000).toStringAsFixed(2)),
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Ficha técnica
                  ExpansionTile(
                    title: Text(
                      l10n.technicalInfo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.purposeTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              l10n.purposePoints,
                              style: TextStyle(height: 1.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              l10n.formulaTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              l10n.formulaText,
                              style: TextStyle(height: 1.5),
                            ),
                            SizedBox(height: 16),
                            Text(
                              l10n.recommendationsTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              l10n.recommendationsText,
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}